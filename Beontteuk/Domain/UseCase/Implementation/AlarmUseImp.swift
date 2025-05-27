//
//  AlarmUseImp.swift
//  Beontteuk
//
//  Created by yimkeul on 5/26/25.
//

import Foundation
import UserNotifications

final class AlarmUseImp: AlarmUseInt {

    private let repository: AlarmRepositoryInterface
    private let notificationService: NotificationService

    init(repository: AlarmRepositoryInterface) {
        self.repository = repository
        self.notificationService = NotificationService()
    }

    func createAlarm(hour: Int, minute: Int, repeatDays: String?, label: String?, soundName: String?, snooze: Bool) -> CDAlarmEntity {
        return repository.createAlarm(hour: hour, minute: minute, repeatDays: repeatDays, label: label, soundName: soundName, snooze: snooze).toEntity()
    }

    func readAlarms() -> [CDAlarmEntity] {
        repository.fetchAllAlarm().map { $0.toEntity() }
    }

    func updateAlarm(_ alarm: CDAlarmEntity) {
        guard let uuid = alarm.id,
              let alarm = repository.fetchAlarm(by: uuid),
              let label = alarm.label
        else { return }


        repository.saveAlarm(alarm)
        let date = Calendar.current.date(from: alarm.dateComponents)
        if alarm.isEnabled {
            notificationService.scheduleAlarm(
                at: date ?? Date(),
                snooze: alarm.isSnoozeEnabled,
                title: label.isEmpty ? "알람" : label,
                notificationId: uuid.uuidString
            )
        } else {
            notificationService.cancelAlarm(notificationId: uuid.uuidString)
        }
    }

    func deleteAlarm(by id: UUID) {
        guard let alarm = repository.fetchAlarm(by: id) else { return }
        notificationService.cancelAlarm(notificationId: id.uuidString)
        repository.deleteAlarm(alarm)
    }

    func toggleAlarm(by id: UUID) {
        guard let alarm = repository.fetchAlarm(by: id),
              let label = alarm.label
        else { return }
        repository.toggleAlarm(alarm)
        let date = Calendar.current.date(from: alarm.dateComponents)
        if alarm.isEnabled {
            notificationService.scheduleAlarm(
                at: date ?? Date(),
                snooze: alarm.isSnoozeEnabled,
                title: label.isEmpty ? "알람" : label,
                notificationId: id.uuidString
            )
        } else {
            notificationService.cancelAlarm(notificationId: id.uuidString)
        }
    }

}
