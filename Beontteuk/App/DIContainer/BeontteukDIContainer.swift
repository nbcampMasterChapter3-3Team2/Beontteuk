//
//  BeontteukDIContainer.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/27/25.
//

import Foundation

final class BeontteukDIContainer: BeontteukDIContainerInerface {
    func makeAlarmViewModel() -> AlarmViewModel {
        let alarmRepository = CoreDataAlarmRepository()
        let alarmUseCase = AlarmUseImp(repository: alarmRepository)
        let alarmViewModel = AlarmViewModel(useCase: alarmUseCase)
        
        return alarmViewModel
    }
    
    func makeTimerViewModel() -> TimerViewModel {
        let timerRepository = CoreDataCDTimerRepository()
        let notificationService = NotificationService()
        let timerUseCase = TimerUseImp(repository: timerRepository, notificationService: notificationService)
        let timerViewModel = TimerViewModel(useCase: timerUseCase)
        
        return timerViewModel
    }
    
    func makeStopWatchViewModel() -> StopWatchViewModel {
        return StopWatchViewModel()
    }
    
    func makeWorldClockViewModel() -> WorldClockViewModel {
        let worldClockRepository = CoreDataWorldClockRepository()
        let worldClockUseCase = WorldClockUseCase(repository: worldClockRepository)
        let worldClockViewModel = WorldClockViewModel(useCase: worldClockUseCase)
        
        return worldClockViewModel
    }
}
