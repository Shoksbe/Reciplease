//
//  Recipe.swift
//  Reciplease
//
//  Created by Gregory De knyf on 18/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation
import UIKit

struct Recipe {
    let id: String
    let name: String
    let ingredients: [String]
    let timeToPrepareInSeconde: Int?
    let rating: Int?
    let smallImage: UIImage?
    let bigImage: UIImage?
    let sourceRecipeUrl: String?
}
