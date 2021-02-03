//
//  RecipeElement.swift
//  Foodie
//
//  Created by Marwan Osama on 2/1/21.
//

import Foundation

// MARK: - RecipeElement
struct RecipeElement: Codable {
    let id: Int
    let title: String
    let imageType: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case imageType = "imageType"
    }
}
