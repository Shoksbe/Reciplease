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
    
    static func saveRecipe(_ recipeToSave: RecipeWithDetails)-> Bool {
        
        //Check data
        var likes: String?
        var timeInSecond: String?
        
        if let rating = recipeToSave.rating {
            likes = String(rating)
        }
        
        if let time = recipeToSave.totalTimeInSeconds {
            timeInSecond = String(time)
        }
        
        //Create context
        let recipeSave = RecipeSave(context: AppDelegate.viewContext)
        
        //Implemente context
        recipeSave.id = recipeToSave.id
        recipeSave.ingredients = recipeToSave.ingredientLines.joined(separator: ",")
        recipeSave.likes = likes
        recipeSave.name = recipeToSave.name
        recipeSave.timeInSecond = timeInSecond
        recipeSave.imageUrl = recipeToSave.largeImageUrl
        
        //Try to save data
        do {
            try AppDelegate.viewContext.save()
            return true
        } catch let erreur {
            print(erreur.localizedDescription)
        }
        
        return false
    }
    
    static func checkExistenceOf(recipeName: String)-> Bool {
        
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
