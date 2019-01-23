//
//  RecipeServiceTest.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 22/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import CoreData
import XCTest
@testable import Reciplease

class RecipeServiceTest: XCTestCase {
    
    // MARK: Properties
    var recipeService: RecipeService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack()
        recipeService = RecipeService(
            managedObjectContext: coreDataStack.mainContext,
            coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
        recipeService = nil
    }
    
    func testRootContextIsSavedAfterAddingRecipe() {
        
        //New background context to make request on the background
        let derivedContext = coreDataStack.newDerivedContext()
        
        //Instantiate new recipeService
        recipeService = RecipeService(managedObjectContext: derivedContext,
                                      coreDataStack: coreDataStack)
        
        //Create expectation notification when context did save
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) {
                notification in
                return true
        }
        
        derivedContext.perform {
            
             let recipe = Recipe(id: "1", name: "Poulet frite", ingredients: ["Poulet","Frites"], timeToPrepareInSeconde: 600, rating: 4, smallImage: nil, bigImage: UIImage(), sourceRecipeUrl: nil)
            
             _ = self.recipeService.saveRecipe(recipe)
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

}
