//
//  StopWatchSession+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(StopWatchSession)
public class StopWatchSession: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let startTime = "startTime"
        static let isRunning = "isRunning"
        static let elapsedBeforePause = "elapsedBeforePause"
        static let createdAt = "createdAt"
        
        static let laps = "laps"
        
        static let totalElapsed = "totalElapsed"
    }
}
