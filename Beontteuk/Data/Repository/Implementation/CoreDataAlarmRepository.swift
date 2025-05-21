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
    func fetchAll() -> [Alarm] {
        let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "hour", ascending: true),
            NSSortDescriptor(key: "minute", ascending: true)
        ]
        return (try? context.fetch(request)) ?? []
    }

    /// 알람 생성 및 저장
    func save(_ alarm: Alarm) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save Alarm: \(error)")
            }
        }
    }

    /// 알람 삭제
    func delete(_ alarm: Alarm) {
        context.delete(alarm)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete Alarm: \(error)")
        }
    }

    /// 알람 토글 전환
    func toggle(_ alarm: Alarm) {
        alarm.isEnabled.toggle()
        do {
            try context.save()
        } catch {
            print("❌ Failed to toggle Alarm: \(error)")
        }
    }
}

//MARK: - ViewModel 사용 예시
/*
 class AlarmViewModel {
     private let repository: AlarmRepositoryInterface

     init(repository: AlarmRepositoryInterface = CoreDataAlarmRepository()) {
         self.repository = repository
     }

     func addAlarm(hour: Int, minute: Int) {
         let alarm = Alarm(context: CoreDataStack.shared.context)
         alarm.id = UUID()
         alarm.hour = Int16(hour)
         alarm.minute = Int16(minute)
         alarm.isEnabled = true
         repository.save(alarm)
     }
 }
 */
