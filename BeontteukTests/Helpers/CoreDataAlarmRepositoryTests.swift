//
//  CoreDataAlarmRepositoryTests.swift
//  BeontteukTests
//
//  Created by 백래훈 on 5/22/25.
//

import CoreData

import XCTest
@testable import Beontteuk


final class CoreDataAlarmRepositoryTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var repository: CoreDataAlarmRepository!

    override func setUp() {
        super.setUp()
        container = CoreDataTestHelper.makeInMemoryContainer(modelName: "Beontteuk")
        repository = CoreDataAlarmRepository(context: container.viewContext)
    }

    func test_createAlarm_shouldAddToContext() {
        let alarm = repository.createAlarm(hour: 8, minute: 30, repeatDays: "0, 1, 2, 3", label: "테스트 알람", soundName: "bell")
        repository.saveAlarm(alarm)

        let result = repository.fetchAllAlarm()
        if let item = result.first {
            XCTAssertEqual(item.joinedRepeatDayNames, "일, 월, 화, 수")
            XCTAssertEqual(item.dateComponents, DateComponents(hour: 8, minute: 30))
        }
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.label, "테스트 알람")
    }

    func test_deleteAlarm_shouldRemoveFromContext() {
        let alarm = repository.createAlarm(hour: 7, minute: 0, repeatDays: nil, label: "삭제 알람", soundName: "bell")
        repository.saveAlarm(alarm)
        repository.deleteAlarm(alarm)

        let result = repository.fetchAllAlarm()
        XCTAssertEqual(result.count, 0)
    }

    func test_toggleAlarm_shouldChangeState() {
        let alarm = repository.createAlarm(hour: 6, minute: 0, repeatDays: nil, label: "테스트 알람", soundName: "bell")
        repository.saveAlarm(alarm)

        repository.deleteAlarm(alarm)
        
        let alarm2 = repository.createAlarm(hour: 6, minute: 0, repeatDays: nil, label: "테스트 알람", soundName: "bell")
        repository.saveAlarm(alarm2)

        if let updated = repository.fetchAllAlarm().first {
            XCTAssertEqual(updated.isEnabled, true)
        } else {
            print("알람이 존재하지 않음")
        }
    }
    
    func test_fetchAllAlarm() {
        let alarm = repository.createAlarm(hour: 6, minute: 0, repeatDays: nil, label: "테스트 알람", soundName: "bell")
        let alarm2 = repository.createAlarm(hour: 6, minute: 0, repeatDays: nil, label: "테스트 알람", soundName: "bell")
        repository.saveAlarm(alarm)
        repository.saveAlarm(alarm2)
        
        let alarms = repository.fetchAllAlarm()
        XCTAssertEqual(alarms.count, 2)
    }
}
