//
//  TimerItem.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/22/25.
//

import Foundation

enum TimerSection: Hashable, CaseIterable {
    case active
    case recent
}

enum TimerItem: Hashable {
    case active(ActiveTimer)
    case recent(RecentTimer)

    // 내부 속성 값이 변해도 같은 타이머임을 명시하기 위함
    var id: UUID? {
        switch self {
        case .active(let a): return a.id
        case .recent(let r): return r.id
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TimerItem, rhs: TimerItem) -> Bool {
        return lhs.id == rhs.id
    }

    var active: ActiveTimer? {
        if case .active(let activeTimer) = self {
            return activeTimer
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
}

struct ActiveTimer: Hashable {
    let id: UUID?
    let totalTime: Double
    let isRunning: Bool
    let endTime: Date?
    let remainTimeSnapshot: Double?

    var remainTime: Double {
        if isRunning {
            guard let endTime else { return 0 }
            return max(0, endTime.timeIntervalSinceNow)
        } else {
            return remainTimeSnapshot ?? 0
        }
    }

    var isExpired: Bool {
        guard let endTime else { return false }
        return endTime.timeIntervalSinceNow <= 0
    }

    var timeString: String {
        guard let remainTimeSnapshot else { return "" }
        let seconds = Int(isRunning ? remainTime : remainTimeSnapshot)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        return h > 0
            ? String(format: "%d:%02d:%02d", h, m, s)
            : String(format: "%02d:%02d", m, s)
    }

    var localizedTimeString: String {
        guard let remainTimeSnapshot else { return "" }
        let seconds = Int(isRunning ? remainTime : remainTimeSnapshot)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        var components: [String] = []
        if h > 0 { components.append("\(h)시간") }
        if m > 0 { components.append("\(m)분") }
        if s > 0 || components.isEmpty { components.append("\(s)초") }

        return components.joined(separator: " ")
    }

    var progress: CGFloat {
        guard let remainTimeSnapshot else { return 0 }
        return (isRunning ? remainTime : remainTimeSnapshot) / totalTime
    }
}

struct RecentTimer: Hashable {
    let id: UUID?
    let totalTime: Double

    var timeString: String {
        let seconds = Int(totalTime)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        return h > 0
            ? String(format: "%d:%02d:%02d", h, m, s)
            : m > 0 ? String(format: "%d:%02d", m, s) : "\(s)"
    }

    var localizedTimeString: String {
        let seconds = Int(totalTime)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60

        var components: [String] = []
        if h > 0 { components.append("\(h)시간") }
        if m > 0 { components.append("\(m)분") }
        if s > 0 || components.isEmpty { components.append("\(s)초") }

        return components.joined(separator: " ")
    }
}
