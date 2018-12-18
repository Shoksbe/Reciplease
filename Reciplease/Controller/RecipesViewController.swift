//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 17/12/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    var recipes: [Recipe]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipes(with: FridgeService.shared.ingredients)
    }
    
    
    /// Use the api to get recipes
    func getRecipes(with ingredients: [String]) {
        
        shownActivityController(true)
        
        SearchRecipeService.shared.SearchRecipe(with: ingredients) {
            (success, recipes, errorDescription) in
            if success, let searchResult = recipes {
                self.recipes = searchResult
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
        guard let number = recipes?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create the cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        
        // Configure the cell
        
        let recipe = recipes[indexPath.row]
        
        cell.backgroundImage.image = recipe.smallImage
        cell.recipeName.text = recipe.name
        cell.ingredients.text = recipe.ingredients.joined(separator: ",")
        
        if let time = recipe.timeToPrepareInSeconde {
            cell.timeToMakeRecipe.text = String(time/60) + "min"
        } else {
            cell.timeToMakeRecipe.text = "Unknow"
        }
        
        if let rating = recipe.rating {
            cell.likeCount.text = String(rating) + "/5"
        } else {
            cell.likeCount.text = "Unknow"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeToDetails = recipes[indexPath.row]
        performSegue(withIdentifier: "ShowRecipeDetails", sender: recipeToDetails)
    }
}


// MARK: - UICollectionViewFlowLayout

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = collectionView.frame.width
        return CGSize(width: (collectionView.bounds.size.width / 2) - 15, height: CGFloat(kWhateverHeightYouWant))
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

