//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    
    ///Api call
    private let yummlyService = YummlyService()
    ///All recipe get by api
    var recipes: [Recipe]!
    ///Use to pass list of ingredient to next controller
    var listOfIngredient: [String]!
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        yummlyService.page = 1
    }
    
    /// Get recipes from yummly api
    ///
    /// - Parameter ingredients: List of ingredients contained in the fridge
    func getRecipes(with ingredients: [String]) {
        yummlyService.getRecipe(with: ingredients) { (success, recipes, errorDescription) in
            if success, let searchResult = recipes {
                self.recipes.append(contentsOf: searchResult)
                self.tableView.reloadData()
            } else {
                guard let errorDescription = errorDescription else { return }
                AlertHelper().alert(self, title: "Error", message: errorDescription)
            }
        }
    }
    
    /// Get detail's recipe with api call
    ///
    /// - Parameter recipeToDetailId: recipe's id to detail
    private func getDetail(of recipeToDetailId: String) {
        // Get recipe's details
        yummlyService.getRecipeDetails(of: recipeToDetailId) { (success, recipeWithDetails, error) in
            if success, let recipeDetails = recipeWithDetails {
                self.performSegue(withIdentifier: "ShowRecipeDetails",
                                  sender: ["recipeDetail":recipeDetails, "listOfIngredient": self.listOfIngredient])
            } else {
                guard let errorDescription = error else { return }
                AlertHelper().alert(self, title: "Error", message: errorDescription)
            }
        }
    }
    
}

//MARK: - UITableview DataSource and Delegate

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipes.count > 0 {
            return recipes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        
        // Configure the cell
        cell.configure(with: recipes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeToDetails = recipes[indexPath.row]
        listOfIngredient = recipeToDetails.ingredients
        getDetail(of: recipeToDetails.id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipes.count - 1 {
            getRecipes(with: FridgeService.shared.ingredients)
        }
    }
}

// MARK: - Segue

extension RecipesViewController {
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

