//
//  WorldCityRepositoryInterface.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

import RxSwift

protocol WorldCityRepositoryProtocol {
    func fetchCityList() -> Single<[SelectCity]>
}
