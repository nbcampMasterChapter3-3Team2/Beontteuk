//
//  StopWatchViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation
import RxSwift
import RxRelay

enum ButtonAction {
    case leftButton
    case rightButton
}

enum StopWatchAction {
    case start
    case pause
    case reset
    case lap
}

enum StopWatchState {
    case initial
    case progress
    case pause
}

final class StopWatchViewModel {

    // MARK: - Action, State

    struct Action {
        let buttonAction = PublishRelay<ButtonAction>()
        let stopWatchAction = PublishRelay<StopWatchAction>()
    }

    struct State {
        let stopWatchRelay = BehaviorRelay<StopWatchState>(value: .initial)
        var formattedTimeRelay = BehaviorRelay<String>(value: "00:00.00")
        var currentLapTimeRelay = BehaviorRelay<[TimeInterval]>(value: [])
    }

    // MARK: - Properties

    var action = Action()
    var state = State()
    private let mainDisposeBag = DisposeBag()
    private var stopWatchDisposeBag = DisposeBag()

    private var startTime: Date?
    private var accumulatedTime: TimeInterval = .zero

    // MARK: - Initializer, Deinit, requiered

    init() {
        bindAction()
    }

    // MARK: - Bind

    private func bindAction() {
        action.buttonAction
            .bind { [weak self] action in
                guard let self else { return }

                let timeState = state.stopWatchRelay.value

                switch action {
                case .leftButton:
                    switch timeState {
                    case .initial:
                        // TODO: CoreData
                        self.state.stopWatchRelay.accept(.progress)
                    case .progress:
                        // TODO: 랩 활성화 -> CoreData

                        self.action.stopWatchAction.accept(.lap)
                    case .pause:
                        // TODO: CoreData
                        self.state.stopWatchRelay.accept(.initial)
                    }

                case .rightButton:

                    let timeState = state.stopWatchRelay.value

                    switch timeState {
                    case .initial:
                        // TODO: CoreData
                        self.state.stopWatchRelay.accept(.progress)
                    case .progress:
                        // TODO: CoreData
                        self.state.stopWatchRelay.accept(.pause)
                    case .pause:
                        // TODO: CoreData
                        self.state.stopWatchRelay.accept(.progress)
                    }
                }
            }.disposed(by: mainDisposeBag)

        action.stopWatchAction
            .bind { [weak self] action in
                guard let self else { return }
                switch action {
                case .start:
                    startTime = Date() - accumulatedTime
                    stopWatchDisposeBag = DisposeBag()

                    Observable<Int>.timer(
                        .seconds(.zero),
                        period: .milliseconds(10),
                        scheduler: MainScheduler.instance
                    ).subscribe(onNext: { [weak self] _ in
                        guard let self,
                              let startTime else { return }

                        let formattedTime = makeFormattedString(with: startTime)
                        state.formattedTimeRelay.accept(formattedTime)

                    }).disposed(by: stopWatchDisposeBag)

                case .pause:
                    guard let startTime else { return }
                    accumulatedTime = Date().timeIntervalSince(startTime)
                    stopWatchDisposeBag = DisposeBag()

                case .reset:
                    stopWatchDisposeBag = DisposeBag()
                    startTime = nil
                    accumulatedTime = .zero

                    let formattedTime = makeFormattedString(with: Date())
                    state.formattedTimeRelay.accept(formattedTime)

                case .lap:
                    guard let startTime else { return }

                    let totalElapsed = calculateTimeInterval(with: startTime)

                    // Lap 구간 시간 계산: 직전 누적값과의 차이
                    let previousLapTotal = state.currentLapTimeRelay.value.last ?? 0
                    let lapInterval = totalElapsed - previousLapTotal

                    // 누적 Lap 시간 저장
                    addLapTime(totalElapsed)

                    // 출력
                    print("Current Lap: \(makeFormattedString(since: totalElapsed))")
                    print("calculatedLap: \(makeFormattedString(since: lapInterval))")
                }
            }.disposed(by: mainDisposeBag)
    }

    private func addLapTime(_ lapTime: TimeInterval) {
        var previouLapTimes = state.currentLapTimeRelay.value
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
