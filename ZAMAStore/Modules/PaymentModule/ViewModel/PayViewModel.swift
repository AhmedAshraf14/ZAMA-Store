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
    var errorResult : ((String)->Void) = {str in }
    
    init(){
        networkService=NetworkService()
    }
    
    
    func pushOrder(){
        let lineItemsResponse = lineItemResponse(line_items: makeLineItems())
        let order :[String:Any] = ["order":[
            "email":user!.email,
            "send_receipt" : true,
            "send_fulfillment_receipt" : true,
            "shipping_address":user!.defaultAddress,
            //"discount_codes":[["code":UIPasteboard.general.string]],
            "line_items" : lineItemsResponse
            ]]
        networkService.postData(path: "orders", parameters: order, postFlag: true) { data, error in
            if let error = error {
                print("//////////")
                print(error.localizedDescription)
                self.errorResult("Failed to pay, please try again.")
            }else {
                self.cart.deleteWholeDraftOrder(attribute: "note") {
                    
                }
            }
        }
    }
    
    func makeLineItems()->[lineItemOrder]{
        var lineItems : [lineItemOrder] = []
        for item in cart.currentDraftlist!.lineItems! {
            lineItems.append(lineItemOrder(variantID: item.variantID, quantity: item.quantity))
        }
        return lineItems
    }
}


struct lineItemResponse:Codable{
    var line_items : [lineItemOrder]
}

struct lineItemOrder: Codable{
    var variantID : Int
    var quantity : Int
    
    enum CodingKeys:String, CodingKey {
        case variantID = "variant_id"
        case quantity
    }
}
