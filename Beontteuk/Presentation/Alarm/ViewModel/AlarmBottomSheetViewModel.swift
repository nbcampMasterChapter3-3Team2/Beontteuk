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
        case save
        case cancel
    }

    struct State {
        let pickedDate = BehaviorRelay<Date>(value: Date())
        let snoozeEnabled = BehaviorRelay<Bool>(value: true)
        let selections = BehaviorRelay<[AlarmSheetTableOption: String]>(value: [:])
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    let state: State = State()
    let disposeBag = DisposeBag()

    init() {
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
                case .save, .cancel:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
