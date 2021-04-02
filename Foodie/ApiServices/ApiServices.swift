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
    
    func getData<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, encoding: JSONEncoding, headers: HTTPHeaders?, completion: @escaping(T?, Error?)-> Void) {
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case.success(_):
                guard let data = response.data else { return }
                do {
                    let jsonResult = try JSONDecoder().decode(T.self, from: data)
                    completion(jsonResult, nil)
                }catch let jsonErr {
                    completion(nil, jsonErr)
                }
            case .failure(let err):
                completion(nil, err)
//                if let code = response.response?.statusCode {
//                    switch code {
//                    case 401:
//                        completion
//                    default:
//                        break
//                    }
//                }
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
}
