//
//  LapRecord+CoreDataProperties.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

//MARK: - 랩 레코드 Entity 명세서
/*
 사용에 앞서 사전 정보가 필요한 내용을 현재 주석을 읽어보시고 확인해주시면 됩니다.
 
 랩1, 랩2, 랩3과 같이 랩의 순서를 정하기 위해 lapIndex를 활용하시면 됩니다.
 해당 랩(ex. 랩1, 랩2)에서 경과한 시간을 보여주기 위해 lapTime을 활용하시면 됩니다.
 해당 랩(ex. 랩1, 랩2)이 전체 경과 시간 중 언제 눌렸는지 보여주기 위해 absoluteTime을 활용하시면 됩니다.
 어떤 세션에 속한 랩인지 지정해주기 위해 session을 활용하시면 됩니다.
 
 아마 기능 개발하시면서 세션은 1개 (스톱워치 기능 자체가 하나로만 동작되기 때문)
 랩 레코드는 n개 즉, 1:N 구조로 개발하시게 될 것 같습니다.
 
 스톱워치 재설정을 하게 되면 session과 record는 모두 삭제하고
 새로 스톱워치를 시작하는 경우 새로운 session을 생성하고 랩을 누를 때마다
 랩을 생성하고 session에 추가해주면 될 것 같습니다.
 
 !사용 시 문제 발생은 언제든 말씀해주세요!
 */

extension LapRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LapRecord> {
        return NSFetchRequest<LapRecord>(entityName: "LapRecord")
    }

    @NSManaged public var id: UUID                      // 고유 식별자
    @NSManaged public var lapIndex: Int16               // 몇 번째 랩인지 식별
    @NSManaged public var lapTime: Double               // 해당 랩의 시간 (초 단위)
    @NSManaged public var absoluteTime: Double          // 언제 랩을 눌렀는지 (누른 시점)
    @NSManaged public var recordedAt: Date              // 랩 저장 시각
    @NSManaged public var session: StopWatchSession?    // 어떤 세션에 속한 랩인지 (Relationship)

    func toEntity() -> LapRecordEntity {
        return LapRecordEntity(
            id: id,
            lapIndex: lapIndex,
            lapTime: lapTime,
            absoluteTime: absoluteTime,
            recordedAt: recordedAt
        )
    }
}

extension LapRecord : Identifiable {

}
