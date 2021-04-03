//
//  ApiServices.swift
//  Foodie
//
//  Created by Marwan Osama on 1/27/21.
//

import Foundation
import Alamofire


class ApiServices {
    
    static let shared = ApiServices()
    
    func getData<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, encoding: JSONEncoding, headers: HTTPHeaders?, completion: @escaping(T?, String?)-> Void) {
        
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
                        completion(nil, "Something went wrong...")
                    }
                    
                case 401:
                    completion(nil, "No Authorization")
                case 402:
                    completion(nil, "Sorry, This is beta version, we ran out of recipes :( Try tomorrow")
                    
                default:
                    break
                }
            } else {
                completion(nil, "Something went wrong...")
            }
        }
    }
    
    
    
    
    
    
    
    
}
