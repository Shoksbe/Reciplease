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
    
    /// List of ingredient
    var listOfIngredient: [String]!
    /// The recipe with detail
    var recipeWithDetails: Recipe!
    /// The service used for CRUD with coreData
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
            AlertHelper().alert(self, title: "Error", message: "Can not find the destination url")
            return
        }
        
        performSegue(withIdentifier: "showWebView", sender: url)
        //Launch url's recipe
        //UIApplication.shared.open(url)
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
        
        if recipeAlreadySaved() {
            activateFavoriteIcon(true)
        }
        
        recipeName.text = recipeWithDetails.name
        recipeImage.image = recipeWithDetails.bigImage
        
        self.tableview.reloadData()
    }
    
    /// Delete recipe from favorite
    private func unsaveRecipe() {
        if !recipeService.delete(recipeWithDetails.id) {
            AlertHelper().alert(self, title: "Error", message: "Failed to delete recipe")
        }
    }
    
    ///Add recipe to favorite
    private func saveRecipe() {
        recipeService.saveRecipe(recipeWithDetails, listOfIngredient: listOfIngredient)
    }
    
    
    /// Verify if the recipe is already saved in coreData
    ///
    /// - Returns: A boolean to say if recipe is already saved
    private func recipeAlreadySaved() -> Bool {
        return recipeService.checkExistenceOf(recipeId: recipeWithDetails.id)
    }
    
    
    /// Enable or disable the favorite icon
    ///
    /// - Parameter musteBeActived: A boolean to say if the icon must be actived
    private func activateFavoriteIcon(_ musteBeActived: Bool) {
        if musteBeActived {
            favoriteIcon.setImage(UIImage(named: "Favorite Activate"), for: .normal)
        } else {
            favoriteIcon.setImage(UIImage(named: "Favorite Desactivate"), for: .normal)
        }
    }
    
    ///Launch error alert whit notification
    @objc private func showAlertError(_ notification: Notification) {
        
        guard let data = notification.userInfo as? [String:String],
            let message = data.first?.value,
            let title = data.first?.key else {return}
        
        AlertHelper().alert(self, title: title, message: message)
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

// MARK: - Segue
extension ShowDetailsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showWebView" else {return}
        
        guard let destination = segue.destination as? WebViewController else {return}
        
        guard let url = sender as? URL else {return}
        
        destination.url = url
    }
}

