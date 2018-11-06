//
//  AddingIngredientViewController.swift
//  Reciplease
//
//  Created by De knyf Gregory on 04/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import UIKit

class AddingIngredientViewController: UIViewController {
    
    var ingredients = [String]()

    // MARK: - Outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    
    // MARK: - Actions
    @IBAction func buttonDidPressed(_ sender: UIButton) {
        saveIngredient()
    }
    
    //Save ingredient in ingredients array and reloadData
    private func saveIngredient() {
        guard let ingredient = ingredientTextField.text else { return }
        ingredients.append(ingredient)
    }
}
