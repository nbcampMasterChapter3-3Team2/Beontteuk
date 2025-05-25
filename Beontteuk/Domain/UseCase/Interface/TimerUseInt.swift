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
}
