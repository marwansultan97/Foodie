//
//  ApiServices.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import Foundation
import Alamofire

enum ApiError: Error, CustomStringConvertible {
    
    case noAuthorization
    case invalidData
    case betaVersion
    case unknown
    
    var description: String {
        switch self {
        case .invalidData: return "Invalid Recipe"
        case .betaVersion: return "This is beta version, we ran out of recipes :(\ntry again tomorrow"
        case .noAuthorization: return "No authorization found."
        case .unknown: return "We encountered unexpected problem\n(Check internet connection)"
        }
    }
    
    
}

class ApiServices {
    
    static let shared = ApiServices()
    
    func getData<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, encoding: JSONEncoding, headers: HTTPHeaders?, completion: @escaping(T?, ApiError?)-> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            if let err = response.error {
                print(err)
            }
            
            if let code = response.response?.statusCode {
                switch code {
                case 200..<300:
                    
                    guard let data = response.data else { return }
                    do {
                        let jsonResult = try JSONDecoder().decode(T.self, from: data)
                        completion(jsonResult, nil)
                    } catch let jsonErr {
                        print(jsonErr)
                        completion(nil, .invalidData)
                    }
                    
                case 401:
                    completion(nil, .noAuthorization)
                case 402:
                    completion(nil, .betaVersion)
                    
                default:
                    break
                }
            } else {
                completion(nil, .unknown)
            }
        }
    }
    
    
    
    
    
    
    
    
}
