//
//  WorldClockRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation

protocol WorldClockRepositoryInterface {
    // MARK: - 조회
    /// 저장된 모든 세계 시계 항목 반환 (orderIndex 순 정렬)
    func fetchAll() -> [WorldClock]
    
    /// 특정 id로 항목 조회
    func fetchWorldClock(by id: UUID) -> WorldClock?

    /// 특정 시간대 식별자를 가진 항목 조회
    func fetchTimeZone(by timeZoneIdentifier: String) -> WorldClock?

    /// 해당 시간대 식별자가 이미 존재하는지 여부 확인
    func exists(timeZoneIdentifier: String) -> Bool

    // MARK: - 추가 및 삭제
    /// 새 도시 항목 추가
    func createCity(cityName: String, cityNameKR: String, timeZoneIdentifier: String) -> WorldClock

    /// 도시 항목 삭제
    func deleteCity(_ city: WorldClock)
    
    /// 도시 항목 저장
    func saveCity(_ city: WorldClock)

    // MARK: - 정렬 및 순서
    /// 주어진 항목의 정렬 순서를 업데이트
    func updateOrder(for city: WorldClock, to newIndex: Int16)

    /// 전체 orderIndex를 재정렬 (예: 드래그 reorder 이후)
    func reorder(citys: [WorldClock])
}
