//
//  GetRecipeDetailsService.swift
//  Reciplease
//
//  Created by Gregory De knyf on 29/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation
import Alamofire

class GetRecipeDetailsService {
    
    static var shared = GetRecipeDetailsService()
    private init() {}
    
    func getRecipeDetails(of recipe: Recipe, callback: @escaping (Bool, RecipeWithDetails?, String?) -> Void) {
        
        //Header for request, contain app id and app key
        let header: HTTPHeaders = ["X-Yummly-App-ID":"252dd2e6",
                                   "X-Yummly-App-Key":"afa5977aac4ad8225e73955c196b581e"]
        
        //Api endpoint
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipe/\(recipe.id)") else { return }
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          headers: header)
            .validate()
            .responseJSON { (response) in
                
                guard response.result.isSuccess else {
                    print("Error while fetching data.")
                    callback(false, nil, "Error while fetching data")
                    return
                }
                
                guard let data = response.data else {
                    callback(false, nil,  "No data")
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(GetRecipeDetailsDecodable.self, from: data) else {
                    callback(false, nil,  "Error parse JSON")
                    return
                }
                
                callback(true, self.getRecipeDetailsFrom(responseJSON), nil)
                
        }
    }
    
    
    private func getRecipeDetailsFrom(_ parsedData: GetRecipeDetailsDecodable) -> RecipeWithDetails {
        
        let recipeWithDetails = RecipeWithDetails(
            yield: parsedData.yield,
            totalTime: parsedData.totalTime,
            smallImageUrl: parsedData.images[0].hostedSmallURL,
            mediumImageUrl: parsedData.images[0].hostedMediumURL,
            largeImageUrl: parsedData.images[0].hostedLargeURL,
            name: parsedData.name,
            id: parsedData.id,
            ingredientLines: parsedData.ingredientLines,
            numberOfServings: parsedData.numberOfServings,
            totalTimeInSeconds: parsedData.totalTimeInSeconds,
            rating: parsedData.rating)
        
        return recipeWithDetails
    }
}
