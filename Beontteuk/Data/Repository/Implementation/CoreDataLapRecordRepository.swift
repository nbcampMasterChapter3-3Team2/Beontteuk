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

    /// 모든 랩 불러오기
    func fetchLaps(for session: StopWatchSession) -> [LapRecord] {
        let request: NSFetchRequest<LapRecord> = LapRecord.fetchRequest()
        request.predicate = NSPredicate(format: "session == %@", session)
        request.sortDescriptors = [NSSortDescriptor(key: "lapIndex", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    /// 새로운 랩 생성
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

    /// 기존 단일 랩 삭제
    func deleteLap(_ lap: LapRecord) {
        context.delete(lap)
        do {
            try context.save()
        } catch {
            print("❌ 랩 삭제를 실패하였습니다.: \(error)")
        }
    }

    /// 기존 모든 랩 삭제
    func deleteAllLaps(for session: StopWatchSession) {
        let laps = fetchLaps(for: session)
        laps.forEach { context.delete($0) }
        do {
            try context.save()
        } catch {
            print("❌ 랩 전체 삭제를 실패하였습니다.: \(error)")
        }
    }

    /// 랩 저장
    func saveLap(_ lap: LapRecord) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 랩 저장을 실패하였습니다.: \(error)")
            }
        }
    }

    /// ID로 스톱워치 조회
    func fetchStopWatch(by id: UUID) -> StopWatchSession? {
        let request: NSFetchRequest<StopWatchSession> = StopWatchSession.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
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
         let lap = repository.createLap(for session: session, lapIndex: lapIndex, lapTime: lapTime, absoluteTime: absoluteTime)
         repository2.saveLap(lap) // 항상 CoreData에 변경 사항이 생긴 경우 꼭 save 메서드 호출
     }
 }
 */
