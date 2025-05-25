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
        case viewDidLoad
        case toggle(index: Int, isOn: Bool)
        case setEditingMode(isEditing: Bool)
    }

    struct State {
        let alarmsRelay = BehaviorRelay<[AlarmMock]>(value: [])
        let nextAlarmRelay = BehaviorRelay<Bool>(value: false)
        let isEditingRelay = BehaviorRelay<Bool>(value: false)
    }

    private let actionSubject = PublishSubject<Action>()
    var action: AnyObserver<Action> { actionSubject.asObserver() }
    let state = State()
    let disposeBag = DisposeBag()


    init() {
        bind()
    }

    private func bind() {
        actionSubject
            .subscribe(with: self) { owner, action in
            var list = owner.state.alarmsRelay.value
            switch action {
            case .viewDidLoad:
                list = AlarmMock.mockList
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

    private func isNextAlarm(from alarms: [AlarmMock]) -> Bool {
        let enabled = alarms.filter { $0.isEnabled }
        return !enabled.isEmpty
    }

}


// 다음 알람 정보 구조체
struct NextAlarmInfo {
    let alarm: AlarmMock
    let hours: Int
    let minutes: Int
}

// 1) 알람 모델 정의
struct AlarmMock {
    let id: UUID?
    let hour: Int16
    let minute: Int16
    let repeatDays: String?
    let label: String?
    var isEnabled: Bool
    let soundName: String?
    let isSnoozeEnabled: Bool
}

// 2) 목 데이터 선언 (여기에 원하는 만큼 추가)
extension AlarmMock {
    static let mockList: [AlarmMock] = [
        AlarmMock(
            id: UUID(),
            hour: 7, minute: 0,
            repeatDays: "주중",
            label: "출근 알람",
            isEnabled: true,
            soundName: "Default",
            isSnoozeEnabled: true
        ),
        AlarmMock(
            id: UUID(),
            hour: 9, minute: 30,
            repeatDays: "주말",
            label: "주말 느긋 알람",
            isEnabled: false,
            soundName: "Bell",
            isSnoozeEnabled: false
        ),
        AlarmMock(
            id: UUID(),
            hour: 6, minute: 0,
            repeatDays: "월,수,금",
            label: "운동 알람",
            isEnabled: false,
            soundName: "Chime",
            isSnoozeEnabled: true
        ),
        AlarmMock(
            id: UUID(),
            hour: 13, minute: 15,
            repeatDays: "월",
            label: "점심 회의",
            isEnabled: false,
            soundName: "Ripple",
            isSnoozeEnabled: false
        ),
        AlarmMock(
            id: UUID(),
            hour: 18, minute: 45,
            repeatDays: nil,
            label: "친구 생일 축하",
            isEnabled: false,
            soundName: "Party",
            isSnoozeEnabled: false
        ),
        AlarmMock(
            id: UUID(),
            hour: 15, minute: 0,
            repeatDays: nil,
            label: nil,
            isEnabled: false,
            soundName: nil,
            isSnoozeEnabled: false
        ),
        AlarmMock(
            id: UUID(),
            hour: 20, minute: 0,
            repeatDays: "매일",
            label: "약 복용",
            isEnabled: false,
            soundName: "Beep",
            isSnoozeEnabled: true
        ),
        AlarmMock(
            id: UUID(),
            hour: 0, minute: 0,
            repeatDays: "매일",
            label: "보안 점검",
            isEnabled: false,
            soundName: "Alarm",
            isSnoozeEnabled: false
        ),
        AlarmMock(
            id: UUID(),
            hour: 18, minute: 30,
            repeatDays: "월,화,수",
            label: "조명 켜기",
            isEnabled: false,
            soundName: "SoftTone",
            isSnoozeEnabled: true
        ),
        AlarmMock(
            id: UUID(),
            hour: 23, minute: 45,
            repeatDays: nil,
            label: "야간 알람",
            isEnabled: false,
            soundName: "NightOwl",
            isSnoozeEnabled: false
        )
    ]
}

