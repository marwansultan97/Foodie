//
//  MenuListViewModel.swift
//  Foodie
//
//  Created by Marwan Osama on 4/2/21.
//

import Foundation

class MenuListViewModel {
    
    
    var menus = [Menu]() {
        didSet {
            self.didRecieveMenus?()
        }
    }

    var didRecieveMenus: (()->())?
    
    
    func setMenuList() {
        menus = [
        
            Menu(name: "Burger King", image: "burgerking", urlQuery: "burger-king"),
            Menu(name: "Chick-fil-A", image: "chick-fila", urlQuery: "chick-fil-a"),
            Menu(name: "Cinnabon", image: "cinnabon", urlQuery: "cinnabon"),
            Menu(name: "Costco", image: "costco", urlQuery: "costco"),
            Menu(name: "Dunkin Donuts", image: "dd", urlQuery: "dunkin-donuts"),
            Menu(name: "Dominos Pizza", image: "dominos", urlQuery: "dominos-pizza"),
            Menu(name: "Hooters", image: "hooters", urlQuery: "hooters"),
            Menu(name: "KFC", image: "kfc", urlQuery: "kfc"),
            Menu(name: "Krispy Kreme", image: "kk", urlQuery: "krispy-kreme"),
            Menu(name: "McDonald's", image: "mc", urlQuery: "mcdonald"),
            Menu(name: "Nando's", image: "nando", urlQuery: "nando"),
            Menu(name: "P.F.Chang's", image: "pf-changs", urlQuery: "pf-changs"),
            Menu(name: "Pizza Hut", image: "pizzahut", urlQuery: "pizza-hut"),
            Menu(name: "Taco Bell", image: "tacobell", urlQuery: "taco-bell"),
            Menu(name: "Wendy's", image: "wendys", urlQuery: "wendys"),
            Menu(name: "Aryb's", image: "arbys", urlQuery: "arbys")

        ]
    }
    
    
    
}
