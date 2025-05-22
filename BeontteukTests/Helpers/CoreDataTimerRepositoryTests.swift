//
//  CoreDataTimerRepositoryTests.swift
//  BeontteukTests
//
//  Created by 백래훈 on 5/22/25.
//

import CoreData

import XCTest
@testable import Beontteuk

final class CoreDataTimerRepositoryTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var repository: CDTimerRepositoryInterface!

    override func setUp() {
        super.setUp()
        container = CoreDataTestHelper.makeInMemoryContainer(modelName: "Beontteuk")
        repository = CoreDataCDTimerRepository(context: container.viewContext)
    }
    
    /// 타이머 생성 후 저장 확인
    func test_createTimer_shouldSetCorrectProperties() {
        let timer = repository.createTimer(hour: 1, minute: 30, second: 15, label: "Test", soundName: "bell")
        repository.saveTimer(timer)

        let fetched = repository.fetchActiveTimers().first
        XCTAssertEqual(fetched?.hour, 1)
        XCTAssertEqual(fetched?.minute, 30)
        XCTAssertEqual(fetched?.second, 15)
        XCTAssertEqual(fetched?.label, "Test")
        XCTAssertEqual(fetched?.soundName, "bell")
        XCTAssertEqual(fetched?.isRunning, true)
        XCTAssertNotEqual(fetched?.isRecent, true)
        XCTAssertTrue(fetched?.isRunning ?? false)
        XCTAssertFalse(fetched?.isRecent ?? true)
    }

    /// 타이머 생성 및 업데이트 후 확인
    func test_saveTimer_shouldPersistChanges() {
        let timer = repository.createTimer(hour: 0, minute: 5, second: 0, label: nil, soundName: nil)
        repository.saveTimer(timer)

        timer.label = "Updated"
        repository.saveTimer(timer)

        let fetched = repository.fetchActiveTimers().first
        XCTAssertEqual(fetched?.label, "Updated")
    }

    /// 타이머 생성 후 일시정지 확인
    func test_stopTimer_shouldSetIsRunningFalse() {
        let timer = repository.createTimer(hour: 0, minute: 3, second: 0, label: nil, soundName: nil)
        repository.saveTimer(timer)

        repository.stopTimer(timer)

        let fetched = repository.fetchActiveTimers().first
        XCTAssertFalse(fetched?.isRunning ?? true)
    }

    /// 2개의 타이머 생성 후
    /// 실행 중인 타이머 확인
    func test_fetchRunningTimers_shouldReturnOnlyRunning() {
        let timer1 = repository.createTimer(hour: 0, minute: 1, second: 0, label: "Running", soundName: nil)
        let timer2 = repository.createTimer(hour: 0, minute: 2, second: 0, label: "Stopped", soundName: nil)
        repository.saveTimer(timer1)
        repository.saveTimer(timer2)

        repository.stopTimer(timer2)

        let running = repository.fetchRunningTimers()
        XCTAssertEqual(running.count, 1)
        XCTAssertEqual(running.first?.label, "Running")
    }

    /// 최근항목 생성, 실행할 타이머 생성
    /// 실행중인 타이머만 확인
    func test_fetchActiveTimers_shouldExcludeRecent() {
        let recent = repository.createRecentItem(hour: 0, minute: 0, second: 10)
        repository.saveTimer(recent)

        let timer = repository.createTimer(hour: 0, minute: 2, second: 0, label: nil, soundName: nil)
        repository.saveTimer(timer)

        let active = repository.fetchActiveTimers()
        XCTAssertEqual(active.count, 1)
        XCTAssertFalse(active.first?.isRecent ?? true)
    }

    /// 최근항목 생성
    /// 최근항목 타이머만 확인
    func test_createRecentItem_shouldAddToContext() {
        let recent = repository.createRecentItem(hour: 0, minute: 2, second: 5)
        repository.saveTimer(recent)

        let result = repository.fetchRecentItems()
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(result.first?.isRecent ?? false)
        XCTAssertFalse(result.first?.isRunning ?? true)
    }

    /// 실행할 타이머 생성 후
    /// 중복 여부 체크
    func test_hasRecentItem_shouldReturnTrueIfExists() {
        let timer = repository.createTimer(hour: 0, minute: 2, second: 5, label: "label", soundName: "soundName")
        repository.saveTimer(timer)

        let exists1 = repository.hasRecentItem(hour: 0, minute: 2, second: 5)
        XCTAssertFalse(exists1)
        
        let recent = repository.createRecentItem(hour: 0, minute: 2, second: 5)
        repository.saveTimer(recent)
        
        let exists2 = repository.hasRecentItem(hour: 0, minute: 2, second: 5)
        XCTAssertTrue(exists2)
    }
    
    func test_createRecentItem_shouldNotAddDuplicateIfExists() {
        if !repository.hasRecentItem(hour: 0, minute: 3, second: 0) {
            let first = repository.createTimer(hour: 0, minute: 3, second: 0, label: nil, soundName: nil)
            let second = repository.createRecentItem(hour: 0, minute: 3, second: 0)
            repository.saveTimer(first)
            repository.saveTimer(second)
        }
        
        let alreadyExists = repository.hasRecentItem(hour: 0, minute: 3, second: 0)
        XCTAssertTrue(alreadyExists)
        
        // 최근 항목 개수가 여전히 1개인지 확인
        let recents1 = repository.fetchRecentItems()
        XCTAssertEqual(recents1.filter { $0.hour == 0 && $0.minute == 3 && $0.second == 0 }.count, 1)
        // 실행 중인 타이머 개수도 여전히 1개인지 확인
        let recents2 = repository.fetchRunningTimers()
        XCTAssertEqual(recents2.filter { $0.hour == 0 && $0.minute == 3 && $0.second == 0 }.count, 1)
    }

    /// 최근 항목에 0시간 2분 5초 항목이 존재하며
    /// 해당 항목의 실행 버튼을 눌러 타이머를 추가할 경우
    func test_duplicateRecentItemAndStart_shouldCreateNewTimer() {
        let recent = repository.createRecentItem(hour: 0, minute: 2, second: 5)
        repository.saveTimer(recent)

        let duplicated = repository.duplicateRecentItemAndStart(recent)
        repository.saveTimer(duplicated)

        let all = repository.fetchActiveTimers() // 실행 중 or 일시정지 타이머만
        XCTAssertEqual(all.count, 1)
        XCTAssertTrue(all.contains(where: { $0.isRunning && !$0.isRecent }))
    }

    /// 타이머 생성 후 삭제 확인
    func test_deleteTimer_shouldRemoveFromContext() {
        let timer = repository.createTimer(hour: 0, minute: 1, second: 30, label: nil, soundName: nil)
        repository.saveTimer(timer)

        repository.deleteTimer(timer)

        let all = repository.fetchActiveTimers()
        XCTAssertTrue(all.isEmpty)
    }

    /// 타이머 생성 후 종료 시간 확인
    func test_createTimer_shouldSetCorrectEndTime() {
        let now = Date()
        let timer = repository.createTimer(hour: 0, minute: 1, second: 30, label: nil, soundName: nil)
        repository.saveTimer(timer)

        let expectedInterval = Double(timer.hour * 3600 + timer.minute * 60 + timer.second)
        guard let endTime = timer.endTime else {
            XCTFail("endTime is nil")
            return
        }
        let interval = endTime.timeIntervalSince(now)
        XCTAssert(abs(interval - expectedInterval) < 1.0)
    }
}
