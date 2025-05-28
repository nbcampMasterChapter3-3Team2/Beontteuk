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
        let laps = state.lapsRelay.value.sorted { $0.lapIndex > $1.lapIndex }
        laps.forEach {
            item.append(.lap($0))
        }
        snapshot.appendItems(item)

        state.snapshotRelay.accept(snapshot)
    }

    // MARK: - Bind

    private func bindAction() {
        // MARK: View Life Cycle Action
        action.viewDidLoad
            .bind { [weak self] _ in
                guard let self else { return }
                session = stopWatchUseCase.fetchLastSession()

                print("VIEW DID LOAD: \(session)")

                if let session = session {
                    elapsedTime = session.elapsedBeforePause
                    let timeInterval = makeFormattedString(since: elapsedTime)
                    state.stopWatchTimeLabelRelay.accept(timeInterval)

                    state.lapsRelay.accept(session.laps)
                    updateSnapshot()
                } else {

                }
            }.disposed(by: mainDisposeBag)

        // MARK: Button Action
        action.buttonAction
            .bind { [weak self] action in
                guard let self else { return }

                let timeState = state.stopWatchButtonRelay.value

                switch action {
                case .leftButton:
                    switch timeState {
                    case .initial:
                        break
                    case .progress:
                        self.action.stopWatchAction.accept(.lap)
                    case .pause:
                        self.action.stopWatchAction.accept(.reset)
                        self.state.stopWatchButtonRelay.accept(.initial)
                    }

                case .rightButton:
                    switch timeState {
                    case .initial:
                        self.action.stopWatchAction.accept(.start)
                        self.state.stopWatchButtonRelay.accept(.progress)
                    case .progress:
                        self.action.stopWatchAction.accept(.pause)
                        self.state.stopWatchButtonRelay.accept(.pause)
                    case .pause:
                        self.action.stopWatchAction.accept(.start)
                        self.state.stopWatchButtonRelay.accept(.progress)
                    }
                }
            }.disposed(by: mainDisposeBag)

        // MARK: StopWatch Action
        action.stopWatchAction
            .bind { [weak self] action in
                guard let self else { return }
                switch action {
                case .start:
                    /// Session 생성 및 업데이트
                    if let session = session {
                        stopWatchUseCase.updateSession(
                            by: session.id,
                            with: Date()
                        )
                    } else {
                        session = stopWatchUseCase.createSession()
                    }
                    print("Session: \(session)")

                    /// 스톱워치 시작
                    startTime = Date() - elapsedTime
                    stopWatchDisposeBag = DisposeBag()

                    Observable<Int>.timer(
                        .seconds(.zero),
                        period: .milliseconds(10),
                        scheduler: MainScheduler.instance
                    ).subscribe(onNext: { [weak self] _ in
                        guard let self,
                              let startTime else { return }

                        let formattedTime = makeFormattedString(with: startTime)
                        state.stopWatchTimeLabelRelay.accept(formattedTime)

                    }, onCompleted: {
                        print("❗️구독이 완료되었습니다 (예상치 못한 완료)")
                    }, onDisposed: {
                        print("♻️ 구독이 dispose 되었습니다")
                    }).disposed(by: stopWatchDisposeBag)


                case .pause:
                    /// 스톱워치 일시정지
                    guard let startTime else { return }
                    elapsedTime = Date().timeIntervalSince(startTime)
                    stopWatchDisposeBag = DisposeBag()

                    // MARK: Session 의 누적 시간 (elapsedBeforePause) 업데이트
                    guard let session else { return }
                    stopWatchUseCase.updateSession(
                        by: session.id,
                        with: elapsedTime
                    )

                case .reset:
                    /// 스톱워치 재설정
                    stopWatchDisposeBag = DisposeBag()
                    startTime = nil
                    elapsedTime = .zero

                    let formattedTime = makeFormattedString(with: Date())
                    state.stopWatchTimeLabelRelay.accept(formattedTime)

                    /// 기존 Session 삭제
                    guard let session else { return }
                    stopWatchUseCase.deleteSession(by: session.id)

                    state.stopWatchTimeLabelRelay.accept("00:00.00")
                    state.currentLapTimeRelay.accept([])
                    state.lapsRelay.accept([])
                    updateSnapshot()

                case .lap:
                    /// 랩 찍기
                    guard let startTime else { return }
                    // 스톱워치의 현재까지의 시간
                    let totalElapsed = calculateTimeInterval(with: startTime)

                    // Lap 구간 시간 계산: 직전 누적값과의 차이
                    let previousLapTotal = state.currentLapTimeRelay.value.last ?? 0
                    let lapInterval = totalElapsed - previousLapTotal

                    // 누적 Lap 시간 저장
                    addLapTime(totalElapsed)

                    /// LapRecord 추가
                    guard let session else { return }
                    let count = state.currentLapTimeRelay.value.count
                    guard let newLap = lapRecordUseCase.createLap(
                        for: session.id,
                        lapIndex: state.currentLapTimeRelay.value.count,
                        lapTime: lapInterval,
                        absoluteTime: totalElapsed
                    ) else { return }

                    let previouLaps = state.lapsRelay.value
                    state.lapsRelay.accept(previouLaps + [newLap])
                    updateSnapshot()

                    // 삭제할 것
                    print("Created LAp: \(newLap)")
                }
            }.disposed(by: mainDisposeBag)
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
