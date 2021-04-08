//
//  SimilarRecipesViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/8/21.
//

import UIKit
import Alamofire

class SimilarRecipesViewModel {
    
    var id: Int?
    
    init(id: Int) {
        self.id = id
    }
    
    var similarRecipes: [SimilarRecipeElement] = [] {
        didSet {
            self.didRecieveSimilarRecipe?()
        }
    }
    
    var contentAlpha: CGFloat = 0 {
        didSet {
            self.didRecieveContentAlpha?()
        }
    }
    
    var isLoading = true {
        didSet {
            self.didRecieveIsLoading?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            didRecieveErrorMessage?()
        }
    }
    
    
    var didRecieveSimilarRecipe: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    func getRecipes() {
        self.isLoading = true
        self.contentAlpha = 0
        let url = Endpoints.similarRecipes(id: self.id ?? 0).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: [SimilarRecipeElement]?, err) in
                guard let self = self else { return }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = err.description
                } else {
                    guard let result = result, !result.isEmpty else {
                        self.errorMessage = "No results found."
                        return
                    }
                    self.similarRecipes = result
                    self.contentAlpha = 1
                }
            }
        }
        
        
    }
}
