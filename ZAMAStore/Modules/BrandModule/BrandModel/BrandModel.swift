//
//  model.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

struct BrandsResponse: Codable {
    let smartCollections: [SmartCollection]?

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - SmartCollection
struct SmartCollection: Codable {
    let id: Int?
    let handle, title: String?
    let updatedAt: String?
    let bodyHTML: String?
    let publishedAt: String?
    let sortOrder: String?
    let disjunctive: Bool?
    let rules: [Rule]?
    let publishedScope: String?
    let adminGraphqlAPIID: String?
    let image: BrandImage?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case updatedAt = "updated_at"
        case bodyHTML = "body_html"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case disjunctive, rules
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - Image
struct BrandImage: Codable {
    let createdAt: String?
 
    let width, height: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case  width, height, src
    }
}
// MARK: - Rule
struct Rule: Codable {
    let column: String?
    let relation: String?
    let condition: String?
}
