//
//  RecipeService.swift
//  Reciplease
//
//  Created by Gregory De knyf on 22/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import CoreData

class RecipeService {
    
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
    var all: [RecipeSave] {
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else {return []}
        return recipes
    }
    
    
    /// Save recipe in database
    ///
    /// - Parameter recipeToSave: recipe to save
    func saveRecipe(_ recipeToSave: Recipe) {
        
        //Check data
        var likes: String?
        var timeInMinute: String?
        
        if let rating = recipeToSave.rating {
            likes = String(rating)
        }
        
        if let time = recipeToSave.timeToPrepareInSeconde {
            timeInMinute = String(time/60)
        }
        
        //Create context
        let recipeSave = RecipeSave(context: managedObjectContext)
        
        //Implemente context
        recipeSave.id = recipeToSave.id
        recipeSave.ingredients = recipeToSave.ingredients.joined(separator: ",")
        recipeSave.likes = likes
        recipeSave.name = recipeToSave.name
        recipeSave.timeInMinute = timeInMinute
        recipeSave.image = recipeToSave.bigImage!.pngData()
        
        coreDataStack.saveContext(managedObjectContext)
    }
    
    
    
    /// Check if the recipe exist in database
    ///
    /// - Parameter recipeId: recipe's id
    /// - Returns: A boolean
    func checkExistenceOf(recipeId: String)-> Bool {
        
        //Count of recipe with submentionned name
        var count = 0
        
        //Request
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "id == %@", recipeId)
        request.fetchLimit = 1
        
        do {
            count = try managedObjectContext.count(for: request)
        } catch let erreur {
            print(erreur)
        }
        
        return count > 0
    }
    
    
    /// Delete recipe in database
    ///
    /// - Parameter recipeId: Recipe'id to delete
    /// - Returns: A boolean to say if deleting is working
    func delete(_ recipeId: String)-> Bool {
        
        //Request
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "id == %@", recipeId)
        
        //Fetch request
        guard let recipe = try? managedObjectContext.fetch(request), recipe.count > 0 else {
            print("Error when delete recipe.")
            return false
        }
        
        //Delete recipe
        managedObjectContext.delete(recipe[0])
        
        coreDataStack.saveContext(managedObjectContext)
        
        return true
    }
}
