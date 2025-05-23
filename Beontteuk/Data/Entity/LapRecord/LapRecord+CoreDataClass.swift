//
//  LapRecord+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(LapRecord)
public class LapRecord: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let lapIndex = "lapIndex"
        static let lapTime = "lapTime"
        static let absoluteTime = "absoluteTime"
        static let recordedAt = "recordedAt"
        
        static let session = "session"
    }
}
