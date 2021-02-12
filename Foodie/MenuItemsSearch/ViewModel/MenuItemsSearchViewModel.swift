//
//  MenuItemsSearchViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import UIKit
import Alamofire

class MenuItemsSearchViewModel {
    
    var isPaginating: Bool = false
    var offset = 0
    
    var menuItems: [MenuItem] = [] {
        didSet {
            self.didRecieveMenuItems?()
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
    
    
    var didRecieveMenuItems: (()->Void)?
    var didRecieveContentAlpha: (()->Void)?
    var didRecieveIsLoading: (()->Void)?
    var didRecieveErrorMessage: (()->Void)?
    
    
    
    func getMenuItems(query: String, pagination: Bool) {
        if pagination {
            self.isPaginating = true
        } else {
            self.isLoading = true
            self.contentAlpha = 0
            self.offset = 0
            self.menuItems.removeAll()
        }
        let trimmedQuery = query.replacingOccurrences(of: " ", with: "-")
        let url = Endpoints.menuItemSearch(query: trimmedQuery, offset: self.offset).url
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.7) {
            ApiServices.shared.getData(url: url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (result: MenuListItems?, err) in
                guard let self = self else { return }
                print("Getting Data vm")
                if pagination {
                    self.isPaginating = false
                }
                self.isLoading = false
                if let err = err {
                    self.errorMessage = "\(err)"
                } else {
                    guard let menuItems = result?.menuItems else { return }
                    for item in menuItems {
                        if !self.menuItems.contains(item) {
                            self.menuItems.append(item)
                        }
                    }
                    self.contentAlpha = 1
                    self.offset += 5
                }
            }
        }
        
        
    }
    
    
    
    
}
