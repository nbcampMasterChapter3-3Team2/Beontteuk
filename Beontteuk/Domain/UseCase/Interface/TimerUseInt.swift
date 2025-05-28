//
//  TimerUseInt.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/25/25.
//

import Foundation

protocol TimerUseInt {
    func getActiveTimers() -> [CDTimerEntity]
    func getRecentTimers() -> [CDTimerEntity]
    func addTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimerEntity
    func addTimer(fromRecentTimerID id: UUID) -> CDTimerEntity?
    func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimerEntity?
    func deleteTimer(by id: UUID)
    func pauseTimer(for timerID: UUID?, remainTime: Double)
    func resumeTimer(for timerID: UUID?)
}
