//
//  WorldCity.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import Foundation

// selectVC
struct SelectCity: Decodable {
    let cityName: String
    let cityNameKR: String
    let timeZoneIdentifier: String
    let country: String
    
    func toEntity() -> SelectCityEntity {
        return SelectCityEntity(
            cityName: cityName,
            cityNameKR: cityNameKR,
            timeZoneIdentifier: timeZoneIdentifier,
            country: country
        )
    }
}

struct SelectCityEntity: Decodable {
    let cityName: String
    let cityNameKR: String
    let timeZoneIdentifier: String
    let country: String
}
