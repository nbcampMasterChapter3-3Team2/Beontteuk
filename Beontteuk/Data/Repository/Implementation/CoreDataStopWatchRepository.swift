//
//  CoreDataStopWatchRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/22/25.
//

import Foundation
import CoreData

final class CoreDataStopWatchRepository: StopWatchSessionRepositoryInterface {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    /// 현재 실행 중인 세션 또는 마지막 세션 불러오기
    func fetchLastSession() -> StopWatchSession? {
        let request: NSFetchRequest<StopWatchSession> = StopWatchSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    /// 새로운 세션 생성
    func createSession() -> StopWatchSession {
        let session = StopWatchSession(context: context)
        session.id = UUID()
        session.startTime = Date()
        session.createdAt = Date()
        session.elapsedBeforePause = 0
        session.isRunning = true
        return session
    }

    /// 기존 세션 업데이트 - elapsedBeforePause
    func updateSession(_ session: StopWatchSession, with elapsedBeforePause: Double) {
        session.elapsedBeforePause = elapsedBeforePause
        do {
            try context.save()
        } catch {
            print("❌ 세션 업데이트를 실패하였습니다.: \(error)")
        }
    }

    /// 기존 세션 업데이트 - startTime
    func updateSession(_ session: StopWatchSession, with startTime: Date) {
        session.startTime = startTime
        do {
            try context.save()
        } catch {
            print("❌ 세션 업데이트를 실패하였습니다.: \(error)")
        }
    }

    /// 기존 세션 삭제
    func deleteSession(_ session: StopWatchSession) {
        context.delete(session)
        do {
            try context.save()
        } catch {
            print("❌ 세션 삭제를 실패하였습니다.: \(error)")
        }
    }
    
    /// 세션 저장 (일시정지, 랩 추가 등)
    func saveSession(_ session: StopWatchSession) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 세션 저장을 실패하였습니다.: \(error)")
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
     private let repository: StopWatchSessionRepositoryInterface

     init(repository: StopWatchSessionRepositoryInterface = CoreDataStopWatchRepository()) {
         self.repository = repository
     }

     func addSession() {
         let session = repository.createSession()
         repository.saveSession(session) // 항상 CoreData에 변경 사항이 생긴 경우 꼭 save 메서드 호출
     }
 }
 */
