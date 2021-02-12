//
//  SimilarRecipeElement.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import Foundation

// MARK: - SimilarRecipeElement
struct SimilarRecipeElement: Codable {
    let id: Int
    let title: String
    let imageType: String
    let readyInMinutes: Int
    let servings: Int
    let sourceURL: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageType = "imageType"
        case readyInMinutes = "readyInMinutes"
        case servings = "servings"
        case sourceURL = "sourceUrl"
    }
}
