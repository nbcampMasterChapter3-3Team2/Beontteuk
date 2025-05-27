//
//  LapRecordUseInt.swift
//  Beontteuk
//
//  Created by kingj on 5/27/25.
//

import Foundation

protocol LapRecordUseInt {
    /// 모든 랩 불러오기
    func fetchLaps(by id: UUID) -> [LapRecordEntity]
    /// 새로운 랩 생성
    func createLap(for sessionId: UUID, lapIndex: Int, lapTime: Double, absoluteTime: Double) -> LapRecordEntity?
}
