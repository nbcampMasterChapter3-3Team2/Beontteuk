//
//  StopWatchSessionRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol StopWatchSessionRepositoryInterface {
    /// 현재 실행 중인 세션 또는 마지막 세션 불러오기
    func fetchLastSession() -> StopWatchSession?
    /// 새로운 세션 생성
    func createSession() -> StopWatchSession
    /// 기존 세션 삭제
    func deleteSession(_ session: StopWatchSession)
    /// 세션 저장 (일시정지, 랩 추가 등)
    func saveSession(_ session: StopWatchSession)
    
}
