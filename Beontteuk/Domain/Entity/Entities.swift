//
//  Entities.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxDataSources

struct CDAlarmEntity: Equatable, Identifiable {
    let id: UUID?
    let hour: Int16
    let minute: Int16
    let repeatDays: String?
    let label: String?
    var isEnabled: Bool
    let soundName: String?
    let isSnoozeEnabled: Bool
}

struct CDTimerEntity: Equatable, Identifiable {
    let id: UUID?
    let remainSecond: Double
    let totalSecond: Double
    let label: String?
    let soundName: String?
    let createdAt: Date?
    let isRunning: Bool
    let endTime: Date?
    let isRecent: Bool

    func toActiveTimer() -> ActiveTimer {
        ActiveTimer(
            id: id,
            totalTime: totalSecond,
            isRunning: isRunning,
            endTime: endTime,
            remainTimeSnapshot: remainSecond
        )
    }

    func toRecentTimer() -> RecentTimer {
        RecentTimer(id: id, totalTime: totalSecond)
    }
}

struct StopWatchEntity: Equatable, Identifiable {
    let id: UUID
    let startTime: Date?
    let isRunning: Bool
    let elapsedBeforePause: Double
    let createdAt: Date
    let laps: [LapRecordEntity]
}

struct LapRecordEntity: Equatable, Identifiable, Hashable {
    let id: UUID
    let lapIndex: Int16
    let lapTime: Double
    let absoluteTime: Double
    let recordedAt: Date

    var formattedAbsoluteTime: String {
        let minute = Int(absoluteTime) / 60
        let second = Int(absoluteTime) % 60
        let sentiSecond = Int((absoluteTime - floor(absoluteTime)) * 100)

        return String(
            format: "%02d:%02d.%02d",
            minute, second, sentiSecond
        )
    }

    var formattedLapTime: String {
        let minute = Int(lapTime) / 60
        let second = Int(lapTime) % 60
        let sentiSecond = Int((lapTime - floor(lapTime)) * 100)

        return String(
            format: "%02d:%02d.%02d",
            minute, second, sentiSecond
        )
    }
}

struct WorldClockEntity: Equatable, Identifiable {
    let id: UUID?
    let cityName: String?
    let cityNameKR: String?
    let timeZoneIdentifier: String?
    let createdAt: Date?
    let orderIndex: Int16
    let hourMinuteString: String
    let amPmString: String?
    let hourDifferenceText: String
    let dayLabelText: String
    var isEditing: Bool
}

extension WorldClockEntity: IdentifiableType {
    var identity: String { return id?.uuidString ?? UUID().uuidString }

    static func == (lhs: WorldClockEntity, rhs: WorldClockEntity) -> Bool {
        return lhs.id == rhs.id && lhs.isEditing == rhs.isEditing && lhs.hourMinuteString == rhs.hourMinuteString && lhs.amPmString == rhs.amPmString
    }
}

typealias WorldClockSection = AnimatableSectionModel<String, WorldClockEntity>
