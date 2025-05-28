//
//  LapRecordUseImp.swift
//  Beontteuk
//
//  Created by kingj on 5/27/25.
//

import Foundation

final class LapRecordUseImp: LapRecordUseInt {

    private let repository: LapRecordRepositoryInterface

    init(repository: LapRecordRepositoryInterface) {
        self.repository = repository
    }

    /// 모든 랩 불러오기
    func fetchLaps(by sessionId: UUID) -> [LapRecordEntity] {
        guard let session = repository.fetchStopWatch(by: sessionId) else {
            return []
        }
        return repository.fetchLaps(for: session).compactMap {
            $0.toEntity()
        }
    }

    /// 새로운 랩 생성
    func createLap(
        for sessionId: UUID,
        lapIndex: Int,
        lapTime: Double,
        absoluteTime: Double
    ) -> LapRecordEntity? {
        guard let session = repository.fetchStopWatch(by: sessionId) else { return nil }
        let lap = repository.createLap(
            for: session,
            lapIndex: lapIndex,
            lapTime: lapTime,
            absoluteTime: absoluteTime
        )
        repository.saveLap(lap)
        return lap.toEntity()
    }
}
