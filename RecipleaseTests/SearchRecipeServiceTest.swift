//
//  SearchRecipeServiceTest.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 26/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import XCTest
@testable import Reciplease

class SearchRecipeServiceTest: XCTestCase {

    func testGivenIngredientsWhenSearchRecipeThenRecipesIsNotNil() {

        //Given
        let ingredients = ["kip","curry"]
        let e = XCTestExpectation(description: "Alamofire")
        SearchRecipeService.shared.SearchRecipe(with: ingredients, page: 0) { (succes, recipes, error) in
            XCTAssertTrue(succes)
            XCTAssertNotNil(recipes)
            XCTAssertNil(error)
            e.fulfill()
        }
        
        wait(for: [e], timeout: 5.0)
    }
    func testGivenBadIngredientsWhenSearchRecipeThenRecipesIsNilAndFail() {

        //Given
        let ingredients = ["Bad ingredient to fail test"]
        let e = XCTestExpectation(description: "Alamofire")
        SearchRecipeService.shared.SearchRecipe(with: ingredients, page: 0) { (succes, recipes, error) in
            XCTAssertFalse(succes)
            XCTAssertNil(recipes)
            XCTAssertNotNil(error, "Aucune recette")
            e.fulfill()
        }
        
        wait(for: [e], timeout: 5.0)
    }
    
    func testGiven0IngredientsWhenSearchRecipeThenRecipesIsNotNilAndNotFail() {
        //Given
        let ingredients = [""]
        let e = XCTestExpectation(description: "Alamofire")
        SearchRecipeService.shared.SearchRecipe(with: ingredients, page: 0) { (succes, recipes, error) in
            XCTAssertTrue(succes)
            XCTAssertNotNil(recipes)
            XCTAssertNil(error)
            e.fulfill()
        }
        
        wait(for: [e], timeout: 5.0)
    }

}
