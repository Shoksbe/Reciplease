//
//  Fridge.swift
//  Reciplease
//
//  Created by Gregory De knyf on 07/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation

class FridgeService {
    
    static let shared = FridgeService()
    private init() {}
    
    /// Ingrédients present in fridge
    private(set) var ingredients: [String] = []
    
    
    /// Add an ingredient in list of fridge's ingredients
    ///
    /// - Parameter ingredient: Ingredient to add
    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    
    
    /// Delete the list of ingrédients completely
    func removeAll() {
        ingredients.removeAll()
    }
    
    /// Remove a spécific ingredient in the list
    ///
    /// - Parameter pos: Ingredient's position in the list
    func removeAt(pos: Int) {
        ingredients.remove(at: pos)
    }
}
