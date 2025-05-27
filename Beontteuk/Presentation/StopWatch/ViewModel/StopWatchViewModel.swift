//
//  StopWatchViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

final class StopWatchViewModel {

    typealias Section = StopWatchSection
    typealias Item = StopWatchItem
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Action, State

    struct Action {
        let viewDidLoad = PublishRelay<Void>()
        let buttonAction = PublishRelay<ButtonAction>()
        let stopWatchAction = PublishRelay<StopWatchAction>()
    }

    struct State {
        let snapshotRelay = BehaviorRelay<Snapshot?>(value: nil)
        let stopWatchButtonRelay = BehaviorRelay<StopWatchState>(value: .initial)
        var stopWatchTimeLabelRelay = BehaviorRelay<String>(value: "00:00.00")

        let lapsRelay = BehaviorRelay<[LapRecordEntity]>(value: [])

        var currentLapTimeRelay = BehaviorRelay<[TimeInterval]>(value: [])
    }

    // MARK: - Properties

    var action = Action()
    var state = State()
    private let mainDisposeBag = DisposeBag()
    private var stopWatchDisposeBag = DisposeBag()

    private var startTime: Date?
    private var elapsedTime: TimeInterval = .zero
    private var session: StopWatchEntity?

    private let stopWatchUseCase: StopWatchUseInt
    private let lapRecordUseCase: LapRecordUseInt

    // MARK: - Initializer, Deinit, requiered

    init(
        stopWatchUseCase: StopWatchUseInt,
        lapRecordUseCase: LapRecordUseInt
    ) {
        self.stopWatchUseCase = stopWatchUseCase
        self.lapRecordUseCase = lapRecordUseCase

        bindAction()
    }

    // MARK: - Snapshot

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.laps])

        var item = [Item]()
        let laps = state.lapsRelay.value.sorted { $0.lapIndex < $1.lapIndex }
        laps.forEach {
            item.append(.lap($0))
        }

        state.snapshotRelay.accept(snapshot)
    }

    // MARK: - Bind

    private func bindAction() {
        // 1. View Lifecycle
        action.viewDidLoad
            .bind { [weak self] _ in
                guard let self else { return }
                session = stopWatchUseCase.fetchLastSession()
                if let session = session {
                    state.lapsRelay.accept(session.laps)
                    updateSnapshot()
                }
            }
            .disposed(by: mainDisposeBag)

        // 2. Button Action
        action.buttonAction
            .bind { [weak self] action in
                guard let self else { return }
                handleButtonAction(action)
            }
            .disposed(by: mainDisposeBag)

        // 3. Lap/Reset은 여전히 따로 action 분기 가능
        action.stopWatchAction
            .bind { [weak self] action in
                guard let self else { return }
                switch action {
                case .lap:
                    self.lap()
                case .reset:
                    self.resetStopwatch()
                default:
                    break // start/pause는 아래로 옮김
                }
            }
            .disposed(by: mainDisposeBag)
    }

    private func handleButtonAction(_ action: ButtonAction) {
        let currentState = state.stopWatchButtonRelay.value
        switch action {
        case .leftButton:
            switch currentState {
            case .initial:
                break // 비활성
            case .progress:
                lap() // 직접 처리
            case .pause:
                resetStopwatch()
            }

        case .rightButton:
            switch currentState {
            case .initial, .pause:
                startStopwatch()
                break
            case .progress:
                pauseStopwatch()
                break
            }
        }
    }

    private func updateStopWatchButton(to newState: StopWatchState) {
        guard state.stopWatchButtonRelay.value != newState else { return }
        print("[STATE] 상태 변경: \(state.stopWatchButtonRelay.value) → \(newState)")
        state.stopWatchButtonRelay.accept(newState)
    }
    private var isTransitioning = false

    private func startStopwatch() {
        guard !isTransitioning else { return }
        isTransitioning = true
        defer { isTransitioning = false }

        guard state.stopWatchButtonRelay.value != .progress else { return }

        print("[DEBUG] startStopwatch() called")
        updateStopWatchButton(to: .progress)

        if let session = session {
            print("[DEBUG] 기존 session 사용: \(session.id)")
            stopWatchUseCase.updateSession(by: session.id, with: Date())
        } else {
            session = stopWatchUseCase.createSession()
        }

        startTime = Date() - elapsedTime
        stopWatchDisposeBag = DisposeBag()

        Observable<Int>.timer(.seconds(0), period: .milliseconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self, let startTime = self.startTime else { return }
                let formatted = self.makeFormattedString(with: startTime)
                self.state.stopWatchTimeLabelRelay.accept(formatted)
            })
            .disposed(by: stopWatchDisposeBag)
    }

    private func pauseStopwatch() {
        guard state.stopWatchButtonRelay.value != .pause else { return }
        guard let startTime else { return }

        elapsedTime = Date().timeIntervalSince(startTime)
        stopWatchDisposeBag = DisposeBag()
        updateStopWatchButton(to: .pause)

        if let session {
            stopWatchUseCase.updateSession(by: session.id, with: elapsedTime)
        }
    }

    private func resetStopwatch() {
        stopWatchDisposeBag = DisposeBag()
        startTime = nil
        elapsedTime = .zero

        let formatted = makeFormattedString(with: Date())
        state.stopWatchTimeLabelRelay.accept(formatted)
        updateStopWatchButton(to: .initial)

        if let session {
            stopWatchUseCase.deleteSession(by: session.id)
            self.session = nil
        }

        state.lapsRelay.accept([])
        state.currentLapTimeRelay.accept([])
        updateSnapshot()
    }

    private func lap() {
        guard let startTime else { return }
        let totalElapsed = calculateTimeInterval(with: startTime)
        let previous = state.currentLapTimeRelay.value.last ?? 0
        let lapInterval = totalElapsed - previous

        addLapTime(totalElapsed)

        if let session {
            let _ = lapRecordUseCase.createLap(
                for: session.id,
                lapIndex: state.currentLapTimeRelay.value.count,
                lapTime: lapInterval,
                absoluteTime: totalElapsed
            )
            state.lapsRelay.accept(session.laps)
            updateSnapshot()
        }
    }

    // MARK: - Methods

    private func addLapTime(_ lapTime: TimeInterval) {
        let previouLapTimes = state.currentLapTimeRelay.value
        state.currentLapTimeRelay.accept(previouLapTimes + [lapTime])
    }

    private func calculateTimeInterval(
        since standardTime: Date = Date(),
        with startTime: Date
    ) -> TimeInterval {
        standardTime.timeIntervalSince(startTime)
    }

    private func makeFormattedString(
        since timeInterval: TimeInterval? = nil,
        with startTime: Date? = nil
    ) -> String {
        let elapsed: TimeInterval
        if let timeInterval  {
            elapsed = timeInterval
        } else {
            guard let startTime else { return "" }
            elapsed = Date().timeIntervalSince(startTime)
        }

        let minute = Int(elapsed) / 60
        let second = Int(elapsed) % 60
        let sentiSecond = Int((elapsed - floor(elapsed)) * 100)

        return String(
            format: "%02d:%02d.%02d",
            minute, second, sentiSecond
        )
    }
}
