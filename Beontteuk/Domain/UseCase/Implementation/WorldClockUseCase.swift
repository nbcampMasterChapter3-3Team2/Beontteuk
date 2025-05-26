//
//  WorldClockUseCase.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

final class WorldClockUseCase: WorldClockUseCaseInterface {
    
    private let repository: WorldClockRepositoryInterface
    
    init(repository: WorldClockRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchAll() -> [WorldClockEntity] {
        return repository.fetchAll().map { $0.toEntity() }
    }
    
    func fetchWorldClock(by id: UUID) -> WorldClockEntity? {
        return repository.fetchWorldClock(by: id)?.toEntity()
    }
    
    func fetchTimeZone(by timeZoneIdentifier: String) -> WorldClockEntity? {
        return repository.fetchTimeZone(by: timeZoneIdentifier)?.toEntity()
    }
    
    func exists(timeZoneIdentifier: String) -> Bool {
        return repository.exists(timeZoneIdentifier: timeZoneIdentifier)
    }
    
    func createCity(cityName: String, cityNameKR: String, timeZoneIdentifier: String) -> WorldClockEntity {
        return repository.createCity(cityName: cityName, cityNameKR: cityNameKR, timeZoneIdentifier: timeZoneIdentifier).toEntity()
    }
    
    func deleteCity(_ city: WorldClockEntity) {
        guard let id = city.id,
              let worldClock = repository.fetchWorldClock(by: id) else { return }
        repository.deleteCity(worldClock)
    }
    
    func saveCity(_ city: WorldClockEntity) {
        guard let id = city.id,
              let worldClock = repository.fetchWorldClock(by: id) else { return }
        repository.saveCity(worldClock)
    }
    
    func updateOrder(for clock: WorldClockEntity, to newIndex: Int16) {
        guard let id = clock.id,
              let worldClock = repository.fetchWorldClock(by: id) else { return }
        repository.updateOrder(for: worldClock, to: newIndex)
    }
    
    func reorder(citys: [WorldClockEntity]) {
        let clocks: [WorldClock] = citys.compactMap { entity in
            guard let id = entity.id else { return nil }
            return repository.fetchWorldClock(by: id)
        }
        repository.reorder(citys: clocks)
    }
}
