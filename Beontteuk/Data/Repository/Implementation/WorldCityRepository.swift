//
//  WorldCityRepository.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxSwift

final class WorldCityRepository: WorldCityRepositoryProtocol {
    //MARK: Methods
    func fetchCityList() -> Single<[SelectCity]> {
        return Single.create { single in
            guard let url = Bundle.main.url(forResource: "WorldCity", withExtension: "json") else {
                single(.failure(NSError(domain: "파일 없음", code: 0)))
                return Disposables.create()
            }
            
            do {
                let data = try Data(contentsOf: url)
                let cities = try JSONDecoder().decode([SelectCity].self, from: data)
                single(.success(cities))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}
