//
//  HistoriqueService.swift
//  Reciplease
//
//  Created by Gregory De knyf on 06/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import CoreData

class HistoriqueService {
    
    // MARK: Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    
    // MARK: Initializers
    init() {
        self.managedObjectContext = AppDelegate.coreDataStack.mainContext
        self.coreDataStack = AppDelegate.coreDataStack
    }
    
    init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
    
    /// Contains all recipe in database
    var all: [Historique] {
        let request: NSFetchRequest<Historique> = Historique.fetchRequest()
        guard let ingredients = try? managedObjectContext.fetch(request) else {return []}
        return ingredients
    }

    ///Save ingredient in database
    ///
    /// - Parameter ingredient: ingredient to save
    func saveIngredient(_ ingredient: String) {
        
        //Create context
        let historique = Historique(context: managedObjectContext)
        
        //Implemente context
        historique.ingredient = ingredient
        
        //Save context
        coreDataStack.saveContext(managedObjectContext)
    }
    
    /// Check if the ingredient exist in database
    ///
    /// - Parameter ingredient: ingredient's name
    /// - Returns: A boolean
    func checkExistenceOf(ingredientName: String)-> Bool {
        
        //Count of recipe with submentionned name
        var count = 0
        
        //Request
        let request: NSFetchRequest<Historique> = Historique.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "ingredient == %@", ingredientName)
        request.fetchLimit = 1
        
        do {
            count = try managedObjectContext.count(for: request)
        } catch let erreur {
            print(erreur)
        }
        print(count)
        return count > 0
    }
    
    ///Delete all ingredient in historique 
    func deleteHistorique() {
        //Delete recipe
        for ingredient in all {
            managedObjectContext.delete(ingredient)
        }
        
        coreDataStack.saveContext(managedObjectContext)
    }
    
}
