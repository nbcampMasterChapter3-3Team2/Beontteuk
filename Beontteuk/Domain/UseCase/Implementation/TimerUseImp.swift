//
//  TimerUseImp.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/25/25.
//

import Foundation

final class TimerUseImp: TimerUseInt {
    private let repository: CDTimerRepositoryInterface
    private let notificationService: NotificationService

    init(repository: CDTimerRepositoryInterface, notificationService: NotificationService) {
        self.repository = repository
        self.notificationService = notificationService
    }

    func getActiveTimers() -> [CDTimerEntity] {
        repository.fetchActiveTimers().map { $0.toEntity() }
    }
    
    func getRecentTimers() -> [CDTimerEntity] {
        repository.fetchRecentItems().map { $0.toEntity() }
    }

    func addTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimerEntity {
        let newTimer = repository.createTimer(
            hour: h,
            minute: m,
            second: s,
            label: nil,
            soundName: nil
        )
        repository.saveTimer(newTimer)
        notificationService.scheduleTimer(after: newTimer.totalSecond, timerID: newTimer.id)
        LiveActivityManager.shared.start(for: newTimer.id, endAfter: newTimer.remainSecond)
        return newTimer.toEntity()
    }

    func addTimer(fromRecentTimerID id: UUID) -> CDTimerEntity? {
        guard let recentTimer = repository.fetchTimer(by: id) else { return nil }
        let newTimer = repository.duplicateRecentItemAndStart(recentTimer)
        repository.saveTimer(newTimer)
        notificationService.scheduleTimer(after: newTimer.totalSecond, timerID: newTimer.id)
        LiveActivityManager.shared.start(for: newTimer.id, endAfter: newTimer.remainSecond)
        return newTimer.toEntity()
    }

    func addRecentTimer(_ h: Int, _ m: Int, _ s: Int) -> CDTimerEntity? {
        guard !repository.hasRecentItem(hour: h, minute: m, second: s) else { return nil }
        let newTimer = repository.createRecentItem(hour: h, minute: m, second: s)
        repository.saveTimer(newTimer)
        return newTimer.toEntity()
    }

    func deleteTimer(by id: UUID) {
        guard let timer = repository.fetchTimer(by: id) else { return }
        LiveActivityManager.shared.stop(for: timer.id)
        repository.deleteTimer(timer)
        notificationService.cancelTimerNotification(id: timer.id)
    }

    func pauseTimer(for timerID: UUID?, remainTime: Double) {
        guard let timerID, let timer = repository.fetchTimer(by: timerID) else { return }
        repository.stopTimer(timer, remain: remainTime)
        notificationService.cancelTimerNotification(id: timer.id)
        LiveActivityManager.shared.stop(for: timer.id)
    }

    func resumeTimer(for timerID: UUID?) {
        guard let timerID, let timer = repository.fetchTimer(by: timerID) else { return }
        repository.resumeTimer(timer)
        notificationService.scheduleTimer(after: timer.remainSecond, timerID: timer.id)
        LiveActivityManager.shared.start(for: timer.id, endAfter: timer.remainSecond)
    }
}
