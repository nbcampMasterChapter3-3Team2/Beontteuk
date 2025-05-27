//
//  StopWatchUseImp.swift
//  Beontteuk
//
//  Created by kingj on 5/27/25.
//

import Foundation

final class StopWatchUseImp: StopWatchUseInt {

    private let repository: StopWatchSessionRepositoryInterface

    init(repository: StopWatchSessionRepositoryInterface) {
        self.repository = repository
    }

    /// 현재 실행 중인 세션 또는 마지막 세션 불러오기
    func fetchLastSession() -> StopWatchEntity? {
        guard let session = repository.fetchLastSession() else { return nil }
        let lapsEntity = session.toEntity(with: session.laps)
        return session.toEntity(with: lapsEntity)
    }

    /// 새로운 세션 생성
    func createSession() -> StopWatchEntity {
        let session = repository.createSession()
        repository.saveSession(session)
        return session.toEntity(with: [])
    }

    /// 기존 세션 업데이트 - elapsedBeforePause
    func updateSession(by id: UUID, with elapsedBeforePause: Double) {
        guard let session = repository.fetchStopWatch(by: id) else { return }
        repository.updateSession(session, with: elapsedBeforePause)
        repository.saveSession(session)
    }

    /// 기존 세션 업데이트 - startTime
    func updateSession(by id: UUID, with startTime: Date) {
        guard let session = repository.fetchStopWatch(by: id) else { return }
        repository.updateSession(session, with: startTime)
        repository.saveSession(session)
    }

    /// 기존 세션 삭제
    func deleteSession(by id: UUID) {
        guard let session = repository.fetchStopWatch(by: id) else { return }
        repository.deleteSession(session)
        repository.saveSession(session)
    }
}
