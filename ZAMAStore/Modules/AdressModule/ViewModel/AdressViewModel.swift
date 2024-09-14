//
//  AdressViewModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 11/09/2024.
//

import Foundation
class AddressViewModel{
    var putData : (()->Void) = {}
    var address:AddressResponse?
    let networkService:NetworkServiceProtocol
    let user = MyAccount.shared.currentUser
    init() {
        networkService = NetworkService()
        address=AddressResponse()
    }
    
    func pushData(){
        let jsonObj = try? JSONEncoder().encode(address)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let dic2 = dic as? [String:Any]
        networkService.postData(path: "customers/\(MyAccount.shared.currentUser.id)/addresses", parameters: dic2!, postFlag: true) { data, error in
            
            MyAccount.shared.reloadCustomer {
                
            }
        }
    }
}
