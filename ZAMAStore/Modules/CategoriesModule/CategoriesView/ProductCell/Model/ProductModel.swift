//
//  ProductModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 06/09/2024.
//

import Foundation
struct ProductModel: Codable {
    let id: Int
    let title, bodyHTML, vendor: String
    let productType: ProductType
    let handle: String?
    let tags: String
    let status: Status
    let variants: [Variant]
    let options: [Option]
    let images: [Image]?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case handle
        case tags, status
        case variants, options, images, image
    }
}
