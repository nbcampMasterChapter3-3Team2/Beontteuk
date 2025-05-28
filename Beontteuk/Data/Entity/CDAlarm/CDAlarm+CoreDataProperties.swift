//
//  CDAlarm+CoreDataProperties.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

//MARK: - 알람 Entity 명세서
/*
 사용에 앞서 사전 정보가 필요한 내용을 현재 주석을 읽어보시고 확인해주시면 됩니다.
 
 repeatDays는 반복 요일을 나타내며 String? 타입입니다.
 하여 반복 요일을 표현하기 위해서는 repeatDays = "0, 1, 2, 3, 4, 5, 6" 으로 작성해야합니다.
 연산 프로퍼티 repeatDayIndexes로 [Int]로 변환되며, repeatDayNames로 [String]로 변환됩니다.
 최종적으로 repeatDayNames을 joined 해준 joinedRepeatDayNames을 사용하시면 됩니다.
 
 isSnoozeEnabled은 애플 알람 앱에서 제공하는 9분 뒤 다시 알람 기능입니다.
 따로 사용을 안하신다면 false 값을 대입해주면 될 것 같습니다. (기본 값 false 적용)
 
 dateComponents는 알람을 위한 DateComponents 값 입니다.
 DateComponents는 고정된 시각을 반복적으로 울리는데 사용됩니다.
 해당 내용은 추가로 더 찾아보시면 좋을 것 같습니다.
 단, 기존적으로 24시간 제를 받기 때문에 기능 개발에 고려해야할 것 같습니다.
 
 !사용 시 문제 발생은 언제든 말씀해주세요!
 */

extension CDAlarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAlarm> {
        return NSFetchRequest<CDAlarm>(entityName: "CDAlarm")
    }

    @NSManaged public var id: UUID?                 // 고유 식별자
    @NSManaged public var hour: Int16               // 알람 시각 (시)
    @NSManaged public var minute: Int16             // 알람 시각 (분)
    @NSManaged public var repeatDays: String?       // 반복 요일
    @NSManaged public var label: String?            // 알람 레이블
    @NSManaged public var isEnabled: Bool           // 알람 on/off 상태
    @NSManaged public var soundName: String?        // 사운드 이름
    @NSManaged public var isSnoozeEnabled: Bool     // 스누즈 기능 여부
    
    /// 반복 요일 (String -> [Int])
    var repeatDayIndexes: [Int] {
        guard let repeatDays = repeatDays else { return [] }
        return repeatDays
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }
    
    /// 반복 요일 ([Int] -> [String])
    var repeatDayNames: [String] {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        return repeatDayIndexes.compactMap { index in
            guard index >= 0 && index < weekdays.count else { return nil }
            return weekdays[index]
        }
    }
    
    /// 반복 요일 ([String] -> String)
    var joinedRepeatDayNames: String {
        repeatDayNames.joined(separator: ", ")
    }
    
    /// 반복 요일 ([String] -> String)
    var dateComponents: DateComponents {
        DateComponents(hour: Int(hour), minute: Int(minute))
    }
    
    func toEntity() -> CDAlarmEntity {
        return CDAlarmEntity(
            id: id,
            hour: hour,
            minute: minute,
            repeatDays: repeatDays,
            label: label,
            isEnabled: isEnabled,
            soundName: soundName,
            isSnoozeEnabled: isSnoozeEnabled
        )
    }

}

extension CDAlarm : Identifiable {

}
