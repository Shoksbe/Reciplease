//
//  FavoriteRecipeViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class FavoriteRecipeViewController: UIViewController {

    //MARK: - Variables
    /// Recipes that are saved in coreData
    private var favoriteRecipes: [RecipeSave]!
    /// Service used for CRUD
    private var recipeService = RecipeService()
    ///Api call
    private  let yummlyService = YummlyService()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipes = recipeService.all
        tableView.reloadData()
    }
    
    
    /// Get detail's recipe with api call
    ///
    /// - Parameter recipeToDetailId: recipe's id to detail
    private func getDetail(of recipeToDetailId: String) {
        // Get recipe's details
        yummlyService.getRecipeDetails(of: recipeToDetailId) { (success, recipeWithDetails, error) in
            if success, let recipeDetails = recipeWithDetails {
                self.performSegue(withIdentifier: "ShowRecipeDetails", sender: ["recipeDetail":recipeDetails, "listOfIngredient": recipeDetails.ingredients])
            } else {
                guard let errorDescription = error else { return }
                AlertHelper().alert(self, title: "Error", message: errorDescription)
            }
        }
    }
}

// MARK: - UITableview datasource
extension FavoriteRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = favoriteRecipes?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        
        // Configure the cell
        cell.configure(with: favoriteRecipes[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipeId = favoriteRecipes[indexPath.row].id else { return }
        getDetail(of: recipeId)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Your favorites list is empty, to fill it go to the search tab and add ingredients. Then you can add recipes to your favorites."
        label.textAlignment = .center
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return favoriteRecipes.isEmpty ? 200 : 0
    }
}

// MARK: - Segue

extension FavoriteRecipeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "ShowRecipeDetails" else { return }
        
        guard let destinationSegue = segue.destination as? ShowDetailsViewController else { return }
        
        guard let data = sender as? [String:Any] else { return }
        
        guard let recipe = data["recipeDetail"] as? Recipe else { return }
        
        guard let listOfIngredient = data["listOfIngredient"] as? [String] else { return }
        
        destinationSegue.recipeWithDetails = recipe
        
        destinationSegue.listOfIngredient = listOfIngredient
        
    }
}
