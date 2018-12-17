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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
                self.collectionView.reloadData()
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
            collectionView.isHidden = true
        } else {
            activityIndicator.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    ///Displays errors
    @objc private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: UICollectionViewDataSource

extension RecipesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = recipes?.count else { return 0 }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Create the cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCollectionViewCell
        
        // Configure the cell
        
        let recipe = recipes[indexPath.row]
        
        cell.image.image = recipe.image
        cell.recipeName.text = recipe.recipeName
        cell.ingredients.text = recipe.ingredients.joined(separator: ",")
        cell.timeToMakeRecipe.text = String(recipe.totalTimeInSeconds)
        cell.likeCount.text = String(recipe.rating)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

