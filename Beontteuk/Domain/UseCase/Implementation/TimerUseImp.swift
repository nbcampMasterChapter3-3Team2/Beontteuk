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
        // TODO: label, soundName 설정하는 기능 추가
        repository.createTimer(hour: h, minute: m, second: s, label: nil, soundName: nil)
    }

    func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimer? {
        guard !repository.hasRecentItem(hour: h, minute: m, second: s) else { return nil }
        return repository.createRecentItem(hour: h, minute: m, second: s)
    }
}
