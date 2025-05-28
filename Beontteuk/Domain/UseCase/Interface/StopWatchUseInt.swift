//
//  StopWatchUseInt.swift
//  Beontteuk
//
//  Created by kingj on 5/27/25.
//

import Foundation

protocol StopWatchUseInt {
    /// 현재 실행 중인 세션 또는 마지막 세션 불러오기
    func fetchLastSession() -> StopWatchEntity?
    /// 새로운 세션 생성
    func createSession() -> StopWatchEntity
    /// 기존 세션 업데이트 - elapsedBeforePause
    func updateSession(by id: UUID, with elapsedBeforePause: Double)
    /// 기존 세션 업데이트 - startTime
    func updateSession(by id: UUID, with startTime: Date)
    /// 기존 세션 삭제
    func deleteSession(by id: UUID)
}
