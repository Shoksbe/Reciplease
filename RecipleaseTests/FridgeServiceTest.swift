//
//  FridgeServiceTest.swift
//  RecipleaseTests
//
//  Created by Gregory De knyf on 25/01/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import XCTest
@testable import Reciplease

class FridgeServiceTest: XCTestCase {
    
    func testGiven1IngredientWhenGetIngredientThenCountEqua1() {
        
        //Given
        FridgeService.shared.add(ingredient: "Poulet")
        
        //When
        let ingredients = FridgeService.shared.ingredients
        
        //Then
        XCTAssertEqual(ingredients.count, 1)
        
    }
    
    func testGiven3IngredientsWhenDeleteAllThenCountEqual0() {
        
        //Given
        FridgeService.shared.add(ingredient: "Poulet")
        FridgeService.shared.add(ingredient: "Compote")
        FridgeService.shared.add(ingredient: "Frite")
        
        //When
        FridgeService.shared.removeAll()
        let ingredients = FridgeService.shared.ingredients
        
        //Then
        XCTAssertEqual(ingredients.count, 0)
        
    }
}
