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
    
    //MARK: - Helpers
    
    private let recipeSample1 = Recipe(id: "1",
                                       name: "Poulet frite",
                                       ingredients: ["Poulet","Frites"],
                                       timeToPrepareInSeconde: 600,
                                       rating: 4,
                                       smallImage: nil,
                                       bigImage: UIImage(),
                                       sourceRecipeUrl: nil)
    
    private let recipeSample2 = Recipe(id: "2",
                                       name: "Boudin compote",
                                       ingredients: ["Boudin","Compote"],
                                       timeToPrepareInSeconde: 300,
                                       rating: 3,
                                       smallImage: nil,
                                       bigImage: UIImage(),
                                       sourceRecipeUrl: "Fake url")
    
    //MARK: - Add
    
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
        
        //Save recipe
        derivedContext.perform {
            self.recipeService.saveRecipe(self.recipeSample1)
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    
    //MARK: - Get
    
    func testGiven0RecipeWhenGetRecipeThenCountEqual0() {
        
        //Given
        
        //When
        let recipes = recipeService.all
        
        //Then
        XCTAssertEqual(recipes.count, 0)
        
    }
    
    func testGiven1RecipeWhenGetRecipeThenCountEqual1() {
        
        //Given
        self.recipeService.saveRecipe(recipeSample1)
        
        //When
        let recipes = recipeService.all
        
        //Then
        XCTAssertEqual(recipes.count, 1)
        
    }
    
    func testGiven2RecipesAnd1IdWhenChackIfRecipeExistThenResultIsTrue() {
        
        //Given
        recipeService.saveRecipe(recipeSample1)
        recipeService.saveRecipe(recipeSample2)
        
        let recipeId = "1"
        
        //When
        let recipeExist = recipeService.checkExistenceOf(recipeId: recipeId)
        
        //Then
        XCTAssertTrue(recipeExist)
        
    }
    
    func testGiven2RecipesAnd1BadIdWhenChackIfRecipeExistThenResultIsFalse() {
        
        //Given
        recipeService.saveRecipe(recipeSample1)
        recipeService.saveRecipe(recipeSample2)
        
        let badRecipeId = "Bad id"
        
        //When
        let recipeExist = recipeService.checkExistenceOf(recipeId: badRecipeId)
        
        //Then
        XCTAssertFalse(recipeExist)
        
    }
    
    //MARK: - Delete
    
    func testGiven2RecipesWhenDelete1RecipeThenCountEqual1() {
        
        //Given
        recipeService.saveRecipe(recipeSample1)
        recipeService.saveRecipe(recipeSample2)
        
        //When
        _ = recipeService.delete(recipeSample1.id)
        let recipes = recipeService.all
        
        //Then
        XCTAssertEqual(recipes.count, 1)
    }
    
    func testGiven0RecipeWhenDeleteRecipeThenIsNotWorking() {
        
        //Given
        
        //When
        let deleteIsWorking = recipeService.delete(recipeSample1.id)
        
        //Then
        XCTAssertFalse(deleteIsWorking)
        
    }
    
    


}
