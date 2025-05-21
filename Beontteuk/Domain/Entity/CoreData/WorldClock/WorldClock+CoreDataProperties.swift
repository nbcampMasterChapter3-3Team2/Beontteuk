//
//  WorldClock+CoreDataProperties.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

//MARK: - 세계 시계 Entity 명세서
/*
 사용에 앞서 사전 정보가 필요한 내용을 현재 주석을 읽어보시고 확인해주시면 됩니다.
 
 세계 시계에 항목은 기본적으로 최근 항목이 상단에 위치합니다.
 하지만 편집 기능을 통해 orderIndex로 순서를 정렬할 수 있습니다.
 timeZoneIdentifier 속성 값을 통해 시간대 식별자를 구성할 수 있습니다.
 
 세계 시계에 시간대 식별자를 추가해야하는데 세계 시계, 시간대 데이터를 따로 보관해야할 것 같습니다. (ex. JSON Data)
 
 !사용 시 문제 발생은 언제든 말씀해주세요!
 */

extension WorldClock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorldClock> {
        return NSFetchRequest<WorldClock>(entityName: "WorldClock")
    }

    @NSManaged public var id: UUID?                     // 고유 식별자
    @NSManaged public var cityName: String?             // 도시 이름
    @NSManaged public var timeZoneIdentifier: String?   // 시간대 식별자
    @NSManaged public var createdAt: Date?              // 추가된 시간
    @NSManaged public var orderIndex: Int16             // 정렬 순서

    var currentLocalTime: String {
        guard let timeZoneIdentifier = timeZoneIdentifier,
              let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
            return "알 수 없음"
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm" // 24시간제, "a h:mm" 하면 AM/PM 표시
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: Date())
    }
    
}

extension WorldClock : Identifiable {

}
