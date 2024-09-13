//
//  viewmodel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import FirebaseAuth
class MyAccount{
    static let shared=MyAccount()
    var currentUser:Customer!
    var networkService:NetworkServiceProtocol
    private init() {
        networkService = NetworkService()
    }
    func reloadCustomer(handler:@escaping()->Void){
        NetworkService().getData(path: "customers/search", parameters: ["query":"email:\(currentUser.email)"], model: CustomersResponse.self) { data, error in
            MyAccount.shared.currentUser = data?.customers[0]
            handler()
        }
    }
    
    func putCustomer(draftOrderID:Int){
        let paramaters : [String:Any] = ["customer":["id":currentUser!.id,"tags": draftOrderID==0 ? "" : "\(draftOrderID)"]]
        networkService.postData(path: "customers/\(currentUser!.id)", parameters: paramaters, postFlag: false) { result, error in
            MyAccount.shared.reloadCustomer {
                
            }
        }
    }
}
