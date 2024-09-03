//
//  service1.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import Alamofire
protocol NetworkServiceProtocol{
    func getData<T: Codable> (path: String, parameters: Alamofire.Parameters, model: T.Type, handler: @escaping (T?,Error?) -> Void)
    func postData(path: String, parameters: Alamofire.Parameters, postFlag: Bool, handler: @escaping (Any?,Error?) -> Void)
    func deleteData(path: String)
}

class NetworkService: NetworkServiceProtocol{
    private let baseUrl = "https://nciost1.myshopify.com/admin/api/2024-07/"
    
    private let headers1: HTTPHeaders = [
        "X-Shopify-Access-Token": "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"
    ]
    
    private let headers: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    func getData<T: Codable> (path: String, parameters: Alamofire.Parameters, model: T.Type, handler: @escaping (T?, Error?) -> Void){
        
        AF.request("\(baseUrl)\(path).json",parameters: parameters, headers: headers1).validate().responseDecodable(of: model.self) { response in
            switch response.result {
            case .success(let data):
                handler(data,nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                handler(nil,error)
            }
        }
    }
    
    func postData(path: String, parameters: Alamofire.Parameters, postFlag: Bool , handler: @escaping (Any?, Error?) -> Void){
        
        AF.request("\(baseUrl)\(path).json",method: postFlag ? .post : .put, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
            switch response.result{
            case .success(let data):
                do{
                    let result = try JSONSerialization.jsonObject(with: data, options: [])
                    handler(result,nil)
                }catch{
                    print(error.localizedDescription)
                    handler(nil,error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                handler(nil,error)
            }
        }
    }
    
    func deleteData(path: String) {
        #warning("handle this function later when customer have orders")
            AF.request("\(baseUrl)\(path).json", method: .delete, headers: headers).response { response in
                switch response.result{
                case .success(let data):
                    print(data!)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
    
}
