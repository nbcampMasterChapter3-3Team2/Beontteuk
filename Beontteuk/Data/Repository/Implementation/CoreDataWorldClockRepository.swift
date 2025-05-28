//
//  CoreDataWorldClockRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/22/25.
//

import Foundation
import CoreData

final class CoreDataWorldClockRepository: WorldClockRepositoryInterface {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    // MARK: - 조회
    /// 저장된 모든 세계 시계 항목 반환 (orderIndex 순 정렬)
    func fetchAll() -> [WorldClock] {
        let request: NSFetchRequest<WorldClock> = WorldClock.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
    
    /// 특정 id 항목 조회
    func fetchWorldClock(by id: UUID) -> WorldClock? {
        let request: NSFetchRequest<WorldClock> = WorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    /// 특정 시간대 식별자를 가진 항목 조회
    func fetchTimeZone(by timeZoneIdentifier: String) -> WorldClock? {
        let request: NSFetchRequest<WorldClock> = WorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "timeZoneIdentifier == %@", timeZoneIdentifier)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    /// 해당 시간대 식별자가 이미 존재하는지 여부 확인
    func exists(timeZoneIdentifier: String) -> Bool {
        let request: NSFetchRequest<WorldClock> = WorldClock.fetchRequest()
        request.predicate = NSPredicate(format: "timeZoneIdentifier == %@", timeZoneIdentifier)
        request.fetchLimit = 1
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    // MARK: - 추가 및 삭제
    /// 새 도시 항목 추가
    func createCity(cityName: String, cityNameKR: String, timeZoneIdentifier: String) -> WorldClock {
        let clock = WorldClock(context: context)
        clock.id = UUID()
        clock.cityName = cityName
        clock.cityNameKR = cityNameKR
        clock.timeZoneIdentifier = timeZoneIdentifier
        clock.createdAt = Date()
        clock.orderIndex = Int16(fetchAll().count)
        
        return clock
    }
    
    /// 도시 항목 삭제
    func deleteCity(_ city: WorldClock) {
        context.delete(city)
        do {
            try context.save()
        } catch {
            print("❌ 세계 시계 항목 삭제 실패: \(error)")
        }
    }
    
    /// 도시 항목 저장
    func saveCity(_ city: WorldClock) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 세션 저장을 실패하였습니다.: \(error)")
            }
        }
    }
    
    // MARK: - 정렬 및 순서
    /// 주어진 항목의 정렬 순서를 업데이트
    func updateOrder(for city: WorldClock, to newIndex: Int16) {
        city.orderIndex = newIndex
        do {
            try context.save()
        } catch {
            print("❌ 정렬 순서 업데이트 실패: \(error)")
        }
    }
    
    /// 전체 orderIndex를 재정렬 (예: 드래그 reorder 이후)
    func reorder(citys: [WorldClock]) {
        for (index, clock) in citys.enumerated() {
            clock.orderIndex = Int16(index)
        }
        do {
            try context.save()
        } catch {
            print("❌ 전체 순서 재정렬 실패: \(error)")
        }
    }
}

//MARK: - ViewModel 사용 예시 (UseCase 미적용)
/*
 class WorldClockViewModel {
     private let repository: WorldClockRepositoryInterface

     init(repository: WorldClockRepositoryInterface = CoreDataWorldClockRepository()) {
         self.repository = repository
     }

     func createCity(cityName: String, timeZoneIdentifier: String) {
         let session = repository.createCity(cityName: cityName, timeZoneIdentifier: timeZoneIdentifier)
         repository.saveSession(session) // 항상 CoreData에 변경 사항이 생긴 경우 꼭 save 메서드 호출
     }
 }
 */
