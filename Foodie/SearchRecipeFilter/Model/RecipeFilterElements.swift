//
//  RecipeFilterElement.swift
//  Foodie
//
//  Created by Marwan Osama on 2/3/21.
//

import Foundation

// MARK: - RecipeFilterElement
struct RecipeFilterElements: Codable {
    let results: [RecipeFilterElement]
    let offset: Int
    let number: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case results = "results"
        case offset = "offset"
        case number = "number"
        case totalResults = "totalResults"
    }
}

// MARK: - Result
struct RecipeFilterElement: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case image = "image"
        case imageType = "imageType"
    }
}
