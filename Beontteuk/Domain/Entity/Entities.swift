//
//  Entities.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

struct CDAlarmEntity: Equatable, Identifiable {
    let id: UUID?
    let hour: Int16
    let minute: Int16
    let repeatDays: String?
    let label: String?
    let isEnabled: Bool
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
    let timeZoneIdentifier: String?
    let createdAt: Date?
    let orderIndex: Int16
}
