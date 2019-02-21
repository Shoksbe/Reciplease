//
//  YummlyService.swift
//  Reciplease
//
//  Created by Gregory De knyf on 20/02/2019.
//  Copyright © 2019 De knyf Gregory. All rights reserved.
//

import Foundation
import Alamofire

class YummlyService {
    
    var page: Int = 0
    
    private var yummlySession: YummlySesion
    
    init(yummlySession: YummlySesion = YummlySesion()) {
        self.yummlySession = yummlySession
    }
    
    func getRecipe(with ingredient: [String], callback: @escaping (Bool, [Recipe]?, String?) -> Void) {
        
        //Pagination
        let maxResult = 10
        let start = page * maxResult
        
        //Parameters for request
        let parameters: Parameters = ["q":ingredient, "maxResult":maxResult, "start": start]
        
        //Header for request, contain app id and app key
        let header: HTTPHeaders = ["X-Yummly-App-ID":YUMMLY_ID,
                                   "X-Yummly-App-Key":YUMMLY_KEY]
        
        //Api endpoint
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipes") else { return }
        
        yummlySession.request(url: url, method: .get, parameters: parameters, header: header) { (response) in
            
            guard response.response?.statusCode == 200 else {
                callback(false, nil, "Bad response from server")
                return
            }
            
            guard let data = response.data else {
                callback(false, nil,  "No data")
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(SearchRecipeDecodable.self, from: data) else {
                callback(false, nil,  "Error parse JSON")
                return
            }
            
            self.page += 1
            
            callback(true, self.getRecipeDataFrom(responseJSON), nil)
        }
        
    }
    
    /// Extract datat from Json file to create own Recipe Array
    ///
    /// - Parameter parsedData: Json file with recipe data
    /// - Returns: An array of recipe
    private func getRecipeDataFrom(_ parsedData: SearchRecipeDecodable) -> [Recipe] {
        var recipes: [Recipe] = []
        for recipe in parsedData.matches {
            
            var backgroundImage: UIImage = UIImage(named: "DefaultImageRecipe")!
            
            if let url = URL(string: recipe.imageUrlsBySize.the90) {
                if let data = try? Data(contentsOf: url) {
                    backgroundImage = UIImage(data: data)!
                }
            }
            
            recipes.append(Recipe(
                id: recipe.id,
                name: recipe.recipeName,
                ingredients: recipe.ingredients,
                timeToPrepareInSeconde: recipe.totalTimeInSeconds,
                rating: recipe.rating,
                smallImage: backgroundImage,
                bigImage: nil,
                sourceRecipeUrl: nil)
            )
        }
        return recipes
    }
    
    /// Retrieving the details of a recipe
    ///
    /// - Parameters:
    ///   - recipeId: The id of the recipe to find
    ///   - callback: *Boolean* for success, A table of recipes found, A description of the error if there is one
    func getRecipeDetails(of recipeId: String, callback: @escaping (Bool, Recipe?, String?) -> Void) {
        
        //Header for request, contain app id and app key
        let header: HTTPHeaders = ["X-Yummly-App-ID":YUMMLY_ID,
                                   "X-Yummly-App-Key":YUMMLY_KEY]
        
        //Api endpoint
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipe/\(recipeId)") else {
            print("Error when creating url")
            callback(false, nil, "Bad url")
            return
        }
        
                            
        yummlySession.request(url: url, method: .get, parameters: nil, header: header) { (response) in
                
                //Check if the api call return something
                guard response.response?.statusCode == 200 else {
                    print("Error while fetching data.")
                    callback(false, nil, "Error while fetching data")
                    return
                }
                
                //Check if the response contain data
                guard let data = response.data else {
                    print("No data in response")
                    callback(false, nil,  "No data")
                    return
                }
                
                //Decode the response's data
                guard let responseJSON = try? JSONDecoder().decode(GetRecipeDetailsDecodable.self, from: data) else {
                    print("Error when parse JSON")
                    callback(false, nil,  "Error parse JSON")
                    return
                }
                
                //Return the file decoded
                callback(true, self.getRecipeDetailsFrom(responseJSON), nil)
                
        }
    }
    
    
    /// Get data into json file to create own recipe
    ///
    /// - Parameter parsedData: Json data with detail of recipe
    /// - Returns: A recipe with detail
    private func getRecipeDetailsFrom(_ parsedData: GetRecipeDetailsDecodable) -> Recipe {
        
        //Prepare background image for recipe with details
        var backgroundImage: UIImage = UIImage(named: "DefaultImageRecipe")!
        
        //Find bigest image string url
        if let imageUrl = recoveryOfTheLargestImageUrl(parsedData) {
            do {
                let data = try Data(contentsOf: imageUrl)
                backgroundImage = UIImage(data: data)!
            } catch let error {
                print(error)
            }
        }
        
        //Create a recipe with details
        let recipeWithDetails = Recipe(
            id: parsedData.id,
            name: parsedData.name,
            ingredients: parsedData.ingredientLines,
            timeToPrepareInSeconde: parsedData.totalTimeInSeconds,
            rating: parsedData.rating,
            smallImage: nil,
            bigImage: backgroundImage,
            sourceRecipeUrl: parsedData.source.sourceRecipeUrl)
        
        return recipeWithDetails
    }
    
    
    /// Find url of the biggest image present in array
    ///
    /// - Parameter parsedData: Json data with an array of images
    /// - Returns: the url of the biggest image
    private func recoveryOfTheLargestImageUrl(_ parsedData: GetRecipeDetailsDecodable) -> URL? {
        
        var urlString: String?
        
        let images = parsedData.images[0]
        urlString = images.hostedSmallURL != nil ? images.hostedSmallURL : urlString
        urlString = images.hostedMediumURL != nil ? images.hostedMediumURL : urlString
        urlString = images.hostedLargeURL != nil ? images.hostedLargeURL : urlString
        
        if let url = urlString {
            return URL(string: url)
        }
        
        return nil
        
    }
    
}



