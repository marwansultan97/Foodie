//
//  SearchRecipeNameViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/1/21.
//

import UIKit
import Alamofire

class SearchRecipeNameViewModel {
    
    
    var recipeElements: [RecipeElement] = [] {
        didSet {
            self.didRecieveRecipeElements?()
        }
    }
    
    var contentAlpha: CGFloat = 0 {
        didSet {
            self.didRecieveContentAlpha?()
        }
    }
    
    var isLoading: Bool = true {
        didSet {
            self.didRecieveIsLoading?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.didRecieveErrorMessage?()
        }
    }
    
    
    var didRecieveRecipeElements: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    
    func getData(query: String) {
        let trimmedQuery = query.replacingOccurrences(of: " ", with: "-")
        self.isLoading = true
        self.contentAlpha = 0
        let url = Endpoints.autoComplete(query: trimmedQuery).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: [RecipeElement]?, err) in
                guard let self = self else { return }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = "\(err)"
                } else {
                    guard let result = result else { return }
                    print("getting data")
                    self.recipeElements = result
                    self.contentAlpha = 1
                }
            }
        }
    }
    
    
    
    
    
    
    
}
