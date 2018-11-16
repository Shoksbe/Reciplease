//
//  RecipeCollectionViewCell.swift
//  Reciplease
//
//  Created by Gregory De knyf on 15/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var timeToMakeRecipe: UILabel!
    @IBOutlet weak var ingredients: UILabel!
}
