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
    
    var all: [RecipeSave] {
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else {return []}
        return recipes
    }
    
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
    
    func checkExistenceOf(recipeName: String)-> Bool {
        
        //Count of recipe with submentionned name
        var count = 0
        
        //Request
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "name == %@", recipeName)
        request.fetchLimit = 1
        
        do {
            count = try managedObjectContext.count(for: request)
        } catch let erreur {
            print(erreur)
        }
        
        return count > 0
    }
    
    func delete(_ recipe: Recipe)-> Bool {
        
        //Request
        let request: NSFetchRequest<RecipeSave> = RecipeSave.fetchRequest()
        
        //Predicate
        request.predicate = NSPredicate(format: "id == %@", recipe.id)
        
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
