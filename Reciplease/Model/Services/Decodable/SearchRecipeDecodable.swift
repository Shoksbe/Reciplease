//
//  SearchRecipeDecodable.swift
//  Reciplease
//
//  Created by De knyf Gregory on 12/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation

struct SearchRecipeDecodable: Codable {
    let matches: [Match]
}

struct Match: Codable {
    let imageUrlsBySize: ImageUrlsBySize
    let ingredients: [String]
    let id: String
    //let smallImageUrls: [String]
    let recipeName: String
    let totalTimeInSeconds: Int
    let rating: Int
}

struct ImageUrlsBySize: Codable {
    let the90: String

    enum CodingKeys: String, CodingKey {
        case the90 = "90"
    }
}
