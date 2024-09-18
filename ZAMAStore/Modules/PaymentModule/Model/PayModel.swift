//
//  PayModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 17/09/2024.
//

import Foundation
struct OrderResponse:Codable{
    var order:Order1
    init(code: String , amount: String){
        var code2 = code
        if code == ""{
            code2 = "FAKE30"
        }
        order = Order1(email: MyAccount.shared.currentUser.email, send_receipt: true, send_fulfillment_receipt: true, line_items: MyDraftlist.cartListShared.currentDraftlist?.lineItems ?? [], shipping_address: ShippingAddress.converAddress(add: MyAccount.shared.currentUser.defaultAddress)!, discount_codes: [DiscountCode(code: code2, amount: amount)])
    }
}
struct Order1:Codable{
    var email:String
    var send_receipt:Bool=true
    var send_fulfillment_receipt:Bool=true
    var line_items:[LineItem]=[]
    var shipping_address = ShippingAddress(address1: "Bolaak", phone: "01021440823", city: "Giza", country: "Egypt", name: "Ahmed")
    var discount_codes : [DiscountCode]
}
struct LineItem1:Codable{
    var variant_id:Int=42943993905289
    var quantity:Int=1
}


struct DiscountCode: Codable{
    var code : String = "FAKE30"
    var amount : String = "0"
    var type : String = "percentage"
}
