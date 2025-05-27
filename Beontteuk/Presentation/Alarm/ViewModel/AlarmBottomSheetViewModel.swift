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
        case labelChanged(String?)
        case toggleSnooze(Bool)


        case save(repeatDays: String?, soundName: String?)
        case update(alarm: CDAlarm, repeatDays: String?, soundName: String?)
        case delete(alarm: CDAlarm)
        case cancel
    }

    struct State {
        let pickedDate = BehaviorRelay<String>(value: "")
        let inputLabel = BehaviorRelay<String?>(value: nil)
        let snoozeEnabled = BehaviorRelay<Bool>(value: true)
        let didAction = PublishRelay<Void>()
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
                let formatter = DateFormatter()
                formatter.locale = Locale.autoupdatingCurrent
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "HH:mm"
                let localTime = formatter.string(from: date)
                /// 무조건 24시로 데이터 저장됨
                owner.state.pickedDate.accept(localTime)

            case .labelChanged(let textInput):
                owner.state.inputLabel.accept(textInput)

            case .toggleSnooze(let isOn):
                owner.state.snoozeEnabled.accept(isOn)

            case .save(let repeatDays, let soundName):
                owner.upsertAlarm(deleting: nil, repeatDays: repeatDays, soundName: soundName)

            case .update(let alarm, let repeatDays, let soundName):
                owner.upsertAlarm(deleting: alarm, repeatDays: repeatDays, soundName: soundName)

            case .delete(let alarm):
                owner.useCase.deleteAlarm(alarm)
                owner.state.didAction.accept(())

            case .cancel: break

            }
        }
            .disposed(by: disposeBag)
    }

    private func upsertAlarm(
        deleting oldAlarm: CDAlarm?,
        repeatDays: String?,
        soundName: String?
    ) {
        if let old = oldAlarm {
            useCase.deleteAlarm(old)
        }

        let time = state.pickedDate.value.split { $0 == ":" }
        let hour = Int(time[0]) ?? 0
        let minute = Int(time[1]) ?? 0
        let label = state.inputLabel.value
        let snooze = state.snoozeEnabled.value

        let newAlarm = useCase.createAlarm(
            hour: hour,
            minute: minute,
            repeatDays: repeatDays,
            label: label,
            soundName: soundName,
            snooze: snooze
        )
        useCase.updateAlarm(newAlarm)
        state.didAction.accept(())
    }
}
