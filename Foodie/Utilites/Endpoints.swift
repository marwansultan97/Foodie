//
//  Endpoints.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import Foundation

enum Endpoints {
    
    case randomRecipe(number: Int)
    case similarRecipes(id: Int)
    case randomJoke
    case randomTrivia
    case recipeID(id: Int)
    case autoComplete(query: String)
    case complexSearch
    case menuItemSearch(query: String, offset: Int)
    case menuItemInformation(id: Int)
    case mealPlanDay(calories: String?)
    case mealPlanWeek(calories: String?)
    
    var url: String {
                
        switch self {
        case .randomRecipe(let number):
            return MyConstants.shared.apiBody + "/recipes/random?apiKey=\(MyConstants.shared.apiKey)&number=\(number)"
            
        case .randomJoke:
            return MyConstants.shared.apiBody + "/food/jokes/random?apiKey=\(MyConstants.shared.apiKey)"
            
        case .randomTrivia:
            return MyConstants.shared.apiBody + "/food/trivia/random?apiKey=\(MyConstants.shared.apiKey)"
            
        case.recipeID(let id):
            return MyConstants.shared.apiBody + "/recipes/\(id)/information?apiKey=\(MyConstants.shared.apiKey)"
            
        case .autoComplete(let query):
            return MyConstants.shared.apiBody + "/recipes/autocomplete?apiKey=\(MyConstants.shared.apiKey)&number=50&query=\(query)"
            
        case .complexSearch:
            return MyConstants.shared.apiBody + "/recipes/complexSearch"
            
        case .menuItemSearch(let query, let offset):
            return MyConstants.shared.apiBody + "/food/menuItems/search?apiKey=\(MyConstants.shared.apiKey)&query=\(query)&number=5&offset=\(offset)"
            
        case .menuItemInformation(let id):
            return MyConstants.shared.apiBody + "/food/menuItems/\(id)?apiKey=\(MyConstants.shared.apiKey)"
            
        case .similarRecipes(let id):
            return MyConstants.shared.apiBody + "/recipes/\(id)/similar?apiKey=\(MyConstants.shared.apiKey)"
            
        case .mealPlanDay(let calories):
            if calories == nil || calories == "" {
                return MyConstants.shared.apiBody + "/mealplanner/generate?apiKey=\(MyConstants.shared.apiKey)&timeFrame=day"
            } else {
                return MyConstants.shared.apiBody + "/mealplanner/generate?apiKey=\(MyConstants.shared.apiKey)&timeFrame=day&targetCalories=\(calories!)"
            }
            
        case .mealPlanWeek(calories: let calories):
            if calories == nil || calories == "" {
                return MyConstants.shared.apiBody + "/mealplanner/generate?apiKey=\(MyConstants.shared.apiKey)&timeFrame=week"
            } else {
                return MyConstants.shared.apiBody + "/mealplanner/generate?apiKey=\(MyConstants.shared.apiKey)&timeFrame=week&targetCalories=\(calories!)"
            }
        }
    }
    
    
}






