//
//  MenuListItem.swift
//  Foodie
//
//  Created by Marwan Osama on 2/10/21.
//

import Foundation

// MARK: - MenuListItems
struct MenuListItems: Codable {
    let type: String
    let menuItems: [MenuItem]
    let offset: Int
    let number: Int
    let totalMenuItems: Int
    let processingTimeMS: Int
    let expires: Int?
    let isStale: Bool?
    

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case menuItems = "menuItems"
        case offset = "offset"
        case number = "number"
        case totalMenuItems = "totalMenuItems"
        case processingTimeMS = "processingTimeMs"
        case expires = "expires"
        case isStale = "isStale"
    }
}

// MARK: - MenuItem
struct MenuItem: Codable, Equatable {

    
    static func == (lhs: MenuItem ,rhs: MenuItem) -> Bool {
        return lhs.title == rhs.title
    }
    
    let id: Int
    let title: String
    let restaurantChain: String
    let servingSize: String?
    let readableServingSize: String?
    let image: String?
    let imageType: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case restaurantChain = "restaurantChain"
        case servingSize = "servingSize"
        case readableServingSize = "readableServingSize"
        case image = "image"
        case imageType = "imageType"
    }
}




