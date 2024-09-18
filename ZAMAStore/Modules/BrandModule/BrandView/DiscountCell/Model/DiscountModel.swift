//
//  DiscountModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 05/09/2024.
//

import Foundation

struct DiscountResponse:Codable{
     var discountCode:[DiscountModel] = []
    
    enum CodingKeys: String, CodingKey {
        case discountCode = "discount_codes"
    }

}
struct DiscountModel:Codable{
    let priceRuleId:Int
    let Id:Int
    let code:String
    let usageCount:Int
    
    enum CodingKeys: String,CodingKey {
        case priceRuleId = "price_rule_id"
        case Id = "id"
        case code
        case usageCount = "usage_count"
    }
}
