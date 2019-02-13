//
//  GetRecipeServiceTest.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 26/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import XCTest
@testable import Reciplease

class GetRecipeServiceTest: XCTestCase {
    
    func testGivenIdRecipeWhenGetRecipeThenARecipeIsGivenAndExist() {
        
        let recipeId = "Vegetarian-Cabbage-Soup-Recipezaar"
        let expectation = XCTestExpectation(description: "Alamofire")
        GetRecipeDetailsService.shared.getRecipeDetails(of: recipeId) { (succes, recipe, error) in
            XCTAssertTrue(succes)
            XCTAssertNotNil(recipe)
            XCTAssertNil(error)
            XCTAssertEqual(recipe?.id, recipeId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGivenBadIdRecipeWhenGetRecipeThenARecipeIsGivenAndExist() {
        
        let recipeId = "Bad id"
        let expectation = XCTestExpectation(description: "Alamofire")
        GetRecipeDetailsService.shared.getRecipeDetails(of: recipeId) { (succes, recipe, error) in
            XCTAssertFalse(succes)
            XCTAssertNil(recipe)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }


}
