//
//  AlarmBottomSheetViewModel.swift
//  Beontteuk
//
//  Created by yimkeul on 5/23/25.
//

import Foundation
import RxSwift
import RxRelay

final class AlarmBottomSheetViewModel {
    enum Action {
        case dateChanged(Date)
        case toggleSnooze(Bool)
        case updateSelection(AlarmSheetTableOption, String?)
        case save(hour: Int, minute: Int, repeatDays: String?, label: String?, soundName: String?)
        case cancel
    }

    struct State {
        let pickedDate = BehaviorRelay<Date>(value: Date())
        let snoozeEnabled = BehaviorRelay<Bool>(value: true)
        let selections = BehaviorRelay<[AlarmSheetTableOption: String]>(value: [:])
        let didSave = PublishRelay<Void>()
    }

    private let useCase: AlarmUseInt
    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    let state: State = State()
    let disposeBag = DisposeBag()

    init(useCase: AlarmUseInt) {
        self.useCase = useCase
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, item in
            switch item {
            case .dateChanged(let date):
                owner.state.pickedDate.accept(date)
            case .toggleSnooze(let isOn):
                owner.state.snoozeEnabled.accept(isOn)
            case .updateSelection(let option, let text):
                var dict = self.state.selections.value
                dict[option] = text ?? ""
                owner.state.selections.accept(dict)
            case .save(hour: let hour, minute: let minute, repeatDays: let repeatDays, label: let label, soundName: let soundName):
                let alarm = self.useCase.createAlarm(hour: hour, minute: minute, repeatDays: repeatDays, label: label, soundName: soundName)
                self.useCase.updateAlarm(alarm)
                self.state.didSave.accept(())

            case .cancel: break
            }
        }
            .disposed(by: disposeBag)
    }
}
