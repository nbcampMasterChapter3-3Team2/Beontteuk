//
//  AlarmSheetTableOption.swift
//  Beontteuk
//
//  Created by yimkeul on 5/23/25.
//

import Foundation

enum AlarmSheetTableOption: CaseIterable {
//    case `repeat`
    case label
//    case sound
    case snooze

    var title: String {
        switch self {
//        case .repeat: return "반복"
        case .label: return "레이블"
//        case .sound: return "사운드"
        case .snooze: return "다시 알림"
        }
    }

    var detailText: String {
        switch self {
//        case .repeat: return "안 함"
        case .label: return "알람"
//        case .sound: return "노래제목"
        case .snooze: return ""
        }
    }
}
