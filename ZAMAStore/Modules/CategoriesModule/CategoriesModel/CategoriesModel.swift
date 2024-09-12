//
//  model.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

// MARK: - ProductResponse
struct ProductResponse: Codable {
    let products: [ProductModel]
}

// MARK: - Product


// MARK: - Image
struct Image: Codable {
    let id: Int
    let position, productID: Int
    let width, height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case width, height, src
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
}

enum Tags: String {
case men
    case women
    case kid
    case All
}

enum ProductType: String, Codable {
    case accessories = "ACCESSORIES"
    case shoes = "SHOES"
    case tShirts = "T-SHIRTS"
    case Running
    case all = "All"
}

enum PublishedScope: String, Codable {
    case global = "global"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price: String
    let position: Int
    let inventoryPolicy: InventoryPolicy
    let compareAtPrice: String?
    //let option1: String
    //let option2: Option2
    let taxable: Bool
    //let fulfillmentService: FulfillmentService
    let grams: Int
    let inventoryManagement: InventoryManagement?
    let requiresShipping: Bool
    let sku: String
    let weight: Int
    let weightUnit: WeightUnit
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
       // case option1, option2
        case taxable
        //case fulfillmentService = "fulfillment_service"
        case grams
        case inventoryManagement = "inventory_management"
        case requiresShipping = "requires_shipping"
        case sku, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
    }
}

enum FulfillmentService: String, Codable {
    case manual = "manual"
}

enum InventoryManagement: String, Codable {
    case shopify = "shopify"
}

enum InventoryPolicy: String, Codable {
    case deny = "deny"
}

enum Option2: String, Codable {
    case beige = "beige"
    case black = "black"
    case blue = "blue"
    case burgandy = "burgandy"
    case gray = "gray"
    case lightBrown = "light_brown"
    case red = "red"
    case white = "white"
    case yellow = "yellow"
}

enum WeightUnit: String, Codable {
    case kg = "kg"
}
