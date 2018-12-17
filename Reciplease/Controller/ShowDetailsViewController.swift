//
//  ShowDetailsViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 22/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // Variables: - UICollectionViewFlowLayout
    var recipeToDetail: Recipe!
    var recipeWithDetails: RecipeWithDetails!

    // MARK: - Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var favoriteIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get recipe's details
        GetRecipeDetailsService.shared.getRecipeDetails(of: recipeToDetail) { (success, recipeWithDetails, error) in
            if success, let recipeDetails = recipeWithDetails {

                self.recipeWithDetails = recipeDetails
                
                // TODO: Create only one imageUrl in getRecipeService
                guard let url = URL(string: recipeDetails.largeImageUrl!) else { return }
                guard let data = try? Data(contentsOf: url) else { return }

                self.recipeName.text = recipeDetails.name
                self.recipeImage.image = UIImage(data: data)

                self.tableview.reloadData()
            }
        }
    }

    @IBAction func didTapRecipe(_ sender: UIButton) {
        //Check existence of url's recipe
        guard let url = URL(string: recipeWithDetails.sourceRecipeUrl) else {
            showAlertError(message: "Can not find the destination url")
            return
        }
        //Launch url's recipe
        UIApplication.shared.open(url)
    }

    @IBAction func didTapFavoriteIcon(_ sender: UIButton) {
        
        if recipeAlreadySaved() {
            // TODO: Unsave recipe
            
            //Desactivate favorite icon
            favoriteIcon.setImage(UIImage(named: "Favorite Desactivate"), for: .normal)
        } else {
            //Save recipe
            saveRecipe()
            
            //Activate favorite icon
            favoriteIcon.setImage(UIImage(named: "Favorite Activate"), for: .normal)
        }
    }
    
    private func saveRecipe() {
        if !RecipeSave.saveRecipe(recipeWithDetails) {
            showAlertError(message: "Save failed !")
        }
    }
    
    private func recipeAlreadySaved() -> Bool {
        return RecipeSave.checkExistenceOf(recipeName: recipeWithDetails.name)
    }
    
    ///Displays errors
    @objc private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - Tableview datasource
extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = recipeWithDetails?.ingredientLines.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Create cell
        let cell = tableview.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell

        //Implemente cell
        cell.ingredientName.text = recipeWithDetails.ingredientLines[indexPath.row]

        return cell
    }
}

