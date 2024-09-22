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
    var isShow=false
    var navigateBack:()->Void = {}
    init() {
        networkService = NetworkService()
        address=AddressResponse()
    }
    
    
    func checkAddress(text:String?)->Bool{
        guard let text = text else { return false }
        if(text.count != 0 && text.replacingOccurrences(of: " ", with: "").count != 0){
            return true
        }else{
            return false
        }
    }
    
    func pushData(){
        let jsonObj = try? JSONEncoder().encode(address)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let dic2 = dic as? [String:Any]
        networkService.postData(path: "customers/\(MyAccount.shared.currentUser.id)/addresses", parameters: dic2!, postFlag: true) { data, error in
            
            MyAccount.shared.reloadCustomer {
                self.navigateBack()
            }
        }
    }
}

