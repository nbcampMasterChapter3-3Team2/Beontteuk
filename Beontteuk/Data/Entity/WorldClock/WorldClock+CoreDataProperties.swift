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
    @NSManaged public var cityNameKR: String?           // 도시 이름 (한국어)
    @NSManaged public var timeZoneIdentifier: String?   // 시간대 식별자
    @NSManaged public var createdAt: Date?              // 추가된 시간
    @NSManaged public var orderIndex: Int16             // 정렬 순서

    // ✅ 현지 시간 (ex. "11:26", "20:26")
    var hourMinuteString: String {
        guard let timeZoneIdentifier = timeZoneIdentifier,
              let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
            return "알 수 없음"
        }

        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.current

        let is24Hour = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.contains("a") == false

        formatter.dateFormat = is24Hour ? "HH:mm" : "hh:mm"
        return formatter.string(from: Date())
    }
    
    // ✅ 오전/오후 표시 (기기의 24시간제 여부 추적)
    var amPmString: String? {
        guard let timeZoneIdentifier = timeZoneIdentifier,
              let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
            return nil
        }
        
        let is24Hour = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.contains("a") == false
        
        if is24Hour {
            return nil
        }

        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX") // AM/PM 고정 표현
        formatter.dateFormat = "a"

        let symbol = formatter.string(from: Date())
        return Locale.current.identifier == "ko_KR" ? (symbol == "AM" ? "오전" : "오후") : symbol
    }
    
    // ✅ +X시간 / -X시간
    var hourDifferenceText: String {
        guard let timeZone = TimeZone(identifier: timeZoneIdentifier!) else { return "" }
        let localOffset = TimeZone.current.secondsFromGMT()
        let cityOffset = timeZone.secondsFromGMT()
        let diff = (cityOffset - localOffset) / 3600
        if diff == 0 {
            return "+0시간"
        } else {
            return diff > 0 ? "+\(diff)시간" : "\(diff)시간"
        }
    }
    
    // ✅ 오늘/어제 판단 (현지 기준)
    var dayLabelText: String {
        guard let timeZoneIdentifier,
              let cityTimeZone = TimeZone(identifier: timeZoneIdentifier) else { return "" }
        
        let now = Date()
        
        // 1. 기준 캘린더
        let calendar = Calendar(identifier: .gregorian)
        
        // 2. 도시 시간대로 변환한 시간
        let localNow = now.convert(to: cityTimeZone)
        
        // 3. 오늘 기준 (기기 시간)
        let today = calendar.startOfDay(for: now)
        
        // 4. 도시 기준의 날짜
        let cityDay = calendar.startOfDay(for: localNow)
        
        let dayDiff = calendar.dateComponents([.day], from: today, to: cityDay).day ?? 0
        
        switch dayDiff {
        case -1: return "어제"
        case  0: return "오늘"
        case  1: return "내일"
        default: return "\(dayDiff)일"
        }
    }
    
    func toEntity() -> WorldClockEntity {
        return WorldClockEntity(
            id: id,
            cityName: cityName,
            cityNameKR: cityNameKR,
            timeZoneIdentifier: timeZoneIdentifier,
            createdAt: createdAt,
            orderIndex: orderIndex,
            hourMinuteString: hourMinuteString,
            amPmString: amPmString,
            hourDifferenceText: hourDifferenceText,
            dayLabelText: dayLabelText,
            isEditing: false
        )
    }
}

extension WorldClock : Identifiable {

}
