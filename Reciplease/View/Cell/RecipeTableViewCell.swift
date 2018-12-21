//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var timeToMakeRecipe: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    
    func configure(with recipe: Recipe) {
        if let time = recipe.timeToPrepareInSeconde {
            timeToMakeRecipe.text = String(time/60) + "min"
        } else {
            timeToMakeRecipe.text = "Unknow"
        }
        
        if let rating = recipe.rating {
            likeCount.text = String(rating) + "/5"
        } else {
            likeCount.text = "Unknow"
        }
        
        backgroundImage.image = recipe.bigImage ?? recipe.smallImage
        recipeName.text = recipe.name
        ingredients.text = recipe.ingredients.joined(separator: ",")
    }
    
}
