//
//  DiscountView.swift
//  ZAMAStore
//
//  Created by zyad Baset on 04/09/2024.
//

import Foundation
/*
 let parameters: [String: Any] = [
     "price_rule": [
         "title": "B@SETDiscount",
         "target_type": "line_item",  // Fixed the typo here
         "target_selection": "all",
         "allocation_method": "across",
         "value_type": "fixed_amount",
         "value": "-100.0",  // Assuming Shopify expects a positive value
         "customer_selection": "all",
         "starts_at": "2017-01-19T17:59:10Z"
     ]
 ]
 */

// MARK: - New
struct PriceRuleResponse: Codable {
    let priceRules: [PriceRule]

    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let value: String?
    let customerSelection:String?
    let targetType: String?
    let targetSelection, allocationMethod: String?
    let oncePerCustomer: Bool?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case oncePerCustomer = "once_per_customer"
        case title
    }
}


enum priceRuleImage : String{
    case sale1
    case sale2
    case sale3
}
