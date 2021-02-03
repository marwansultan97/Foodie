//
//  RandomRecipe.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import Foundation

// MARK: - RandomRecipes
struct RandomRecipes: Codable {
    let recipes: [Recipe]

    enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
    }
}

// MARK: - Recipe
struct Recipe: Codable {
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool?
    let veryPopular: Bool?
    let sustainable: Bool?
    let weightWatcherSmartPoints: Int?
    let gaps: Gaps?
    let lowFodmap: Bool?
    let aggregateLikes: Int?
    let spoonacularScore: Int
    let healthScore: Int
    let creditsText: String?
    let license: String?
    let sourceName: String?
    let pricePerServing: Double
    let extendedIngredients: [ExtendedIngredient]
    let id: Int
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let sourceURL: String?
    let image: String?
    let imageType: ImageType?
    let summary: String
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [Diet]
    let occasions: [String]
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]
    let originalID: String?
    let spoonacularSourceURL: String?
    let author: Author?
    let preparationMinutes: Int?
    let cookingMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case vegetarian = "vegetarian"
        case vegan = "vegan"
        case glutenFree = "glutenFree"
        case dairyFree = "dairyFree"
        case veryHealthy = "veryHealthy"
        case cheap = "cheap"
        case veryPopular = "veryPopular"
        case sustainable = "sustainable"
        case weightWatcherSmartPoints = "weightWatcherSmartPoints"
        case gaps = "gaps"
        case lowFodmap = "lowFodmap"
        case aggregateLikes = "aggregateLikes"
        case spoonacularScore = "spoonacularScore"
        case healthScore = "healthScore"
        case creditsText = "creditsText"
        case license = "license"
        case sourceName = "sourceName"
        case pricePerServing = "pricePerServing"
        case extendedIngredients = "extendedIngredients"
        case id = "id"
        case title = "title"
        case readyInMinutes = "readyInMinutes"
        case servings = "servings"
        case sourceURL = "sourceUrl"
        case image = "image"
        case imageType = "imageType"
        case summary = "summary"
        case cuisines = "cuisines"
        case dishTypes = "dishTypes"
        case diets = "diets"
        case occasions = "occasions"
        case instructions = "instructions"
        case analyzedInstructions = "analyzedInstructions"
        case originalID = "originalId"
        case spoonacularSourceURL = "spoonacularSourceUrl"
        case author = "author"
        case preparationMinutes = "preparationMinutes"
        case cookingMinutes = "cookingMinutes"
    }
}

// MARK: - AnalyzedInstruction
struct AnalyzedInstruction: Codable {
    let name: String
    let steps: [Step]

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case steps = "steps"
    }
}

// MARK: - Step
struct Step: Codable {
    let number: Int
    let step: String
    let ingredients: [Ent]
    let equipment: [Ent]
    let length: Length?

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case step = "step"
        case ingredients = "ingredients"
        case equipment = "equipment"
        case length = "length"
    }
}

// MARK: - Ent
struct Ent: Codable, Equatable {
    
    static func == (lhs: Ent, rhs: Ent) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let localizedName: String
    let image: String
    let temperature: Length?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case localizedName = "localizedName"
        case image = "image"
        case temperature = "temperature"
    }
}

// MARK: - Length
struct Length: Codable {
    let number: Int
    let unit: Unit

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case unit = "unit"
    }
}

enum Unit: String, Codable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case minutes = "minutes"
}

enum Author: String, Codable {
    case afrolems = "Afrolems"
    case coffeebean = "coffeebean"
    case foodistaCOMTheCookingEncyclopediaEveryoneCanEdit = "Foodista.com – The Cooking Encyclopedia Everyone Can Edit"
    case fullBellySisters = "Full Belly Sisters"
    case jenWest = "Jen West"
    case lisaSVegetarianKitchen = "Lisa's Vegetarian Kitchen"
}

enum Diet: String, Codable {
    case dairyFree = "dairy free"
    case fodmapFriendly = "fodmap friendly"
    case glutenFree = "gluten free"
    case lactoOvoVegetarian = "lacto ovo vegetarian"
    case paleolithic = "paleolithic"
    case pescatarian = "pescatarian"
    case primal = "primal"
    case vegan = "vegan"
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable {
    let id: Int?
    let aisle: String?
    let image: String?
    let consistency: Consistency?
    let name: String
    let original: String
    let originalString: String
    let originalName: String
    let amount: Double
    let unit: String
    let meta: [String]
    let metaInformation: [String]
    let measures: Measures

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case aisle = "aisle"
        case image = "image"
        case consistency = "consistency"
        case name = "name"
        case original = "original"
        case originalString = "originalString"
        case originalName = "originalName"
        case amount = "amount"
        case unit = "unit"
        case meta = "meta"
        case metaInformation = "metaInformation"
        case measures = "measures"
    }
}

enum Consistency: String, Codable {
    case liquid = "liquid"
    case solid = "solid"
}

// MARK: - Measures
struct Measures: Codable {
    let us: Metric
    let metric: Metric

    enum CodingKeys: String, CodingKey {
        case us = "us"
        case metric = "metric"
    }
}

// MARK: - Metric
struct Metric: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String

    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case unitShort = "unitShort"
        case unitLong = "unitLong"
    }
}

enum Gaps: String, Codable {
    case gaps3 = "GAPS_3"
    case gaps5 = "GAPS_5"
    case no = "no"
}

enum ImageType: String, Codable {
    case jpg = "jpg"
    case png = "png"
}

enum License: String, Codable {
    case ccBy25CA = "CC BY 2.5 CA"
    case ccBy30 = "CC BY 3.0"
    case ccBy40 = "CC BY 4.0"
    case ccBySa30 = "CC BY-SA 3.0"
    case spoonacularSTerms = "spoonacular's terms"
}

enum SourceName: String, Codable {
    case afrolems = "Afrolems"
    case foodAndSpice = "Food and Spice"
    case foodista = "Foodista"
    case fullBellySisters = "Full Belly Sisters"
    case pinkWhen = "Pink When"
    case spoonacular = "spoonacular"
}


// MARK: - RandomJoke
struct RandomJoke: Codable {
    let text: String

    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}
