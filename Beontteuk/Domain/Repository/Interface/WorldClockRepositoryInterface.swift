//
//  WorldClockRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol WorldClockRepositoryInterface {
    func fetchAll() -> [WorldClock]
    func add(clock: WorldClock)
    func remove(clock: WorldClock)
}
