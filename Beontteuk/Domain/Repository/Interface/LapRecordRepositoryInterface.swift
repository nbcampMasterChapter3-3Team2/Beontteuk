//
//  LapRecordRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol LapRecordRepositoryInterface {
    /// 특정 세션에 속한 랩 레코드들을 시간 순으로 가져옴
    func fetchLaps(for session: StopWatchSession) -> [LapRecord]
    /// 특정 세션에 새로운 랩을 추가하고 반환
    func createLap(for session: StopWatchSession,
                   lapIndex: Int,
                   lapTime: Double,
                   absoluteTime: Double) -> LapRecord
    /// 특정 랩을 삭제
    func deleteLap(_ lap: LapRecord)
    /// 전체 랩 삭제 (세션 리셋 시 유용)
    func deleteAllLaps(for session: StopWatchSession)
    /// 변경된 랩을 저장
    func saveLap(_ lap: LapRecord)
    /// ID로 스톱워치 조회
    func fetchStopWatch(by sessionId: UUID) -> StopWatchSession?
}
