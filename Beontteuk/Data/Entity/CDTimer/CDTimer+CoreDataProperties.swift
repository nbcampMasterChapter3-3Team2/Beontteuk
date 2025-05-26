//
//  CDTimer+CoreDataProperties.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

//MARK: - 타이머 Entity 명세서
/*
 사용에 앞서 사전 정보가 필요한 내용을 현재 주석을 읽어보시고 확인해주시면 됩니다.
 
 타이머에서 설정한 시, 분, 초 값을 해당하는 값에 대입해주시면 됩니다.
 isRunning 속성을 통해 실행 중 여부를 구성하시면 될 것 같습니다.
 isRunning이 true로 변경되는 경우 남은 시간을 계산하여 endTime을 고려해주시면 될 것 같습니다.
 
 애플 순정 알람 앱의 타이머 탭에는 타이머, 최근 항목 섹션이 나눠져 있습니다.
 isRecent 속성을 통해 true인 값들로 최근 항목을 구성하고 fasle인 값들로 타이머를 구성해주시면 될 것 같습니다.
 
 ex. 타이머 추가 -> 시간, 분, 초 설정 -> 타이머 추가 및 최근항목 추가
 -> 총 2개의 객체가 생성되며 타이머로 동작하는 객체는 isRunning = true, isRecent = false
 -> 최근 항목에 추가되는 객체는 isRunning = false, isRecent = true
 -> 동작 중인 타이머가 끝나거나 삭제되어도 최근 항목은 삭제되지 않음
 -> 최근 항목의 플레이 버튼을 누르면 타이머에 객체 추가
 
 !사용 시 문제 발생은 언제든 말씀해주세요!
 */

extension CDTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTimer> {
        return NSFetchRequest<CDTimer>(entityName: "CDTimer")
    }

    @NSManaged public var id: UUID?             // 고유 식별자
    @NSManaged public var remainSecond: Double  // 타이머 최초 설정 및 남은 시간을 갖게 됨
    @NSManaged public var totalSecond: Double   // 타이머 최초 설정 시 시, 분, 초 -> 초로 계산
    @NSManaged public var label: String?        // 사용자가 입력한 라벨
    @NSManaged public var soundName: String?    // 사운드 이름
    @NSManaged public var createdAt: Date?      // 최초 생성 시간
    
    @NSManaged public var isRunning: Bool       // 실행 중 여부
    @NSManaged public var endTime: Date?        // 실행 종료 시각
    
    @NSManaged public var isRecent: Bool        // 최근 항목 여부
    
    func toEntity() -> CDTimerEntity {
        return CDTimerEntity(
            id: id,
            remainSecond: remainSecond,
            totalSecond: totalSecond,
            label: label,
            soundName: soundName,
            createdAt: createdAt,
            isRunning: isRunning,
            endTime: endTime,
            isRecent: isRecent
        )
    }
}

extension CDTimer : Identifiable {

}
