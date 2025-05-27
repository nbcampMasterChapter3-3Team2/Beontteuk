//
//  WorldCityUseCase.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxSwift

final class WorldCityUseCase: WorldCityUseCaseProtocol {
    
    private let repository: WorldCityRepositoryProtocol

    init(repository: WorldCityRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchCityList() -> Single<[SelectCityEntity]> {
        return repository.fetchCityList().map { $0.map { $0.toEntity() } }
    }
}
