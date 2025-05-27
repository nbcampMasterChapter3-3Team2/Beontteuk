//
//  CoreDataCDTimerRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/22/25.
//

import Foundation

import CoreData

final class CoreDataCDTimerRepository: CDTimerRepositoryInterface {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // MARK: - 타이머 CRUD
    /// 새 타이머 생성
    func createTimer(hour: Int, minute: Int, second: Int, label: String?, soundName: String?) -> CDTimer {
        let timer = CDTimer(context: context)
        timer.id = UUID()
        timer.remainSecond = Double(hour * 3600 + minute * 60 + second)
        timer.totalSecond = Double(hour * 3600 + minute * 60 + second)
        timer.label = label
        timer.soundName = soundName
        timer.isRunning = true
        timer.isRecent = false
        timer.createdAt = Date()
        timer.endTime = Date().addingTimeInterval(Double(hour * 3600 + minute * 60 + second))
        return timer
    }

    /// 타이머 삭제
    func deleteTimer(_ timer: CDTimer) {
        context.delete(timer)
        do {
            try context.save()
        } catch {
            print("❌ 타이머 삭제를 실패하였습니다.: \(error)")
        }
    }

    /// 타이머 저장(종료 시간, 라벨 수정 등)
    func saveTimer(_ timer: CDTimer) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 타이머 저장을 실패하였습니다.: \(error)")
            }
        }
    }

    /// 타이머 정지 처리 (isRunning == false)
    func stopTimer(_ timer: CDTimer, remain: Double) {
        timer.isRunning = false
        timer.remainSecond = remain
        timer.endTime = nil
        do {
            try context.save()
        } catch {
            print("❌ 타이머 정지를 실패하였습니다.: \(error)")
        }
    }

    /// 타이머 재개 처리 (isRunning == true)
    func resumeTimer(_ timer: CDTimer) {
        timer.isRunning = true
        timer.endTime = Date().addingTimeInterval(timer.remainSecond)
        do {
            try context.save()
        } catch {
            print("❌ 타이머 재개를 실패하였습니다.: \(error)")
        }
    }

    // MARK: - 타이머 조회
    /// ID로 타이머 조회
    func fetchTimer(by id: UUID) -> CDTimer? {
        let request: NSFetchRequest<CDTimer> = CDTimer.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    /// 실행 중인 타이머만
    func fetchRunningTimers() -> [CDTimer] {
        let request: NSFetchRequest<CDTimer> = CDTimer.fetchRequest()
        request.predicate = NSPredicate(format: "isRunning == true AND isRecent == false")
        return (try? context.fetch(request)) ?? []
    }

    /// 실행 중 또는 일시정지된 타이머 (UI 리스트용)
    func fetchActiveTimers() -> [CDTimer] {
        let request: NSFetchRequest<CDTimer> = CDTimer.fetchRequest()
        request.predicate = NSPredicate(format: "isRecent == false") // isRecent == false
        return (try? context.fetch(request)) ?? []
    }

    // MARK: - 최근 항목 (isRecent == true)
    /// 최근 항목 목록 조회
    func fetchRecentItems() -> [CDTimer] {
        let request: NSFetchRequest<CDTimer> = CDTimer.fetchRequest()
        request.predicate = NSPredicate(format: "isRecent == true")
        return (try? context.fetch(request)) ?? []
    }

    /// 시/분/초가 중복되지 않는 경우에만 최근 항목 추가
    func createRecentItem(hour: Int, minute: Int, second: Int) -> CDTimer {
        let timer = CDTimer(context: context)
        timer.id = UUID()
        timer.totalSecond = Double(hour * 3600 + minute * 60 + second)
        timer.isRunning = false
        timer.isRecent = true
        timer.createdAt = Date()
        return timer
    }

    /// 시/분/초 조합으로 최근 항목 존재 여부 확인
    func hasRecentItem(hour: Int, minute: Int, second: Int) -> Bool {
        let request: NSFetchRequest<CDTimer> = CDTimer.fetchRequest()
        request.predicate = NSPredicate(format: "totalSecond == %f AND isRecent == true", Double(hour * 3600 + minute * 60 + second))
        request.fetchLimit = 1
        return (try? context.count(for: request)) ?? 0 > 0
    }

    /// 최근 항목의 실행 버튼 클릭 시, 타이머로 복사하여 실행
    func duplicateRecentItemAndStart(_ recent: CDTimer) -> CDTimer {
        let timer = CDTimer(context: context)
        timer.id = UUID()
        timer.remainSecond = recent.totalSecond
        timer.totalSecond = recent.totalSecond
        timer.label = recent.label
        timer.soundName = recent.soundName
        timer.isRunning = true
        timer.isRecent = false
        timer.createdAt = Date()
        timer.endTime = Date().addingTimeInterval(recent.totalSecond)
        return timer
    }
}

//MARK: - ViewModel 사용 예시 (UseCase 미적용)
/*
 class TimerViewModel {
     private let repository: TimerRepositoryInterface
 
     init(repository: TimerRepositoryInterface = CoreDataCDTimerRepository()) {
         self.repository = repository
     }

     func addTimer(hour: Int, minute: Int, second: Int, label: String?, soundName: String?) {
         let cdTimer = repository.createTimer(hour: hour, minute: minute, second: second, label: label, soundName: soundName)
         repository.saveTimer(cdTimer) // 항상 CoreData에 변경 사항이 생긴 경우 꼭 save 메서드 호출
     }
 }
 */
