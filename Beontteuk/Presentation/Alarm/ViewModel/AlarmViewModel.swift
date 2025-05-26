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

    enum Action {
        /// usecase
        case readAlarm
        case deleteAlarm(at: Int)
        /// fileprivate
        case toggle(index: Int, isOn: Bool)
        case setEditingMode(isEditing: Bool)
    }

    struct State {
        let alarmsRelay = BehaviorRelay<[CDAlarm]>(value: [])
        let nextAlarmRelay = BehaviorRelay<Bool>(value: false)
        let isEditingRelay = BehaviorRelay<Bool>(value: false)
    }

    private let useCase: AlarmUseInt
    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    let state = State()
    let disposeBag = DisposeBag()


    init(useCase: AlarmUseInt) {
        self.useCase = useCase
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
            var list = owner.state.alarmsRelay.value
            switch action {
                ///usecase
            case .readAlarm:
                list = self.useCase.readAlarms()

            case .deleteAlarm(let index):
                guard index < list.count else { return }
                let target = list.remove(at: index)
                self.useCase.deleteAlarm(target)

                /// fileprivate
            case .toggle(_, _):
                break
            case .setEditingMode(let isEditing):
                owner.state.isEditingRelay.accept(isEditing)
            }
            owner.state.alarmsRelay.accept(list)
            let hasNext = owner.isNextAlarm(from: list)
            owner.state.nextAlarmRelay.accept(hasNext)
        }.disposed(by: disposeBag)
    }

    private func isNextAlarm(from alarms: [CDAlarm]) -> Bool {
        let enabled = alarms.filter { $0.isEnabled }
        return !enabled.isEmpty
    }
}


// 다음 알람 정보 구조체
struct NextAlarmInfo {
    let alarm: CDAlarm
    let hours: Int
    let minutes: Int
}
