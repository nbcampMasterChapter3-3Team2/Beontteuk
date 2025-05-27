//
//  AlarmViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation
import RxSwift
import RxRelay

final class AlarmViewModel: ViewModelProtocol {

    // MARK: - Action
    enum Action {
        /// usecase
        case readAlarm
        case deleteAlarm(at: Int)
        /// fileprivate
        case toggle(index: Int, isOn: Bool)
        case setEditingMode(isEditing: Bool)
    }

    // MARK: - State
    struct State {
        let alarmsRelay = BehaviorRelay<[CDAlarmEntity]>(value: [])
        let nextAlarmRelay = BehaviorRelay<Bool>(value: false)
        let isEditingRelay = BehaviorRelay<Bool>(value: false)
    }

    // MARK: - Properties
    private let useCase: AlarmUseInt
    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    let state = State()
    let disposeBag = DisposeBag()

    // MARK: - Initializer
    init(useCase: AlarmUseInt) {
        self.useCase = useCase
        bind()
    }

    // MARK: - Bind
    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
            var list = owner.state.alarmsRelay.value
            switch action {
                ///usecase
            case .readAlarm:
                list = self.useCase.readAlarms()

            case .deleteAlarm(let index):
                guard index < list.count
                    else { return }
                let target = list.remove(at: index)
                guard let id = target.id else { return }

                self.useCase.deleteAlarm(by: id)

                /// fileprivate
            case .toggle(let index, let isOn):
                guard index < list.count else { return }
                var alarm = list[index]
                alarm.isEnabled = isOn
                list[index] = alarm
                owner.useCase.updateAlarm(alarm)

            case .setEditingMode(let isEditing):
                owner.state.isEditingRelay.accept(isEditing)
            }

            owner.state.alarmsRelay.accept(list)

            let hasNext = owner.isNextAlarm(from: list)
            owner.state.nextAlarmRelay.accept(hasNext)
        }.disposed(by: disposeBag)
    }

    // MARK: - Methods
    private func isNextAlarm(from alarms: [CDAlarmEntity]) -> Bool {
        let enabled = alarms.filter { $0.isEnabled }
        return !enabled.isEmpty
    }
}

