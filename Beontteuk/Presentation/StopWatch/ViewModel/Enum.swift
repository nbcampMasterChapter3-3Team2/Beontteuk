//
//  ActionState.swift
//  Beontteuk
//
//  Created by kingj on 5/27/25.
//

enum ButtonAction {
    case leftButton
    case rightButton
}

enum StopWatchAction {
    case start
    case pause
    case reset
    case lap
}

enum StopWatchState {
    case initial
    case progress
    case pause
}

enum StopWatchSection: Hashable {
    case laps
}

enum StopWatchItem: Hashable {
    case lap(LapRecordEntity)
}
