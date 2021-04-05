//
//  SearchRecipeFilterViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/2/21.
//

import UIKit
import Alamofire


class SearchRecipeFilterViewModel {
    
    var isPaginating: Bool = false
    var offset = 0
    var totalResult = 0
    
    var recipeElements: [RecipeFilterElement] = [] {
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
    
    
    
    func getData(urlComponents: URLComponents, pagination: Bool) {
        var urlcomponents = urlComponents
        if pagination {
            self.isPaginating = true
            self.offset += 5
            urlcomponents.queryItems?[6].value = "\(offset)"
        } else {
            self.offset = 0
            self.isLoading = true
            self.contentAlpha = 0
        }
        
        guard let url = urlcomponents.string else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: RecipeFilterElements?, err) in
                guard let self = self else { return }
                if pagination {
                    self.isPaginating = false
                }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = err
                } else {
                    guard let result = result else { return }
                    self.totalResult = result.totalResults
                    if pagination {
                        self.recipeElements.append(contentsOf: result.results)
                    } else {
                        self.recipeElements = result.results
                    }
                    print("getting data")
                    self.contentAlpha = 1
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
