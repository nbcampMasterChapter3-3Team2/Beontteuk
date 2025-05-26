//
//  TimerUseImp.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/25/25.
//

import Foundation

final class TimerUseImp: TimerUseInt {
    private let repository: CDTimerRepositoryInterface

    init(repository: CDTimerRepositoryInterface) {
        self.repository = repository
    }

    func getActiveTimers() -> [CDTimer] {
        repository.fetchActiveTimers()
    }
    
    func getRecentTimers() -> [CDTimer] {
        repository.fetchRecentItems()
    }

    func addTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimer {
        let newTimer = repository.createTimer(
            hour: h,
            minute: m,
            second: s,
            label: nil,
            soundName: nil
        )
        repository.saveTimer(newTimer)
        return newTimer
    }

    func addTimer(fromRecentTimerID id: UUID) -> CDTimer? {
        guard let recentTimer = repository.fetchTimer(by: id) else { return nil }
        let newTimer = repository.duplicateRecentItemAndStart(recentTimer)
        repository.saveTimer(newTimer)
        return newTimer
    }

    func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimer? {
        guard !repository.hasRecentItem(hour: h, minute: m, second: s) else { return nil }
        let newTimer = repository.createRecentItem(hour: h, minute: m, second: s)
        repository.saveTimer(newTimer)
        return newTimer
    }

    func deleteTimer(by id: UUID) {
        guard let timer = repository.fetchTimer(by: id) else { return }
        repository.deleteTimer(timer)
    }
}
