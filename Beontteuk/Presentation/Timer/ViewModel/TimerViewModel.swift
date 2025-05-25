//
//  TimerViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation
import RxSwift
import RxRelay

final class TimerViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case didTapAddButton
        case didTapStartButton(h: Int, m: Int, s: Int)
        case didTapCancelButton
    }

    struct State {
        let activeTimers = BehaviorRelay<[TimerItem]>(value: [])
        let recentTimers = BehaviorRelay<[TimerItem]>(value: [])
        let showTimePicker = PublishRelay<Bool>()
    }

    // MARK: - Properties

    private let useCase: TimerUseInt
    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    var state = State()
    let disposeBag = DisposeBag()

    // MARK: - Init, Deinit, required

    init(useCase: TimerUseInt) {
        self.useCase = useCase
        bind()
    }

    // MARK: - Bind

    private func bind() {
        actionSubject
            .bind(with: self) { owner, action in
                switch action {
                case .viewDidLoad:
                    owner.loadTimers()
                case .didTapAddButton:
                    owner.state.showTimePicker.accept(true)
                case .didTapStartButton(let h, let m, let s):
                    owner.createTimerThenStart(h, m, s)
                    owner.addRecentTimer(h, m, s)
                case .didTapCancelButton:
                    owner.state.showTimePicker.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func loadTimers() {
        loadActiveTimers()
        loadRecentTimers()
    }

    private func loadActiveTimers() {
        let activeTimers = useCase.getActiveTimers().map { cdTimer in
            TimerItem.active(ActiveTimer(
                id: cdTimer.id ?? UUID(),
                remainTime: cdTimer.remainSecond,
                totalTime: cdTimer.totalSecond,
                isRunning: cdTimer.isRunning,
                endTime: cdTimer.endTime
            ))
        }
        state.activeTimers.accept(activeTimers)
    }

    private func loadRecentTimers() {
        let recentTimers = useCase.getRecentTimers().map { cdTimer in
            TimerItem.recent(RecentTimer(
                id: cdTimer.id ?? UUID(),
                totalTime: cdTimer.totalSecond
            ))
        }
        state.recentTimers.accept(recentTimers)
    }

    private func createTimerThenStart(_ h: Int, _ m: Int, _ s: Int) {
        let cdTimer = useCase.addTimer(h, m, s)
        let timerItem = TimerItem.active(ActiveTimer(
            id: cdTimer.id ?? UUID(),
            remainTime: cdTimer.totalSecond,
            totalTime: cdTimer.totalSecond,
            isRunning: cdTimer.isRunning,
            endTime: cdTimer.endTime
        ))
        state.activeTimers.accept(state.activeTimers.value + [timerItem])
    }

    private func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) {
        guard let cdTimer = useCase.addRecentTimer(h, m, s) else { return }
        let recentTimer = RecentTimer(id: cdTimer.id ?? UUID(), totalTime: cdTimer.totalSecond)
        let timerItem = TimerItem.recent(recentTimer)
        state.recentTimers.accept(state.recentTimers.value + [timerItem])
    }
}
