//
//  AlarmUseImp.swift
//  Beontteuk
//
//  Created by yimkeul on 5/26/25.
//

import Foundation

final class AlarmUseImp: AlarmUseInt {

    private let repository: AlarmRepositoryInterface

    init(repository: AlarmRepositoryInterface) {
        self.repository = repository
    }

    func createAlarm(hour: Int, minute: Int, repeatDays: String?, label: String?, soundName: String?) -> CDAlarm {
        repository.createAlarm(hour: hour, minute: minute, repeatDays: repeatDays, label: label, soundName: soundName)
    }

    func readAlarms() -> [CDAlarm] {
        repository.fetchAllAlarm()
    }

    func updateAlarm(_ alarm: CDAlarm) {
        repository.saveAlarm(alarm)
    }

    func deleteAlarm(_ alarm: CDAlarm) {
        repository.deleteAlarm(alarm)
    }

    func toggleAlarm(_ alarm: CDAlarm) {
        repository.toggleAlarm(alarm)
    }

}
