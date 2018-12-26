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
    
    func getRecipeDetails(of recipeId: String, callback: @escaping (Bool, Recipe?, String?) -> Void) {
        
        //Header for request, contain app id and app key
        let header: HTTPHeaders = ["X-Yummly-App-ID":"252dd2e6",
                                   "X-Yummly-App-Key":"afa5977aac4ad8225e73955c196b581e"]

        //Api endpoint
        guard let url = URL(string: "https://api.yummly.com/v1/api/recipe/\(recipeId)") else {
            print("Error when creating url")
            callback(false, nil, "Bad url")
            return
        }

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
