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
        case didTapStartButton
        case didTapCancelButton
        case didChangeTimePicker((Int, Int))
    }

    struct State {
        let activeTimers = BehaviorRelay<[TimerItem]>(value: [])
        let recentTimers = BehaviorRelay<[TimerItem]>(value: [])
        let showTimePicker = PublishRelay<Bool>()
        let selectedTime = BehaviorRelay<[Int:Int]>(value: [0: 0, 1: 0, 2: 0])
        let shouldResetTimePicker = PublishRelay<Void>()
        let canStartTimer = PublishRelay<Bool>()
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
                    owner.initializeTimeSelection()
                case .didTapStartButton:
                    owner.createTimerThenStart()
                    owner.addRecentTimer()
                    owner.state.showTimePicker.accept(false)
                case .didTapCancelButton:
                    owner.state.showTimePicker.accept(false)
                case .didChangeTimePicker((let component, let value)):
                    owner.changeSelectedTime(component, value)
                    owner.setCanStartTimer()
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func loadTimers() {
        loadActiveTimers()
        loadRecentTimers()
    }

    private func initializeTimeSelection() {
        state.shouldResetTimePicker.accept(())
        state.selectedTime.accept([0: 0, 1: 0, 2: 0])
        state.canStartTimer.accept(false)
        state.showTimePicker.accept(true)
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

    private func createTimerThenStart() {
        let time = state.selectedTime.value
        guard let h = time[0], let m = time[1], let s = time[2] else { return }
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

    private func addRecentTimer() {
        let time = state.selectedTime.value
        guard let h = time[0], let m = time[1], let s = time[2] else { return }
        guard let cdTimer = useCase.addRecentTimer(h, m, s) else { return }
        let recentTimer = RecentTimer(id: cdTimer.id ?? UUID(), totalTime: cdTimer.totalSecond)
        let timerItem = TimerItem.recent(recentTimer)
        state.recentTimers.accept(state.recentTimers.value + [timerItem])
    }

    private func changeSelectedTime(_ component: Int, _ value: Int) {
        var selectedTime = state.selectedTime.value
        selectedTime[component] = value
        state.selectedTime.accept(selectedTime)
    }

    private func setCanStartTimer() {
        let isEnabled = state.selectedTime.value.values.contains { $0 != 0 }
        state.canStartTimer.accept(isEnabled)
    }
}
