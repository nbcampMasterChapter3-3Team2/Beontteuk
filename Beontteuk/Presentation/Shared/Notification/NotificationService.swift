//
//  NotificationService.swift
//  Beontteuk
//
//  Created by yimkeul on 5/27/25.
//

import Foundation
import UserNotifications
import UIKit
import AVFoundation

/// 알람 스케줄링 및 취소만 담당하는 서비스
final class NotificationService: NSObject {
    // MARK: - Action Identifiers
    private static let snoozeActionIdentifier = "SNOOZE_ACTION"
    private static let dismissActionIdentifier = UNNotificationDismissActionIdentifier
    private static let alarmCategoryIdentifier = "ALARM_CATEGORY"
    private var audioPlayer: AVAudioPlayer?


    private let repository: AlarmRepositoryInterface

    init(repository: AlarmRepositoryInterface) {
        self.repository = repository
        super.init()
        UNUserNotificationCenter.current().delegate = self

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
//        registerCategories()
    }

    /// 알람 스케줄 요청
    /// - Parameters:
    ///   - date: 알람이 발생할 정확한 날짜/시간
    ///   - snooze: 스누즈 여부 (true면 저장된 시간부터 1분 뒤에 자동 재알림)
    ///   - title: 알림 제목
    ///   - notificationId: 고유 식별자
    func scheduleAlarm(
        at date: Date,
        snooze: Bool,
        title: String,
        notificationId: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = NotificationService.alarmCategoryIdentifier

        let center = UNUserNotificationCenter.current()

        // 1) 원래 알람 스케줄
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        let originalTrigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let originalRequest = UNNotificationRequest(
            identifier: notificationId,
            content: content,
            trigger: originalTrigger
        )
        center.removePendingNotificationRequests(withIdentifiers: [notificationId])
        center.add(originalRequest) { [weak self] error in
            if let error = error {
                print("[NotificationService] original schedule error: \(error)")
            } else {
                print("🔔 Scheduled alarm [id: \(notificationId)] at \(date)")
                self?.printAllAlarms()
            }
        }

        // 2) 스누즈 자동 재알림 (1분 뒤)
        if snooze {
            let snoozeDate = date.addingTimeInterval(60)
            let snoozeComps = Calendar.current.dateComponents([.hour, .minute], from: snoozeDate)
            let snoozeTrigger = UNCalendarNotificationTrigger(dateMatching: snoozeComps, repeats: false)
            let snoozeId = "\(notificationId)_snooze"
            content.title = "다시알림 - \(title)"
            let snoozeRequest = UNNotificationRequest(
                identifier: snoozeId,
                content: content,
                trigger: snoozeTrigger
            )
            center.removePendingNotificationRequests(withIdentifiers: [snoozeId])
            center.add(snoozeRequest) { [weak self] error in
                if let error = error {
                    print("[NotificationService] snooze schedule error: \(error)")
                } else {
                    print("⏱ Scheduled snooze alarm [id: \(snoozeId)] at \(snoozeDate)")
                    self?.printAllAlarms()
                }
            }
        }
    }

    /// 알람 취소
    /// - Parameter notificationId: 취소할 알림 식별자
    func cancelAlarm(notificationId: String) {
        let center = UNUserNotificationCenter.current()
        // 원래 알람 및 스누즈 알람 취소
        let snoozeId = "\(notificationId)_snooze"
        center.removePendingNotificationRequests(withIdentifiers: [notificationId, snoozeId])
        print("🛑 Canceled alarms [ids: \(notificationId), \(snoozeId)]")
        printAllAlarms()
    }

    // MARK: - 알람 목록 출력
    private func printAllAlarms() {
        let alarms = repository.fetchAllAlarm()
        guard !alarms.isEmpty else {
            print("현재 저장된 알람이 없습니다.")
            return
        }
        print("📋 현재 저장된 알람 목록:")
        for alarm in alarms {
            let hour = alarm.hour
            let minute = alarm.minute
            let enabled = alarm.isEnabled
            let snooze = alarm.isSnoozeEnabled
            let id = alarm.id?.uuidString ?? "-"
            print("- [id: \(id)] \(hour):\(String(format: "%02d", minute)) | enabled: \(enabled) | snooze: \(snooze)")
        }
    }

    // MARK: - 오디오 재생 제어
    private func playLongSound() {
        guard let url = Bundle.main.url(forResource: "iPhone-Alarm-Original", withExtension: "wav") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("[NotificationService] AudioPlayer error: \(error)")
        }
    }

    private func stopLongSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        playLongSound()


        // 2) 메인 스레드에서 커스텀 UIAlertController 띄우기
        DispatchQueue.main.async {

            let scenes = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }

            if let windowScene = scenes.first {
                if let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                    let alert = UIAlertController(
                        title: notification.request.content.title,
                        message: "⏰ 알람 발생!",
                        preferredStyle: .alert
                    )
                    alert.addAction(.init(title: "끄기", style: .destructive) { _ in
                        self.stopLongSound()
                    })
                    rootVC.present(alert, animated: true)
                }
            }
        }

        completionHandler([.banner])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        switch response.actionIdentifier {
        case NotificationService.snoozeActionIdentifier:
//             사용자 스누즈 액션 처리 (기존과 동일)
            let now = Date()
            let id = response.notification.request.identifier
            scheduleAlarm(at: now, snooze: true,
                          title: response.notification.request.content.title,
                          notificationId: id)
        default:
            break
        }
        completionHandler()
    }
}
