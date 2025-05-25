//
//  CDTimer+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(CDTimer)
public class CDTimer: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let remainSecond = "remainSecond"
        static let totalSecond = "totalSecond"
        static let label = "label"
        static let soundName = "soundName"
        static let createdAt = "createdAt"
        
        static let isRunning = "isRunning"
        static let endTime = "endTime"
        
        static let isRecent = "isRecent"
    }
}
