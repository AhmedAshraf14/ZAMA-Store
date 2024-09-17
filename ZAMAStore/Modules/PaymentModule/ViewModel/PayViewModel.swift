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
    var showSucessView:()->Void = {}
    
    init(){
        networkService=NetworkService()
    }
    
    
    func pushOrder(){
        let order = OrderResponse()
        let jsonObj = try? JSONEncoder().encode(order)
                let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
                let dic2 = dic as? [String:Any]
        networkService.postData(path: "orders", parameters: dic2 ?? [:], postFlag: true) { data, error in
            if let error = error {
                print("//////////")
                print(error.localizedDescription)
                self.errorResult("Failed to pay, please try again.")
            }else {
                self.cart.deleteWholeDraftOrder(attribute: "note") {
                    self.showSucessView()
                }
            }
        }
    }
    
    func makeLineItems()->[lineItemOrder]{
        var lineItems : [lineItemOrder] = []
        for item in cart.currentDraftlist!.lineItems {
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
