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

                //Check if the api call return something
                guard response.result.isSuccess else {
                    print("Error while fetching data.")
                    callback(false, nil, "Error while fetching data")
                    return
                }

                //Check if the response contain data
                guard let data = response.data else {
                    callback(false, nil,  "No data")
                    return
                }

                //Decode the response's data
                guard let responseJSON = try? JSONDecoder().decode(GetRecipeDetailsDecodable.self, from: data) else {
                    callback(false, nil,  "Error parse JSON")
                    return
                }

                //Return the file decoded
                callback(true, self.getRecipeDetailsFrom(responseJSON), nil)
                
        }
    }
    
    private func getRecipeDetailsFrom(_ parsedData: GetRecipeDetailsDecodable) -> RecipeWithDetails {

        let recipeWithDetails = RecipeWithDetails(
            smallImageUrl: parsedData.images[0].hostedSmallURL,
            mediumImageUrl: parsedData.images[0].hostedMediumURL,
            largeImageUrl: parsedData.images[0].hostedLargeURL,
            name: parsedData.name,
            id: parsedData.id,
            ingredientLines: parsedData.ingredientLines,
            totalTimeInSeconds: parsedData.totalTimeInSeconds,
            rating: parsedData.rating,
            sourceRecipeUrl: parsedData.source.sourceRecipeUrl)

        return recipeWithDetails
    }

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
