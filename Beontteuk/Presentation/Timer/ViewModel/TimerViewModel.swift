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
                case .didTapStartButton:
                    ()
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

}
