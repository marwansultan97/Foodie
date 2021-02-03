//
//  Endpoints.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import Foundation

enum Endpoints {
    
    case randomRecipe(number: Int)
    case randomJoke
    case randomTrivia
    case recipeID(id: Int)
    case autoComplete(query: String)
    case complexSearch
    
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
        }
    }
    
    
}






