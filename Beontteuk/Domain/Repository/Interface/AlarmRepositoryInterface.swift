//
//  AlarmRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol AlarmRepositoryInterface {
    /// 저장되어 있는 모든 알람 불러오기
    func fetchAllAlarm() -> [CDAlarm]

    /// ID로 알람 조회
    func fetchAlarm(by id: UUID) -> CDAlarm?

    /// 알람 생성
    func createAlarm(hour: Int,
        minute: Int,
        repeatDays: String?,
        label: String?,
        soundName: String?,
        snooze: Bool
    ) -> CDAlarm

    /// 알람 삭제
    func deleteAlarm(_ alarm: CDAlarm)

    /// 알람 on/off 변경
    func toggleAlarm(_ alarm: CDAlarm)

    /// 알람 변경사항 저장
    func saveAlarm(_ alarm: CDAlarm)
}
