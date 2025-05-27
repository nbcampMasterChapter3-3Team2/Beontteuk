//
//  StopWatchSession+CoreDataProperties.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

//MARK: - 스톱워치 Entity 명세서
/*
 사용에 앞서 사전 정보가 필요한 내용을 현재 주석을 읽어보시고 확인해주시면 됩니다.
 
 startTime은 스톱워치의 시작을 누를 때 마다 현시점의 값을 넣어주시면 될 것 같습니다.
 스톱워치 시작 후 일시정지를 누르면 elapsedBeforePause 값에 시작된 시점에서 현재 시점까지의
 동작 시간을 누적하면 될 것 같습니다.
 isRunning은 현재 동작 중임을 표시하고 createdAt은 해당 StopWatchSession을 생성한 시점을 대입하면
 될 것 같습니다.
 
 StopWatchSession은 LapRecord와 Relationship을 가집니다.
 동작 중인 스톱워치에서 '랩 버튼'을 클릭 시 하단의 추가 및 제거 메서드를 활용하시면 됩니다.
 
 !사용 시 문제 발생은 언제든 말씀해주세요!
 */


extension StopWatchSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopWatchSession> {
        return NSFetchRequest<StopWatchSession>(entityName: "StopWatchSession")
    }

    @NSManaged public var id: UUID                      // 고유 식별자
    @NSManaged public var startTime: Date?              // 타이머가 마지막으로 시작된 시점 기록
    @NSManaged public var isRunning: Bool               // 현재 실행중인지 판별
    @NSManaged public var elapsedBeforePause: Double    // 일시정지 시 누적된 시간 보존
    @NSManaged public var createdAt: Date               // 스톱워치 생성 시각
    
    @NSManaged public var laps: NSSet?                  // 랩 기록 저장 및 조회용 관계 필드
    
    var totalElapsed: TimeInterval {
        if isRunning {
            return elapsedBeforePause + Date().timeIntervalSince(startTime!)
        } else {
            return elapsedBeforePause
        }
    }
    
    func toEntity(with laps: [LapRecordEntity]) -> StopWatchEntity {
        return StopWatchEntity(
            id: id,
            startTime: startTime,
            isRunning: isRunning,
            elapsedBeforePause: elapsedBeforePause,
            createdAt: createdAt,
            laps: laps
        )
    }

    func toEntity(with lapsNSSet: NSSet?) -> [LapRecordEntity] {
        guard let lapsNSSet,
              let laps = lapsNSSet as? Set<LapRecord> else { return [] }
        return laps.compactMap { $0.toEntity() }
    }
}

// MARK: Generated accessors for laps
extension StopWatchSession {

    /// 단일 객체 추가
    @objc(addLapsObject:)
    @NSManaged public func addToLaps(_ value: LapRecord)

    /// 단일 객체 제거
    @objc(removeLapsObject:)
    @NSManaged public func removeFromLaps(_ value: LapRecord)

    /// 다중 객체 추가
    @objc(addLaps:)
    @NSManaged public func addToLaps(_ values: NSSet)

    /// 다중 객체 제거
    @objc(removeLaps:)
    @NSManaged public func removeFromLaps(_ values: NSSet)

}

extension StopWatchSession : Identifiable {

}
