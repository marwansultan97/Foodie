//
//  MealPlanWeek.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import Foundation

// MARK: - MealPlanWeek
struct MealPlanWeek: Codable {
    let week: Week

    enum CodingKeys: String, CodingKey {
        case week = "week"
    }
}

// MARK: - Week
struct Week: Codable {
    let monday: Day
    let tuesday: Day
    let wednesday: Day
    let thursday: Day
    let friday: Day
    let saturday: Day
    let sunday: Day

    enum CodingKeys: String, CodingKey {
        case monday = "monday"
        case tuesday = "tuesday"
        case wednesday = "wednesday"
        case thursday = "thursday"
        case friday = "friday"
        case saturday = "saturday"
        case sunday = "sunday"
    }
}

// MARK: - Day
struct Day: Codable {
    let meals: [MealWeek]
    let nutrients: NutrientsWeek

    enum CodingKeys: String, CodingKey {
        case meals = "meals"
        case nutrients = "nutrients"
    }
}

// MARK: - Meal
struct MealWeek: Codable {
    let id: Int
    let imageType: String
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceURL: String

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
struct NutrientsWeek: Codable {
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
