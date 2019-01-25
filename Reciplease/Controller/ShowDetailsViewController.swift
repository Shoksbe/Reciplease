//
//  ShowDetailsViewController.swift
//  Reciplease
//
//  Created by Gregory De knyf on 22/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {

    // MARK: - Variables
    var recipeToDetailId: String!
    private var recipeWithDetails: Recipe!
    private var recipeService = RecipeService()

    // MARK: - Outlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var favoriteIcon: UIButton!
    @IBOutlet weak var activityIndicator: UIView!
    
    //MARK: - IBAction
    @IBAction func didTapRecipe(_ sender: UIButton) {
        
        //Check existence of url's recipe
        guard let sourceUrl = recipeWithDetails.sourceRecipeUrl, let url = URL(string: sourceUrl) else {
            showAlertError(message: "Can not find the destination url")
            return
        }
        
        //Launch url's recipe
        UIApplication.shared.open(url)
    }

    @IBAction func didTapFavoriteIcon(_ sender: UIButton) {
        
        if recipeAlreadySaved() {
            //Unsave recipe
            unsaveRecipe()
            
            //Desactivate favorite icon
            activateFavoriteIcon(false)
        } else {
            //Save recipe
            saveRecipe()
            
            //Activate favorite icon
            activateFavoriteIcon(true)
        }
    }
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertError(_:)), name: Notification.Name.unableToSaveContext, object: nil)
        
        shownActivityController(true)
        
        // Get recipe's details
        GetRecipeDetailsService.shared.getRecipeDetails(of: recipeToDetailId) { (success, recipeWithDetails, error) in
            if success, let recipeDetails = recipeWithDetails {
                
                self.recipeWithDetails = recipeDetails
                
                if self.recipeAlreadySaved() {
                    self.activateFavoriteIcon(true)
                }
                
                self.recipeName.text = recipeDetails.name
                self.recipeImage.image = recipeDetails.bigImage
                
                self.tableview.reloadData()
                
                self.shownActivityController(false)
            } else {
                guard let errorDescription = error else { return }
                self.showAlertError(message: errorDescription)
            }
        }
    }

    private func shownActivityController(_ show: Bool) {
        if show {
            activityIndicator.isHidden = false
        } else {
            activityIndicator.isHidden = true
        }
    }
    
    private func unsaveRecipe() {
        if !recipeService.delete(recipeWithDetails) {
            showAlertError(message: "Failed to delete recipe.")
        }
    }
    
    private func saveRecipe() {
        recipeService.saveRecipe(recipeWithDetails)
    }
    
    private func recipeAlreadySaved() -> Bool {
        return recipeService.checkExistenceOf(recipeName: recipeWithDetails.name)
    }
    
    private func activateFavoriteIcon(_ musteBeActived: Bool) {
        if musteBeActived {
            favoriteIcon.setImage(UIImage(named: "Favorite Activate"), for: .normal)
        } else {
            favoriteIcon.setImage(UIImage(named: "Favorite Desactivate"), for: .normal)
        }
    }
    
    ///Displays errors
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func showAlertError(_ notification: Notification) {
        if let data = notification.userInfo as? [String: String] {
            if let message = data.first?.value, let title = data.first?.key {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}

// MARK: - Tableview DataSource
extension ShowDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = recipeWithDetails?.ingredients.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Create cell
        let cell = tableview.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientTableViewCell

        //Implemente cell
        cell.ingredientName.text = recipeWithDetails.ingredients[indexPath.row]

        return cell
    }
}

