//
//  MenuListItemInformationViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import UIKit
import Alamofire


class MenuListItemInformationViewModel {
    
    var id: Int?
    
    init(id: Int) {
        self.id = id
    }
    
    var itemInformation: MenuItemInformation? {
        didSet {
            self.didRecieveMenuItemInformation?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            self.didRecieveErrorMessage?()
        }
    }
    
    var didRecieveMenuItemInformation: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    func getInformation() {
        
        let url = Endpoints.menuItemInformation(id: self.id!).url
        ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: MenuItemInformation?, err) in
            guard let self = self else { return }
            if let err = err {
                print(err)
                self.errorMessage = "There Is No Nutritions for this item"
            } else {
                guard let result = result else { return }
                self.itemInformation = result
            }
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}
