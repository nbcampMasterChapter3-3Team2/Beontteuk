//
//  CoreDataLapRecordRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/22/25.
//

import Foundation
import CoreData

final class CoreDataLapRecordRepository: LapRecordRepositoryInterface {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetchLaps(for session: StopWatchSession) -> [LapRecord] {
        let request: NSFetchRequest<LapRecord> = LapRecord.fetchRequest()
        request.predicate = NSPredicate(format: "session == %@", session)
        request.sortDescriptors = [NSSortDescriptor(key: "lapIndex", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
    
    func createLap(for session: StopWatchSession, lapIndex: Int, lapTime: Double, absoluteTime: Double) -> LapRecord {
        let lap = LapRecord(context: context)
        lap.id = UUID()
        lap.lapIndex = Int16(lapIndex)
        lap.lapTime = lapTime
        lap.absoluteTime = absoluteTime
        lap.recordedAt = Date()
        lap.session = session
        return lap
    }
    
    func deleteLap(_ lap: LapRecord) {
        context.delete(lap)
        do {
            try context.save()
        } catch {
            print("❌ 랩 삭제에 실패하였습니다.: \(error)")
        }
    }
    
    func deleteAllLaps(for session: StopWatchSession) {
        let laps = fetchLaps(for: session)
        laps.forEach { context.delete($0) }
        do {
            try context.save()
        } catch {
            print("❌ 랩 전체 삭제에 실패하였습니다.: \(error)")
        }
    }
    
    func saveLap(_ lap: LapRecord) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 랩 저장에 실패하였습니다.: \(error)")
            }
        }
    }
}

//MARK: - ViewModel 사용 예시 (UseCase 미적용)
/*
 class StopWatchViewModel {
     private let repository1: StopWatchSessionRepositoryInterface
     private let repository2: LapRecordRepositoryInterface

     init(repository1: StopWatchSessionRepositoryInterface = CoreDataStopWatchRepository()
          repository2: LapRecordRepositoryInterface = CoreDataLapRecordRepository()) {
         self.repository1 = repository1
         self.repository2 = repository2
     }

     func addLap(for session: StopWatchSession, lapIndex: Int, lapTime: Double, absoluteTime: Double) {
         let lap = repository.createLap(for session: session, lapIndex: Int, lapTime: Double, absoluteTime: Double)
         repository2.saveLap(lap)
     }
 }
 */
