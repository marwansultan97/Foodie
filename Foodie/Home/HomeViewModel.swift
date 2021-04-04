//
//  HomeViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import UIKit
import Alamofire

class HomeViewModel {
    
    var isPaginating: Bool = false
    
    var randomRecipes: [Recipe] = [] {
        didSet {
            self.didRecieveRandomRecipe?()
        }
    }
    
    
    
    var randomJoke: RandomJoke? {
        didSet {
            self.didRecieveRandomJoke?()
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
    
    
    var didRecieveRandomRecipe: (()->Void)?
    var didRecieveRandomJoke: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    func getRecipes(pagination: Bool) {
        if pagination {
            isPaginating = true
        } else {
            self.isLoading = true
            self.contentAlpha = 0
        }
        
        let url = Endpoints.randomRecipe(number: 2).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: RandomRecipes?, err) in
                guard let self = self else { return }
                print("Getting Data vm")
                if pagination {
                    self.isPaginating = false
                }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = "\(err)"
                } else {
                    guard let result = result else { return }
                    if pagination {
                        self.randomRecipes.append(contentsOf: result.recipes)
                    } else {
                        self.randomRecipes = result.recipes
                    }
                    
                    
                    self.contentAlpha = 1
                }
            }
        }
        
    }

    
    func getJoke() {
        let url = Endpoints.randomTrivia.url
        ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (joke: RandomJoke?, err) in
            guard let self = self else { return }
            if let err = err {
                self.errorMessage = err
            } else {
                guard let joke = joke else { return }
                self.randomJoke = joke
            }

        }
    }

    
    
    
    
    
}
