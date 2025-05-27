//
//  AlarmUseInt.swift
//  Beontteuk
//
//  Created by yimkeul on 5/26/25.
//

import Foundation

protocol AlarmUseInt {
    func createAlarm(hour: Int,
        minute: Int,
        repeatDays: String?,
        label: String?,
        soundName: String?,
        snooze: Bool
    ) -> CDAlarmEntity

    func readAlarms() -> [CDAlarmEntity]
    func updateAlarm(_ alarm: CDAlarmEntity)
    func deleteAlarm(by id: UUID)
    func toggleAlarm(by id: UUID)
}
