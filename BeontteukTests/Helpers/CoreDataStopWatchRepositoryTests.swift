//
//  CoreDataStopWatchRepositoryTests.swift
//  BeontteukTests
//
//  Created by 백래훈 on 5/22/25.
//

import CoreData

import XCTest
@testable import Beontteuk

final class CoreDataStopWatchRepositoryTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var sessionRepository: StopWatchSessionRepositoryInterface!
    var lapRecordRepository: LapRecordRepositoryInterface!

    override func setUp() {
        super.setUp()
        container = CoreDataTestHelper.makeInMemoryContainer(modelName: "Beontteuk")
        sessionRepository = CoreDataStopWatchRepository(context: container.viewContext)
        lapRecordRepository = CoreDataLapRecordRepository(context: container.viewContext)
    }
    
    /// 스톱워치 전체 리스트 확인
    func test_fetchLastSession_shouldReturnNilWhenNoSession() {
        let result = sessionRepository.fetchLastSession()
        XCTAssertNil(result)
    }
    
    /// 세션 생성 후 속성 값 확인
    func test_createSession_shouldAddToContext() {
        let session = sessionRepository.createSession()
        sessionRepository.saveSession(session)

        let result = sessionRepository.fetchLastSession()
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.isRunning, true)
    }

    /// 세션 생성 후 삭제 확인
    func test_deleteSession_shouldRemoveFromContext() {
        let session = sessionRepository.createSession()
        sessionRepository.saveSession(session)
        sessionRepository.deleteSession(session)

        let result = sessionRepository.fetchLastSession()
        XCTAssertNil(result)
    }

    /// 세션 생성 후 속성 값 확인
    func test_createSession_shouldSetInitialValuesCorrectly() {
        let session = sessionRepository.createSession()
        XCTAssertNotNil(session.id)
        XCTAssertNotNil(session.startTime)
        XCTAssertNotNil(session.createdAt)
        XCTAssertEqual(session.elapsedBeforePause, 0)
        XCTAssertEqual(session.isRunning, true)
    }
}

// MARK: - LapRecordRepository Tests
extension CoreDataStopWatchRepositoryTests {
    /// 세션 및 랩 생성 후 랩 -> 세션 등록
    /// 랩 확인
    func test_createLap_shouldAddLapToSession() {
        let session = sessionRepository.createSession()
        sessionRepository.saveSession(session)

        let lap = lapRecordRepository.createLap(for: session, lapIndex: 1, lapTime: 10.5, absoluteTime: 10.5)
        lapRecordRepository.saveLap(lap)

        let fetchedLaps = lapRecordRepository.fetchLaps(for: session)
        XCTAssertEqual(fetchedLaps.count, 1)
        XCTAssertEqual(fetchedLaps.first?.lapIndex, 1)
        XCTAssertEqual(fetchedLaps.first?.lapTime, 10.5)
    }

    /// 세션 및 랩 생성 후 -> 랩 삭제
    /// 전체 랩 확인
    /// 세션 내 랩 확인
    /// 세션 삭제 확인
    func test_deleteLap_shouldRemoveFromSession() {
        let session = sessionRepository.createSession()
        sessionRepository.saveSession(session)

        let lap = lapRecordRepository.createLap(for: session, lapIndex: 1, lapTime: 12.3, absoluteTime: 12.3)
        lapRecordRepository.saveLap(lap)

        lapRecordRepository.deleteLap(lap)

        let result = lapRecordRepository.fetchLaps(for: session)
        XCTAssertEqual(result.count, 0)
        
        let laps = session.laps
        XCTAssertEqual(laps?.count, 0)
        
        sessionRepository.deleteSession(session)
        
        XCTAssertNil(session.laps)
    }

    /// 세션 및 랩 3개 생성 -> 세션에 모두 등록
    /// 랩 전체 삭제 (for: session)
    /// 세션 내 랩 확인
    func test_deleteAllLaps_shouldRemoveAllLapsFromSession() {
        let session = sessionRepository.createSession()
        sessionRepository.saveSession(session)

        for i in 0..<3 {
            let lap = lapRecordRepository.createLap(for: session, lapIndex: i, lapTime: Double(i) * 10, absoluteTime: Double(i) * 10)
            lapRecordRepository.saveLap(lap)
        }
        
        let result = lapRecordRepository.fetchLaps(for: session)
        XCTAssertEqual(result.count, 3)

        lapRecordRepository.deleteAllLaps(for: session)

        let laps = session.laps
        XCTAssertEqual(laps?.count, 0)
    }
}
