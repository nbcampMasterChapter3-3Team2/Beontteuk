//
//  CoreDataTestHelper.swift
//  BeontteukTests
//
//  Created by 백래훈 on 5/22/25.
//

import Foundation
import CoreData

final class CoreDataTestHelper {
    static func makeInMemoryContainer(modelName: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: modelName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ CoreData 테스트용 컨테이너 로딩 실패: \(error)")
            }
        }
        return container
    }
}
