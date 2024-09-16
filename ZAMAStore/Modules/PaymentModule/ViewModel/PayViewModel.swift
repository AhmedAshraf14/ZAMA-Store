//
//  PaymentViewModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 16/09/2024.
//

import Foundation
import UIKit
class PayViewModel{
    var user = MyAccount.shared.currentUser
    var cart = MyDraftlist.cartListShared
    var order:OrderResponse?
    var networkService:NetworkServiceProtocol
    
    
    init(){
        networkService=NetworkService()
    }
    
    
    func pushOrder(){
        var order :[String:Any] = ["order":[
            "email":user!.email,
            "send_receipt" : true,
            "send_fulfillment_receipt" : true,
            "shipping_address":user?.defaultAddress,
            "discount_codes":["code":UIPasteboard.general.string],
            "line_items" : cart.currentDraftlist?.lineItems
            ]]
        networkService.postData(path: "orders", parameters: order, postFlag: true) { data, error in
            self.cart.deleteWholeDraftOrder(attribute: "note") {
                
            }
        }
    }
}
