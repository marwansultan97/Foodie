//
//  MealPlan.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//


import Foundation

// MARK: - MealPlan
struct MealPlanDay: Codable {
    let meals: [Meal]
    let nutrients: Nutrients

    enum CodingKeys: String, CodingKey {
        case meals = "meals"
        case nutrients = "nutrients"
    }
}

// MARK: - Meal
struct Meal: Codable {
    let id: Int
    let imageType: String
    let title: String
    let readyInMinutes: Int
    let servings: Int?
    let sourceURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageType = "imageType"
        case title = "title"
        case readyInMinutes = "readyInMinutes"
        case servings = "servings"
        case sourceURL = "sourceUrl"
    }
}

// MARK: - Nutrients
struct Nutrients: Codable {
    let calories: Double
    let protein: Double
    let fat: Double
    let carbohydrates: Double

    enum CodingKeys: String, CodingKey {
        case calories = "calories"
        case protein = "protein"
        case fat = "fat"
        case carbohydrates = "carbohydrates"
    }
}
