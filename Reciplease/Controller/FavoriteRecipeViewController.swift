//
//  FavoriteRecipeViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class FavoriteRecipeViewController: UIViewController {
    var favoriteRecipes: [RecipeSave]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var defaultMessage: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipes = RecipeSave.all
        
        /*
         If favorite list is not empty, the liste is showing but
         else a message appear to explain how to fill it.
        */
        if favoriteRecipes.count > 0 {
            tableView.reloadData()
            defaultMessage.isHidden = true
        } else {
            defaultMessage.isHidden = false
        }
    }
}

// MARK: UITableview datasource
extension FavoriteRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = favoriteRecipes?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create the cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        // Configure the cell
        
        let recipe = favoriteRecipes[indexPath.row]
        
        cell.backgroundImage.image = UIImage(data: recipe.image!)
        cell.recipeName.text = recipe.name
        cell.ingredients.text = recipe.ingredients
        cell.timeToMakeRecipe.text = recipe.timeInSecond
        cell.likeCount.text = recipe.likes

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeId = favoriteRecipes[indexPath.row].id
        performSegue(withIdentifier: "ShowRecipeDetails", sender: recipeId)
    }
}

// MARK: - Segue

extension FavoriteRecipeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowRecipeDetails" else { return }
        
        guard let destinationSegue = segue.destination as? ShowDetailsViewController else { return }
        
        guard let recipeId = sender as? String else { return }
        
        destinationSegue.recipeToDetailId = recipeId
        
    }
}
