//
//  DraftOrder.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import Foundation

struct DraftOrderList:Codable{
    let draftOrders : [DraftOrder]
    
    enum CodingKeys: String,CodingKey {
        case draftOrders = "draft_orders"
    }
}
struct DraftOrderResponseModel: Codable {
    let draftOrder: DraftOrder
 
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrder:Codable {
    var id : Int
    var lineItems : [LineItem]=[]
    var customer : DraftCustomer
    var useCustomerDefaultAddress: Bool
    var subTotalPrice:String?
    var totalPrice : String?
    var totalTax : String?
    init(id: Int, lineItems: [LineItem], customer: DraftCustomer, useCustomerDefaultAddress: Bool) {
        self.id = id
        self.lineItems = lineItems
        self.customer = customer
        self.useCustomerDefaultAddress = useCustomerDefaultAddress
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.lineItems = try container.decode([LineItem].self, forKey: .lineItems)
        self.useCustomerDefaultAddress = true
        self.customer = try container.decode(DraftCustomer.self, forKey: .customer)
        self.subTotalPrice = try container.decode(String.self, forKey: .subTotalPrice)
        self.totalPrice = try container.decode(String.self, forKey: .totalPrice)
        self.totalTax = try container.decode(String.self, forKey: .totalTax)
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case lineItems = "line_items"
        case useCustomerDefaultAddress = "use_customer_default_address"
        case customer
        case subTotalPrice = "subtotal_price"
        case totalPrice = "total_price"
        case totalTax = "total_tax"
    }
}

struct LineItem: Codable {
    let id: Int
    let variantID:Int
    let productID: Int
    let title: String
    var quantity: Int
    let price : String?
    
 
    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case title
        case quantity
        case productID = "product_id"
        case price
    }
}

struct DraftCustomer:Codable {
    let id: Int
}
