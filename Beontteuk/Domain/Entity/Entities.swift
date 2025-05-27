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
    let id: UUID?
    let startTime: Date?
    let isRunning: Bool
    let elapsedBeforePause: Double
    let createdAt: Date?
    let laps: [LapRecordEntity]
}

struct LapRecordEntity: Equatable, Identifiable {
    let id: UUID?
    let lapIndex: Int16
    let lapTime: Double
    let absoluteTime: Double
    let recordedAt: Date?
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
        return lhs.id == rhs.id && lhs.isEditing == rhs.isEditing
    }
}

typealias WorldClockSection = AnimatableSectionModel<String, WorldClockEntity>
