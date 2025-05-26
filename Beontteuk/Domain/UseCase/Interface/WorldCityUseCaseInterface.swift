//
//  WorldCityUseCaseInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxSwift

protocol WorldCityUseCaseProtocol {
    func fetchCityList() -> Single<[SelectCityEntity]>
}
