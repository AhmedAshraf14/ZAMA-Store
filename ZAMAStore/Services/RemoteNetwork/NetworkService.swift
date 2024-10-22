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
    func deleteData(path: String,handler:@escaping()->Void)
    func getDraftOrders(path: String, parameters: Alamofire.Parameters, handler: @escaping (Data?, Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol{
    private let baseUrl = "https://nciost1.myshopify.com/admin/api/2024-07/"
    private let currencyUrl = "https://api.exconvert.com/"
    
    private let headers1: HTTPHeaders = [
        "X-Shopify-Access-Token": "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"
    ]
    
    private let headers: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    //because of api error
    func getDraftOrders(path: String, parameters: Alamofire.Parameters, handler: @escaping (Data?, Error?) -> Void){
        
        AF.request("\(baseUrl)\(path).json",parameters: parameters, headers: headers1).validate().response{ response in
            switch response.result {
            case .success(let data):
                handler(data,nil)
            case .failure(let error):
                print("Request failed with error: \(error)")
                if let data = response.data{
                    handler(data,error)
                }else{
                    handler(nil,error)
                }
            }
            
        }
    }
    
    
    func getData<T: Codable> (path: String, parameters: Alamofire.Parameters, model: T.Type, handler: @escaping (T?, Error?) -> Void){
        var url = "\(baseUrl)\(path).json"
        var headers = headers1
        if path == "convert"{
            url = "\(currencyUrl)\(path)"
            headers = [:]
        }
        
        AF.request("\(url)",parameters: parameters, headers: headers).validate().responseDecodable(of: model.self) { response in
            switch response.result {
            case .success(let data):
                handler(data,nil)
            case .failure(let error):
                print("Request failed with error: \(error)")
                if let data = response.data,
                   let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Error response body: \(errorResponse)")
                }
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
                print("Request failed with error: \(error)")
                if let data = response.data,
                   let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Error response body: \(errorResponse)")
                }
                handler(nil,error)
            }
        }
    }
    
    func deleteData(path: String,handler:@escaping()->Void = {}) {
            AF.request("\(baseUrl)\(path).json", method: .delete, headers: headers).response { response in
                switch response.result{
                case .success(let data):
                    handler()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
}
