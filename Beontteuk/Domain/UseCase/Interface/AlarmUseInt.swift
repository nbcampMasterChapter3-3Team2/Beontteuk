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
    ) -> CDAlarm

    func readAlarms() -> [CDAlarm]
    func updateAlarm(_ alarm: CDAlarm)
    func deleteAlarm(_ alarm: CDAlarm)
    func toggleAlarm(_ alarm: CDAlarm)
}
