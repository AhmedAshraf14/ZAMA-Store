//
//  DraftOrder.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import Foundation

class MyWishlist{
    static let shared=MyWishlist()
    var currentWishlist: DraftOrder?
    var networkService:NetworkServiceProtocol
    private init() {
        networkService = NetworkService()
    }
    
    func putLineItem(lineItem:LineItem){
        currentWishlist?.lineItems!.append(lineItem)
        let response = DraftOrderResponseModel(draftOrder: currentWishlist!)
        let jsonObj = try? JSONEncoder().encode(response)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let newLineItems = dic as? [String:Any]
         
        networkService.postData(path: "draft_orders/\(currentWishlist!.id)", parameters: newLineItems ?? [:], postFlag: false) { result, error in
            
        }
    }
    
    func deleteLineItem(lineItem:LineItem){
        if currentWishlist?.lineItems!.count == 1{
            networkService.deleteData(path: "draft_orders/\(currentWishlist!.id)")
            currentWishlist = nil
            MyAccount.shared.putCustomer(draftOrderID: 0)
            MyAccount.shared.reloadCustomer {
                
            }
        }else{
            currentWishlist?.lineItems!.removeAll { item in
                item.variantID == lineItem.variantID
            }
            #warning("for zyad handle this shit")
            let response = DraftOrderResponseModel(draftOrder: currentWishlist!)
            let jsonObj = try? JSONEncoder().encode(response)
            let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
            let newLineItems = dic as? [String:Any]
            
            networkService.postData(path: "draft_orders/\(currentWishlist!.id)", parameters: newLineItems ?? [:], postFlag: false) { result, error in
                
            }
        }
    }
}
