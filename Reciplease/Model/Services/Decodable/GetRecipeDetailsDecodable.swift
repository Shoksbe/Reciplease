//
//  GetRecipeDetailsDecodable.swift
//  Reciplease
//
//  Created by Gregory De knyf on 29/11/2018.
//  Copyright © 2018 De knyf Gregory. All rights reserved.
//

import Foundation

struct GetRecipeDetailsDecodable: Codable {
    let images: [Image]
    let name: String
    let id: String
    let ingredientLines: [String]
    let totalTimeInSeconds: Int?
    let rating: Int?
    let source: Source
}


struct Image: Codable {
    let hostedSmallURL, hostedMediumURL, hostedLargeURL: String?
    let imageUrlsBySize: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case hostedSmallURL = "hostedSmallUrl"
        case hostedMediumURL = "hostedMediumUrl"
        case hostedLargeURL = "hostedLargeUrl"
        case imageUrlsBySize
    }
}

struct Source: Codable {
    let sourceRecipeUrl: String
}


