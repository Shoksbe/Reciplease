//
//  RecipeWithDetails.swift
//  Reciplease
//
//  Created by De knyf Gregory on 01/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation

struct RecipeWithDetails {
    let smallImageUrl: String?
    let mediumImageUrl: String?
    let largeImageUrl: String?
    let name: String
    let id: String
    let ingredientLines: [String]
    let totalTimeInSeconds: Int?
    let rating: Int?
    let sourceRecipeUrl: String
}
