//
//  BottomSheetTableOption.swift
//  Beontteuk
//
//  Created by yimkeul on 5/23/25.
//

import Foundation

enum BottomSheetTableOption: CaseIterable {
    case label
    case snooze
//    case `repeat`
//    case sound

    var title: String {
        switch self {
        case .label: return "레이블"
        case .snooze: return "다시 알림"
//        case .repeat: return "반복"
//        case .sound: return "사운드"
        }
    }

    var detailText: String {
        switch self {
        case .label: return "알람"
        case .snooze: return ""
//        case .repeat: return "안 함"
//        case .sound: return "노래제목"
        }
    }
}
