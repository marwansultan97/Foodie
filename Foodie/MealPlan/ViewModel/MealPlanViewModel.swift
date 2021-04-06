//
//  MealPlanViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/11/21.
//

import UIKit
import Alamofire

class MealPlanViewModel {
    
    var mealPlan: MealPlanDay? {
        didSet {
            self.didRecieveMealPlan?()
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
    
    
    var didRecieveMealPlan: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    
    func getMealPlanDay(calories: String) {
        
        self.isLoading = true
        self.contentAlpha = 0
        let url = Endpoints.mealPlanDay(calories: calories).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: MealPlanDay?, err) in
                guard let self = self else { return }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = err.description
                } else {
                    guard let result = result else { return }
                    self.mealPlan = result
                    self.contentAlpha = 1
                }
            }
        }
    }
    
    
}
