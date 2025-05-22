//
//  CDTimer+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(Timer)
public class CDTimer: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let hour = "hour"
        static let minute = "minute"
        static let second = "second"
        static let label = "label"
        static let soundName = "soundName"
        static let createdAt = "createdAt"
        
        static let isRunning = "isRunning"
        static let endTime = "endTime"
        
        static let isRecent = "isRecent"
    }
}
