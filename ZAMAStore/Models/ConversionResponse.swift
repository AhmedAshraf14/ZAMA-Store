//
//  ConversionResponse.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 15/09/2024.
//

import Foundation
struct ConversionResponse: Codable {
    let result: Result
}

struct Result : Codable{
    let rate : Double
}
