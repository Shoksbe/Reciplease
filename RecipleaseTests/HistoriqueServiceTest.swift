//
//  HistoriqueServiceTest.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 06/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import XCTest
@testable import Reciplease

class HistoriqueServiceTest: XCTestCase {

    //MARK: - Properties
    var historiqueService: HistoriqueService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        historiqueService = HistoriqueService(
            managedObjectContext: coreDataStack.mainContext,
            coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        historiqueService = nil
    }
    
    //MARK: - Add
    func testRootContextIsSavedAfterAddingIngredient() {
        
        //Background context
        let derivedContext = coreDataStack.newDerivedContext()
        
        //Instantiate new historiqueService
        historiqueService = HistoriqueService(managedObjectContext: derivedContext,
                                              coreDataStack: coreDataStack)
        
        //Create expectation notification when context did save
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) {
                notification in
                return true
        }
        
        //Save ingredient
        derivedContext.perform {
            self.historiqueService.saveIngredient("Kip")
        }
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    //MARK: - Get
    func testGiven0IngredientWhenGetIngredientThenCountEqual0() {
        //Given
        
        //When
        let ingredients = historiqueService.all
        
        //Then
        XCTAssertEqual(ingredients.count, 0)
    }
    
    func testGiven1IngredientWhenGetHistoriqueThenCountEqual1() {
        
        //Given
        historiqueService.saveIngredient("kip")
        
        //When
        let ingredient = historiqueService.all
        
        //Then
        XCTAssertEqual(ingredient.count, 1)
        
    }
    
    func testGiven1IngredienWhenCheckIfExistThenResultIsTrue() {

        //Given
        historiqueService.saveIngredient("Kip")
        
        //When
        let exist = historiqueService.checkExistenceOf(ingredientName: "Kip")
        
        //Then
        XCTAssertTrue(exist)
    }
    
    func testGiven10IngredienWhenCheckIfExistThenResultIsTrue() {
        
        //Given
        historiqueService.saveIngredient("Kip")
        
        //When
        let exist = historiqueService.checkExistenceOf(ingredientName: "Tomato")
        
        //Then
        XCTAssertFalse(exist)
    }
    
    //MARK: - Delete
    func testGiven2IngredientsWhenResetHistoriqueThenIsEmpty() {
        
        //Given
        historiqueService.saveIngredient("Kip")
        historiqueService.saveIngredient("Tomato")
        
        //When
        historiqueService.deleteHistorique()
        let historique = historiqueService.all
        
        //Then
        XCTAssertTrue(historique.isEmpty)
    }
    

}
