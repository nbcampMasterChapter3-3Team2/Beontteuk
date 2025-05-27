//
//  CDTimerRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol CDTimerRepositoryInterface {
    // MARK: - 타이머 CRUD
    /// 새 타이머 생성
    func createTimer(hour: Int, minute: Int, second: Int, label: String?, soundName: String?) -> CDTimer
    
    /// 타이머 삭제
    func deleteTimer(_ timer: CDTimer)

    /// 타이머 저장 (종료 시간, 라벨 수정 등)
    func saveTimer(_ timer: CDTimer)

    /// 타이머 정지 처리 (isRunning = false)
    func stopTimer(_ timer: CDTimer, remain: Double)

    /// 타이머 재개 처리 (isRunning == true)
    func resumeTimer(_ timer: CDTimer)

    // MARK: - 타이머 조회
    /// ID로 타이머 조회
    func fetchTimer(by id: UUID) -> CDTimer?

    /// 실행 중인 타이머만
    func fetchRunningTimers() -> [CDTimer]

    /// 실행 중 또는 일시정지된 타이머 (UI 리스트용)
    func fetchActiveTimers() -> [CDTimer] // isRecent == false

    // MARK: - 최근 항목 (isRecent == true)
    /// 최근 항목 목록 조회
    func fetchRecentItems() -> [CDTimer]

    /// 시/분/초가 중복되지 않는 경우에만 최근 항목 추가
    func createRecentItem(hour: Int, minute: Int, second: Int) -> CDTimer

    /// 시/분/초 조합으로 최근 항목 존재 여부 확인
    func hasRecentItem(hour: Int, minute: Int, second: Int) -> Bool

    /// 최근 항목의 실행 버튼 클릭 시, 타이머로 복사하여 실행
    func duplicateRecentItemAndStart(_ recent: CDTimer) -> CDTimer
}
