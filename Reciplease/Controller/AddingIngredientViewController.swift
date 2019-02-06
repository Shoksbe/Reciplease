//
//  AddingIngredientViewController.swift
//  Reciplease
//
//  Created by De knyf Gregory on 04/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class AddingIngredientViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clearButton: UIButton!
    
    private var historiqueOfIngredient: [Historique]! {
        didSet {
            if historiqueOfIngredient.isEmpty {
                clearButton.isHidden = true
                clearButton.isEnabled = false
            } else {
                clearButton.isHidden = false
                clearButton.isEnabled = true
            }
        }
    }
    private var historiqueService = HistoriqueService()

    // MARK: - Actions
    @IBAction func buttonDidPressed(_ sender: UIButton) {
        saveIngredient()
    }
    
    @IBAction func clearButtonDidPressed(_ sender: UIButton) {
       clearListOfIngredients()
    }
    
    @IBAction func getRecipeButtonDidPressed(_ sender: UIButton) {
        if FridgeService.shared.ingredients.count > 0 {
            performSegue(withIdentifier: "GetRecipe", sender: self)
        } else {
            showAlertError(title:"Empty fridge", message: "Please enter an ingredient.")
        }
    }
    
    @IBAction func clearHistoriqueButtonDidPressed(_ sender: UIButton) {
        historiqueService.deleteHistorique()
        historiqueOfIngredient = historiqueService.all
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historiqueOfIngredient = historiqueService.all
        
        //Gesture to remove keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Methods
    
    //Save ingredient in ingredients array and reloadData
    private func saveIngredient() {
 
        guard var ingredientToAdd = ingredientTextField.text else { return }

        if ingredientToAdd.containsCharacter {
            
            //Trim whitespaces
            ingredientToAdd = ingredientToAdd.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Adding ingredient to the array
            FridgeService.shared.add(ingredient: ingredientToAdd)
            
            //check if ingredient is already save to database
            if !historiqueService.checkExistenceOf(ingredientName: ingredientToAdd) {
                //If not, Save ingredient
                historiqueService.saveIngredient(ingredientToAdd)
                //Get again all ingredient in historique
                historiqueOfIngredient = historiqueService.all
                //Reload collection view to display the new ingredient
                collectionView.reloadData()
            }
            
            //Reload tableView to add new ingredient
            tableView.reloadData()
        }
        
        //Clear textfield
        ingredientTextField.text?.removeAll()
    }
    
    //Remove all ingredient's array
    private func clearListOfIngredients() {
        
        //emptying the array
        FridgeService.shared.removeAll()
        
        //Reload tableView, she's now empty
        tableView.reloadData()
    }
    
    
    /// Display an alert on the screen
    ///
    /// - Parameters:
    ///   - title: Alert's title
    ///   - message: Alert's message
    private func showAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    ///Remove keyboard on the screen
    @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

// MARK: - TableView DataSource
extension AddingIngredientViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FridgeService.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        
        let ingredient = FridgeService.shared.ingredients[indexPath.row]
        
        cell.ingredientName.text = ingredient
        
        return cell
    }
}

//MARK: - TableView Delegate
extension AddingIngredientViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FridgeService.shared.removeAt(pos: indexPath.row)
            tableView.reloadData()
        }
    }
    
}

extension AddingIngredientViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historiqueOfIngredient.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historiqueCell", for: indexPath)
            as! HistoriqueCell
        //Implemente Cell
        cell.setup(historiqueOfIngredient[indexPath.row].ingredient)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Ingredient tapped
        let ingredient = historiqueOfIngredient[indexPath.row].ingredient
        //Add ingredient to the fridge list
        FridgeService.shared.add(ingredient: ingredient)
        //Reload tableview to display the new ingredient
        tableView.reloadData()
    }
}

// MARK: - TextFieldDelegate
extension AddingIngredientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveIngredient()
        dismissKeyboard()
        return false
    }
}
