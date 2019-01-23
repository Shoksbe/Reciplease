//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 22/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import CoreData
@testable import Reciplease

class TestCoreDataStack: CoreDataStack {
    
    convenience init() {
        self.init(modelName: "Reciplease")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.storeContainer = container
    }
}
