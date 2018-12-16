//
//  RecipeSave.swift
//  Reciplease
//
//  Created by Gregory De knyf on 16/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation
import CoreData

class RecipeSave: NSManagedObject {
    
    static func CheckExistenceOf(recipeName: String)-> Bool {
        
        //Count of recipe with submentionned name
        var count = 0
        
        //Request
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "name == %@", recipeName)
        request.fetchLimit = 1
        
        do {
            count = try AppDelegate.viewContext.count(for: request)
        } catch let erreur {
            print(erreur)
        }
        
        return count > 0
    }
}
