//
//  Recipe.swift
//  Reciplease
//
//  Created by Gregory De knyf on 11/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {
    let id: String
    let recipeName: String
    let ingredients: [String]
    let totalTimeInSeconds: Int
    let rating: Int
    let image: UIImage
}
