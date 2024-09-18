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
    let currency: String?
    let note : String?
    let tags : String?
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
        case currency
        case note
        case tags
        case phone
        case addresses
        case defaultAddress = "default_address"
        case password
    }
}

// MARK: - Address

enum Currency: String, Codable {
    case egp = "EGP"
}
