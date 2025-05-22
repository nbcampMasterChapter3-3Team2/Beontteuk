//
//  AlarmViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import Foundation


// 1) 알람 모델 정의
struct Alarm {
    let id: UUID
    let hour: Int
    let minute: Int
    let repeatText: String // 예: "알람, 주중"
    let isOn: Bool
}

// 2) 목 데이터 선언 (여기에 원하는 만큼 추가)
extension Alarm {
    static let mockList: [Alarm] = [
        Alarm(id: .init(), hour: 7, minute: 10, repeatText: "알람, 주중", isOn: true),
        Alarm(id: .init(), hour: 8, minute: 30, repeatText: "운동 알람", isOn: false),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true),
        Alarm(id: .init(), hour: 7, minute: 10, repeatText: "알람, 주중", isOn: true),
        Alarm(id: .init(), hour: 8, minute: 30, repeatText: "운동 알람", isOn: false),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true)
    ]
}
