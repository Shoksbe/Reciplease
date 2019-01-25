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
    
    // MARK: - Actions
    @IBAction func buttonDidPressed(_ sender: UIButton) {
        saveIngredient()
    }
    
    @IBAction func clearButtonDidPressed(_ sender: UIButton) {
       clearListOfIngredients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gesture to remove keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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

// MARK: - TextFieldDelegate
extension AddingIngredientViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveIngredient()
        return false
    }
    
}
