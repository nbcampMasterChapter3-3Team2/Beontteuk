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
        self.notificationService = NotificationService(repository: repository)
    }

    func createAlarm(hour: Int, minute: Int, repeatDays: String?, label: String?, soundName: String?, snooze: Bool) -> CDAlarm {
        return repository.createAlarm(hour: hour, minute: minute, repeatDays: repeatDays, label: label, soundName: soundName, snooze: snooze)
    }

    func readAlarms() -> [CDAlarm] {
        repository.fetchAllAlarm()
    }

    func updateAlarm(_ alarm: CDAlarm) {
        repository.saveAlarm(alarm)
        let date = Calendar.current.date(from: alarm.dateComponents)!
        if alarm.isEnabled {
            notificationService.scheduleAlarm(
                at: date,
                snooze: alarm.isSnoozeEnabled,
                title: alarm.label ?? "알람",
                notificationId: alarm.id!.uuidString
            )
        } else {
            notificationService.cancelAlarm(notificationId: alarm.id!.uuidString)
        }
    }

    func deleteAlarm(_ alarm: CDAlarm) {
        notificationService.cancelAlarm(notificationId: alarm.id!.uuidString)
        repository.deleteAlarm(alarm)
    }

    func toggleAlarm(_ alarm: CDAlarm) {
        repository.toggleAlarm(alarm)
//        스위치 상태 반영: on이면 스케줄, off이면 취소
        let date = Calendar.current.date(from: alarm.dateComponents)!
        if alarm.isEnabled {
            notificationService.scheduleAlarm(
                at: date,
                snooze: alarm.isSnoozeEnabled,
                title: alarm.label ?? "알람",
                notificationId: alarm.id!.uuidString
            )
        } else {
            notificationService.cancelAlarm(notificationId: alarm.id!.uuidString)
        }
    }

}
