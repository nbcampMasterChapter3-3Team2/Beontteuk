//
//  CoreDataStack.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/21/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Beontteuk")
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("❌ CoreData 로딩 실패: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
