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
    
    
    static func converAddress(add:Address?)->ShippingAddress?{
        if let add = add{
            var shipAdd = ShippingAddress(address1: add.address1, phone: add.phone, city: add.city, country: add.country, name: add.name)
            return shipAdd
        }
        return nil
    }
}
