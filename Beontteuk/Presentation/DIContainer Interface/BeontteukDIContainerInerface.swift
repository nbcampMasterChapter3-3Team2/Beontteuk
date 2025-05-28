//
//  BeontteukDIContainerInerface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/27/25.
//

import Foundation

protocol BeontteukDIContainerInerface {
    func makeAlarmViewModel() -> AlarmViewModel
    func makeTimerViewModel() -> TimerViewModel
    func makeStopWatchViewModel() -> StopWatchViewModel
    func makeWorldClockViewModel() -> WorldClockViewModel
    func makeWorldCityViewModel() -> SelectCityViewModel
}
