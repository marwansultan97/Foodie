//
//  MenuListItemsViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import UIKit
import Alamofire

class MenuListItemsViewModel {
    
    var query: String?
    var offset: Int = 0
    var isPaginating: Bool = false
    
    init(query: String) {
        self.query = query
    }
    
    var listItems: [MenuItem] = [] {
        didSet {
            self.didRecieveListItems?()
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
    
    
    var didRecieveListItems: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    func getMenuItems(pagination: Bool) {
        if pagination {
            self.isPaginating = true
        } else {
            self.isLoading = true
            self.contentAlpha = 0
        }

        let url = Endpoints.menuItemSearch(query: self.query!, offset: self.offset).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: MenuListItems?, err) in
                guard let self = self else { return }
                if pagination {
                    self.isPaginating = false
                }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = err.description
                } else {
                    guard let menuItems = result?.menuItems, !menuItems.isEmpty else {
                        self.errorMessage = "No results found."
                        return
                    }
                    for item in menuItems {
                        if !self.listItems.contains(item) {
                            self.listItems.append(item)
                        }
                    }
                    self.contentAlpha = 1
                    self.offset += 5
                }
            }
        }
        
        
    }
    
    
    
}
