//
//  ViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
class SettingViewModel{
    let networkService:NetworkServiceProtocol
    var customer = MyAccount.shared.currentUser
    var reloadTV:(()->Void)={}
    init() {
        networkService = NetworkService()
    }
    func deleteAddress(index:Int){
        networkService.deleteData1(path: "customers/\(customer!.id)/addresses/\(customer!.addresses![index].id!)"){
            self.reloadUser()
        }
        
    }
    func reloadUser() {
        MyAccount.shared.reloadCustomer(){
            self.customer = MyAccount.shared.currentUser
            self.reloadTV()
        }
    }
    
    func putDefaultAddress(index:Int){
        let parameters: [String: Any] = [
            "customer_address": [
                "id": customer!.addresses![index].id!,
                "customer_id": customer!.id // Fixed the typo here
            ]
        ]
        networkService.postData(path: "customers/\(customer!.id)/addresses/\(customer!.addresses![index].id!)/default", parameters: parameters, postFlag: false) { data, error in
           // MyAccount.shared.reloadCustomer()
            self.reloadUser()
            
        }
        
    }
}
