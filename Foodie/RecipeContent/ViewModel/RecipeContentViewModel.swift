//
//  RecipeContentViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/1/21.
//

import UIKit
import Alamofire

class RecipeContentViewModel {
    
    var id: Int?
    
    init(id: Int) {
        self.id = id
    }
    
    var recipeContent: Recipe? {
        didSet {
            self.didRecieveRecipeContent?()
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
    
    
    var didRecieveRecipeContent: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    func getRecipes() {
        self.isLoading = true
        self.contentAlpha = 0
        
        let url = Endpoints.recipeID(id: self.id!).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: Recipe?, err) in
                guard let self = self else { return }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = "\(err)"
                } else {
                    guard let result = result else { return }
                    self.recipeContent = result
                    self.contentAlpha = 1
                }
            }
        }
    }
    
    
    
    
}
