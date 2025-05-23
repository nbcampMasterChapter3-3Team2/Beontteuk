//
//  AlarmRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol AlarmRepositoryInterface {
    /// 저장되어 있는 모든 알람 불러오기
    func fetchAllAlarm() -> [Alarm]
    /// 알람 생성
    func createAlarm(hour: Int,
                     minute: Int,
                     repeatDays: String?,
                     label: String?,
                     soundName: String?) -> Alarm
    /// 알람 삭제
    func deleteAlarm(_ alarm: Alarm)
    /// 알람 on/off 변경
    func toggleAlarm(_ alarm: Alarm)
    /// 알람 변경사항 저장
    func saveAlarm(_ alarm: Alarm)
}
