//
//  TimerUseInt.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/25/25.
//

import Foundation

protocol TimerUseInt {
    func getActiveTimers() -> [CDTimer]
    func getRecentTimers() -> [CDTimer]
    func addTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimer
    func addTimer(fromRecentTimerID id: UUID) -> CDTimer?
    func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimer?
    func deleteTimer(by id: UUID)
}
