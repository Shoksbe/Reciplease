//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    var page: Int = 0
    var recipes = [Recipe]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shownActivityController(true)
        getRecipes(with: FridgeService.shared.ingredients)
    }
    
    
    /// Use the api to get recipes
    private func getRecipes(with ingredients: [String]) {
        
        SearchRecipeService.shared.SearchRecipe(with: ingredients, page: page) {
            (success, recipes, errorDescription) in
            if success, let searchResult = recipes {
                self.page += 1
                self.recipes.append(contentsOf: searchResult)
                self.tableView.reloadData()
                self.shownActivityController(false)
            } else {
                guard let errorDescription = errorDescription else { return }
                self.showAlertError(message: errorDescription)
            }
        }
    }
    
    private func shownActivityController(_ show: Bool) {
        if show {
            activityIndicator.isHidden = false
            tableView.isHidden = true
        } else {
            activityIndicator.isHidden = true
            tableView.isHidden = false
        }
    }
    
    ///Displays errors
    @objc private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: UITableview Datasource and Delegate

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
        performSegue(withIdentifier: "ShowRecipeDetails", sender: recipeToDetails)
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
        
        guard let recipe = sender as? Recipe else { return }
        
        destinationSegue.recipeToDetailId = recipe.id
        
    }
}

