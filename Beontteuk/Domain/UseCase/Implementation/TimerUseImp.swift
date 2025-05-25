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
}
