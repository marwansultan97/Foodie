//
//  MenuItemInformation.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import Foundation

// MARK: - MenuItemInformation
struct MenuItemInformation: Codable {
    let id: Int
    let title: String
    let price: String?
    let likes: Int
    let badges: [String]?
    let nutrition: Nutrition
    let servingSize: String?
    let readableServingSize: String?
    let numberOfServings: Int?
    let spoonacularScore: Int?
    let breadcrumbs: [String]
    let imageType: String
    let generatedText: String?
    let restaurantChain: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case likes = "likes"
        case badges = "badges"
        case nutrition = "nutrition"
        case servingSize = "servingSize"
        case readableServingSize = "readableServingSize"
        case numberOfServings = "numberOfServings"
        case spoonacularScore = "spoonacularScore"
        case breadcrumbs = "breadcrumbs"
        case imageType = "imageType"
        case generatedText = "generatedText"
        case restaurantChain = "restaurantChain"
        case images = "images"
    }
}

// MARK: - Nutrition
struct Nutrition: Codable {
    let nutrients: [Nutrient]
    let caloricBreakdown: CaloricBreakdown
    let calories: Int
    let fat: String
    let protein: String
    let carbs: String

    enum CodingKeys: String, CodingKey {
        case nutrients = "nutrients"
        case caloricBreakdown = "caloricBreakdown"
        case calories = "calories"
        case fat = "fat"
        case protein = "protein"
        case carbs = "carbs"
    }
}

// MARK: - CaloricBreakdown
struct CaloricBreakdown: Codable {
    let percentProtein: Double
    let percentFat: Double
    let percentCarbs: Double

    enum CodingKeys: String, CodingKey {
        case percentProtein = "percentProtein"
        case percentFat = "percentFat"
        case percentCarbs = "percentCarbs"
    }
}

// MARK: - Nutrient
struct Nutrient: Codable {
    let name: String
    let title: String
    let amount: Double
    let unit: String
    let percentOfDailyNeeds: Double

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case title = "title"
        case amount = "amount"
        case unit = "unit"
        case percentOfDailyNeeds = "percentOfDailyNeeds"
    }
}
