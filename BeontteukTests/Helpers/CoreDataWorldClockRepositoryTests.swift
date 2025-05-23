//
//  CoreDataWorldClockRepositoryTests.swift
//  BeontteukTests
//
//  Created by 백래훈 on 5/22/25.
//

import CoreData

import XCTest
@testable import Beontteuk

final class CoreDataWorldClockRepositoryTests: XCTestCase {
    
    var container: NSPersistentContainer!
    var repository: WorldClockRepositoryInterface!

    override func setUp() {
        super.setUp()
        container = CoreDataTestHelper.makeInMemoryContainer(modelName: "Beontteuk")
        repository = CoreDataWorldClockRepository(context: container.viewContext)
    }
    
    /// 도시 추가 및 속성 값 확인
    func test_createCity_shouldAddWorldClockToContext() {
        let city = repository.createCity(cityName: "Seoul", timeZoneIdentifier: "Asia/Seoul")
        repository.saveCity(city)
        let clocks = repository.fetchAll()
        
        XCTAssertEqual(clocks.count, 1)
        XCTAssertEqual(clocks.first?.cityName, "Seoul")
        XCTAssertEqual(clocks.first?.timeZoneIdentifier, "Asia/Seoul")
    }

    /// 도시 추가 및 도시명 mapping
    func test_fetchAll_shouldReturnSortedByCityName() {
        let city1 = repository.createCity(cityName: "London", timeZoneIdentifier: "Europe/London")
        let city2 = repository.createCity(cityName: "New York", timeZoneIdentifier: "America/New_York")
        let city3 = repository.createCity(cityName: "Tokyo", timeZoneIdentifier: "Asia/Tokyo")
        repository.saveCity(city1)
        repository.saveCity(city2)
        repository.saveCity(city3)

        let clocks = repository.fetchAll()
        let names = clocks.map { $0.cityName }
        XCTAssertEqual(names, ["London", "New York", "Tokyo"])
    }
    
    /// 도시 추가 및 orderIndex 순 정렬
    func test_fetchAll_shouldReturnSortedByOrderIndex() {
        let city1 = repository.createCity(cityName: "London", timeZoneIdentifier: "Europe/London")
        let city2 = repository.createCity(cityName: "New York", timeZoneIdentifier: "America/New_York")
        let city3 = repository.createCity(cityName: "Tokyo", timeZoneIdentifier: "Asia/Tokyo")
        repository.saveCity(city1)
        repository.saveCity(city2)
        repository.saveCity(city3)

        let clocks = repository.fetchAll()
        let names = clocks.sorted { $0.orderIndex > $1.orderIndex }.map { $0.orderIndex }
        XCTAssertEqual(names, [3, 2, 1])
    }

    /// 도시 추가 및 단일 확인
    func test_fetchByTimeZoneIdentifier_shouldReturnCorrectClock() {
        let city = repository.createCity(cityName: "Sydney", timeZoneIdentifier: "Australia/Sydney")
        repository.saveCity(city)
        
        let result = repository.fetch(by: "Australia/Sydney")
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.cityName, "Sydney")
    }

    /// 도시 추가 및 중복 확인
    func test_exists_shouldReturnTrueIfCityExists() {
        let city = repository.createCity(cityName: "Paris", timeZoneIdentifier: "Europe/Paris")
        repository.saveCity(city)
        
        let exists = repository.exists(timeZoneIdentifier: "Europe/Paris")
        
        XCTAssertTrue(exists)
    }

    /// 중복 확인
    func test_exists_shouldReturnFalseIfCityDoesNotExist() {
        let exists = repository.exists(timeZoneIdentifier: "Europe/Rome")
        XCTAssertFalse(exists)
    }

    /// 도시 추가 및 삭제 후 중복 확인
    func test_deleteCity_shouldRemoveCityFromContext() {
        let city1 = repository.createCity(cityName: "Beijing", timeZoneIdentifier: "Asia/Shanghai")
        repository.saveCity(city1)
        
        let city2 = repository.fetch(by: "Asia/Shanghai")!
        repository.deleteCity(clock: city2)
        
        let exists = repository.exists(timeZoneIdentifier: "Asia/Shanghai")
        XCTAssertFalse(exists)
    }

    /// 도시 추가 및 orderIndex 값 변경 확인
    func test_updateOrder_shouldChangeOrderIndex() {
        let city1 = repository.createCity(cityName: "Berlin", timeZoneIdentifier: "Europe/Berlin")
        repository.saveCity(city1)
        let city2 = repository.fetch(by: "Europe/Berlin")!
        repository.updateOrder(for: city2, to: 5)
        
        let updated = repository.fetch(by: "Europe/Berlin")
        XCTAssertEqual(updated?.orderIndex, 5)
    }

    /// 도시 추가 및 orderIndex reorder 확인
    func test_reorder_shouldResetOrderIndexBasedOnGivenList() {
        let city1 = repository.createCity(cityName: "Moscow", timeZoneIdentifier: "Europe/Moscow")
        let city2 = repository.createCity(cityName: "Dubai", timeZoneIdentifier: "Asia/Dubai")
        let city3 = repository.createCity(cityName: "Delhi", timeZoneIdentifier: "Asia/Kolkata")
        repository.saveCity(city1)
        repository.saveCity(city2)
        repository.saveCity(city3)

        var clocks = repository.fetchAll()
        clocks.reverse()
        repository.reorder(clocks: clocks)

        let reordered = repository.fetchAll()
        XCTAssertEqual(reordered[0].cityName, "Delhi")
        XCTAssertEqual(reordered[0].orderIndex, 0)
        XCTAssertEqual(reordered[1].cityName, "Dubai")
        XCTAssertEqual(reordered[1].orderIndex, 1)
        XCTAssertEqual(reordered[2].cityName, "Moscow")
        XCTAssertEqual(reordered[2].orderIndex, 2)
    }
}
