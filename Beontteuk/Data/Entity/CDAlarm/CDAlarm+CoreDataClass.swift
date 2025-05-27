//
//  CDAlarm+CoreDataClass.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//
//

import Foundation
import CoreData

@objc(CDAlarm)
public class CDAlarm: NSManagedObject {
    public enum Key {
        static let id = "id"
        static let hour = "hour"
        static let minute = "minute"
        static let repeatDays = "repeatDays"
        static let label = "label"
        static let isEnabled = "isEnabled"
        static let soundName = "soundName"
        static let isSnoozeEnabled = "isSnoozeEnabled"
        
        static let repeatDayIndexes = "repeatDayIndexes"
        static let repeatDayNames = "repeatDayNames"
        static let joinedRepeatDayNames = "joinedRepeatDayNames"
        static let dateComponents = "dateComponents"
    }
}
