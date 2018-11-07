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
    
    private(set) var ingredients: [String] = []
    
    func add(ingredient: String) {
        ingredients.append(ingredient)
    }
    
    func removeAll() {
        ingredients.removeAll()
    }
}
