//
//  CoreDataAlarmRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation
import CoreData

final class CoreDataAlarmRepository: AlarmRepositoryInterface {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    /// 알람 리스트 불러오기
    func fetchAllAlarm() -> [CDAlarm] {
        let request: NSFetchRequest<CDAlarm> = CDAlarm.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "hour", ascending: true),
            NSSortDescriptor(key: "minute", ascending: true)
        ]
        return (try? context.fetch(request)) ?? []
    }

    /// 알람 불러오기
    func fetchAlarm(by id: UUID) -> CDAlarm? {
        let request: NSFetchRequest<CDAlarm> = CDAlarm.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }

    /// 알람 생성
    func createAlarm(hour: Int,
                     minute: Int,
                     repeatDays: String?,
                     label: String?,
                     soundName: String?,
                     snooze: Bool
    ) -> CDAlarm {
        let alarm = CDAlarm(context: context)
        alarm.id = UUID()
        alarm.hour = Int16(hour)
        alarm.minute = Int16(minute)
        alarm.repeatDays = repeatDays
        alarm.label = label
        alarm.isEnabled = true
        alarm.soundName = soundName
        alarm.isSnoozeEnabled = snooze
        return alarm
    }

    /// 알람 삭제
    func deleteAlarm(_ alarm: CDAlarm) {
        context.delete(alarm)
        do {
            try context.save()
        } catch {
            print("❌ 알람 삭제를 실패하였습니다.: \(error)")
        }
    }

    /// 알람 토글 전환
    func toggleAlarm(_ alarm: CDAlarm) {
        alarm.isEnabled.toggle()
        do {
            try context.save()
        } catch {
            print("❌ 알람 on/off 변경을 실패하였습니다.: \(error)")
        }
    }
    
    /// 알람 저장 (생성 및 수정 시 활용)
    func saveAlarm(_ alarm: CDAlarm) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 알람 저장을 실패하였습니다.: \(error)")
            }
        }
    }
}

//MARK: - ViewModel 사용 예시 (UseCase 미적용)
/*
 class AlarmViewModel {
     private let repository: AlarmRepositoryInterface

     init(repository: AlarmRepositoryInterface = CoreDataAlarmRepository()) {
         self.repository = repository
     }

     func addAlarm(hour: Int, minute: Int, repeatDays: String?, label: String?, soundName: String?) {
         let alarm = repository.createAlarm(hour: hour, minute: minute, repeatDays: repeatDays, label: label, soundName: soundName)
         repository.saveAlarm(alarm) // 항상 CoreData에 변경 사항이 생긴 경우 꼭 save 메서드 호출
     }
 }
 */
