//
//  AlarmRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol AlarmRepositoryInterface {
    func fetchAll() -> [Alarm]
    func save(_ alarm: Alarm)
    func delete(_ alarm: Alarm)
    func toggle(_ alarm: Alarm)
}
