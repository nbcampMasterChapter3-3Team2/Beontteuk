//
//  TimerItem.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/22/25.
//

import Foundation

enum TimerItem: Hashable {
    case current(CurrentTimer)
    case recent(RecentTimer)

    var current: CurrentTimer? {
        if case .current(let currentTimer) = self {
            return currentTimer
        } else {
            return nil
        }
    }

    var recent: RecentTimer? {
        if case .recent(let recentTimer) = self {
            return recentTimer
        } else {
            return nil
        }
    }

    static let currentItems: [TimerItem] = [
        .current(CurrentTimer(time: "03:30", timeKR: "3분 30초", progress: 0.7)),
        .current(CurrentTimer(time: "07:30", timeKR: "7분 30초", progress: 1)),
        .current(CurrentTimer(time: "13:20", timeKR: "13분 20초", progress: 0.2))
    ]

    static let recentItems: [TimerItem] = [
        .recent(RecentTimer(time: "5:00", timeKR: "5분")),
        .recent(RecentTimer(time: "2:09:30", timeKR: "2시간 9분 30초"))
    ]
}

struct CurrentTimer: Hashable {
    let time: String
    let timeKR: String
    let progress: CGFloat
}

struct RecentTimer: Hashable {
    let time: String
    let timeKR: String
}
