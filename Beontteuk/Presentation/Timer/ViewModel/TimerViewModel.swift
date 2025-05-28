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
        case didTapEditButton
        case didTapAddButton
        case didTapStartButton
        case didTapCancelButton
        case didChangeTimePicker((Int, Int))
        case didDeletedTimerItem(IndexPath)
        case didTapRecentTimerButton(Int)
        case didTapTimerControlButton(ActiveTimer)
    }

    struct State {
        let isEditMode = BehaviorRelay<Bool>(value: false)
        let activeTimers = BehaviorRelay<[TimerItem]>(value: [])
        let recentTimers = BehaviorRelay<[TimerItem]>(value: [])
        let showTimePicker = PublishRelay<Bool>()
        let selectedTime = BehaviorRelay<[Int:Int]>(value: [0: 0, 1: 0, 2: 0])
        let shouldResetTimePicker = PublishRelay<Void>()
        let canStartTimer = PublishRelay<Bool>()
        let tick = PublishRelay<Void>()
    }

    // MARK: - Properties

    private let useCase: TimerUseInt
    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    var state = State()
    let disposeBag = DisposeBag()
    private var timerBag: [UUID: Disposable] = [:]

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
                    owner.startTickingActiveTimers()
                case .didTapEditButton:
                    let isEditMode = owner.state.isEditMode.value
                    owner.state.isEditMode.accept(!isEditMode)
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
                case .didDeletedTimerItem(let indexPath):
                    owner.deleteTimer(for: indexPath)
                case .didTapRecentTimerButton(let row):
                    owner.addTimerFromRecent(at: row)
                case .didTapTimerControlButton(let timer):
                    owner.toggleTimerState(timer)
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
        state.activeTimers.accept([])
        let activeTimers = useCase.getActiveTimers().map { cdTimer in
            TimerItem.active(cdTimer.toActiveTimer())
        }

        var aliveTimers = [TimerItem]()
        activeTimers.forEach {
            if $0.active!.isExpired {
                guard let id = $0.id else { return }
                useCase.deleteTimer(by: id)
            } else {
                aliveTimers.append($0)
            }
        }

        state.activeTimers.accept(aliveTimers)
    }

    private func startTickingActiveTimers() {
        let activeTimers = state.activeTimers.value
        activeTimers.forEach { timerItem in
            startTicking(timer: timerItem.active!)
        }
    }

    private func loadRecentTimers() {
        let recentTimers = useCase.getRecentTimers().map { cdTimer in
            TimerItem.recent(cdTimer.toRecentTimer())
        }
        state.recentTimers.accept(recentTimers)
    }

    private func startTicking(timer: ActiveTimer) {
        guard let id = timer.id else { return }

        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .filter { _ in timer.isRunning }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                if timer.isExpired {
                    guard let row = owner.state.activeTimers.value
                        .map({ $0.active! }).firstIndex(of: timer) else { return }
                    owner.deleteTimer(for: IndexPath(row: row, section: 0))
                } else {
                    owner.state.tick.accept(())
                    LiveActivityManager.shared.update(for: timer.id, remainTime: timer.remainTime)
                }
            }

        timerBag[id] = timer
    }

    private func createTimerThenStart() {
        let time = state.selectedTime.value
        guard let h = time[0], let m = time[1], let s = time[2] else { return }
        let cdTimer = useCase.addTimer(h, m, s)
        let timerItem = TimerItem.active(cdTimer.toActiveTimer())
        startTicking(timer: timerItem.active!)
        state.activeTimers.accept(state.activeTimers.value + [timerItem])
    }

    private func addRecentTimer() {
        let time = state.selectedTime.value
        guard let h = time[0], let m = time[1], let s = time[2] else { return }
        guard let cdTimer = useCase.addRecentTimer(h, m, s) else { return }
        let recentTimer = RecentTimer(id: cdTimer.id, totalTime: cdTimer.totalSecond)
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

    private func deleteTimer(for indexPath: IndexPath) {
        let section = TimerSection.allCases[indexPath.section]
        switch section {
        case .active:
            var activeTimers = state.activeTimers.value
            guard let active = activeTimers[indexPath.row].active,
                  let id = active.id else { return }
            useCase.deleteTimer(by: id)
            timerBag[id]?.dispose()
            activeTimers.remove(at: indexPath.row)
            state.activeTimers.accept(activeTimers)
        case .recent:
            var recentTimers = state.recentTimers.value
            guard let recent = recentTimers[indexPath.row].recent,
                  let id = recent.id else { return }
            useCase.deleteTimer(by: id)
            recentTimers.remove(at: indexPath.row)
            state.recentTimers.accept(recentTimers)
        }
    }

    private func addTimerFromRecent(at row: Int) {
        let recentTimer = state.recentTimers.value[row]
        guard let id = recentTimer.recent?.id,
              let cdTimer = useCase.addTimer(fromRecentTimerID: id) else { return }
        let newActiveTimer = cdTimer.toActiveTimer()
        let activeTimers = state.activeTimers.value
        startTicking(timer: newActiveTimer)
        state.activeTimers.accept(activeTimers + [TimerItem.active(newActiveTimer)])
    }

    private func toggleTimerState(_ timer: ActiveTimer) {
        guard let id = timer.id else { return }

        if timer.isRunning {
            timerBag[id]?.dispose()
            useCase.pauseTimer(
                for: timer.id,
                remainTime: timer.remainTime
            )
        } else {
            useCase.resumeTimer(for: id)
        }

        loadActiveTimers()
        startTickingActiveTimers()
    }
}
