//
//  model.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

struct CustomersResponse: Codable {
    let customers: [Customer]
}
struct SingleCustomerResponse: Codable {
    let customer: Customer
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int
    let email: String
    let firstName, lastName: String?
    let ordersCount: Int
    let totalSpent: String
    let lastOrderID: Int?
    let lastOrderName: String?
   // let currency: String?
    let phone: String?
    let addresses: [Address]?
    let defaultAddress: Address?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case lastOrderName = "last_order_name"
       // case currency
        case  phone
        case addresses
        case defaultAddress = "default_address"
        case password
    }
}

// MARK: - Address

enum Currency: String, Codable {
    case egp = "EGP"
}







// MARK: - Welcome

//struct Welcome:Codable {
//
//    let customer: Customer
//
//}
//
//// MARK: - Customer
//
//struct Customer:Codable {
//
//    let id: Int
//
//    let email: String
//
//    let createdAt, updatedAt: String?
//
//    let firstName, lastName: String
//
//    let ordersCount: Int
//
//    let state, totalSpent: String
//
//    let lastOrderID: Int
//
//    let note: String?
//
//    let verifiedEmail: Bool
//
//    let multipassIdentifier: String?
//
//    let taxExempt: Bool
//
//    let tags, lastOrderName, currency, phone: String
//
//    let addresses: [Address]
//
//    let taxExemptions: [Any?]
//
//   // let emailMarketingConsent, smsMarketingConsent: MarketingConsent
//
//    let adminGraphqlAPIID: String
//
//    let defaultAddress: Address
//
//    enum CodingKeys: String, CodingKey {
//
//            case id, email
//
//            case createdAt = "created_at"
//
//            case updatedAt = "updated_at"
//
//            case firstName = "first_name"
//
//            case lastName = "last_name"
//
//            case ordersCount = "orders_count"
//
//            case state
//
//            case totalSpent = "total_spent"
//
//            case lastOrderID = "last_order_id"
//
//            case note
//
//            case verifiedEmail = "verified_email"
//
//            case multipassIdentifier = "multipass_identifier"
//
//            case taxExempt = "tax_exempt"
//
//            case tags
//
//            case lastOrderName = "last_order_name"
//
//            case currency, phone, addresses
//
//            case taxExemptions = "tax_exemptions"
//
//           // case emailMarketingConsent = "email_marketing_consent"
//
//           // case smsMarketingConsent = "sms_marketing_consent"
//
//            case adminGraphqlAPIID = "admin_graphql_api_id"
//
//            case defaultAddress = "default_address"
//
//        }
//
//}
//
//// MARK: - Address
//
//struct Address:Codable {
//
//    let id, customerID: Int
//
//    let firstName, lastName, company: String?
//
//    let address1, address2, city, province: String
//
//    let country, zip, phone, name: String
//
//    let provinceCode, countryCode, countryName: String
//
//    let addressDefault: Bool
//
//    enum CodingKeys: String, CodingKey {
//            case id
//            case customerID = "customer_id"
//            case firstName = "first_name"
//            case lastName = "last_name"
//            case company, address1, address2, city, province, country, zip, phone, name
//            case provinceCode = "province_code"
//            case countryCode = "country_code"
//            case countryName = "country_name"
//            case addressDefault = "default"
//        }
//
//}
//
//// MARK: - MarketingConsent
////
////struct MarketingConsent:Codable {
////
////    let state: String
////
////    let optInLevel: String?
////
////    let consentUpdatedAt: Date
////
////    let consentCollectedFrom: String?
////
////    enum CodingKeys: String, CodingKey {
////            case state
////            case optInLevel = "opt_in_level"
////            case consentUpdatedAt = "consent_updated_at"
////            case consentCollectedFrom = "consent_collected_from"
////        }
////
////}
