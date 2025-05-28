//
//  WorldClock+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(WorldClock)
public class WorldClock: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let cityName = "cityName"
        static let cityNameKR = "cityNameKR"
        static let timeZoneIdentifier = "timeZoneIdentifier"
        static let createdAt = "createdAt"
        static let orderIndex = "orderIndex"
        
        static let currentLocalTime = "currentLocalTime"
    }
}
