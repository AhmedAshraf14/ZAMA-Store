//
//  OrdersModel.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import Foundation
struct OrdersResponse: Codable {
       let orders: [Order]
}
   
struct Order: Codable {
      let id: Int
           let totalPrice : String?
           let orderNumber: Int?
           let lineItems: [LineItem]?
            let shippingAddress: ShippingAddress?
    
           enum CodingKeys: String, CodingKey {
                   case id
                   case totalPrice = "total_price"
                   case orderNumber = "order_number"
                 case lineItems = "line_items"
                 case shippingAddress = "shipping_address"
             }
}


struct ShippingAddress: Codable {
         let address1: String?
         let phone: String?
         let city: String?
         let country: String?
         let name: String?
}
 
struct LineItem: Codable {
        let quantity: Int?
        let title: String?
}