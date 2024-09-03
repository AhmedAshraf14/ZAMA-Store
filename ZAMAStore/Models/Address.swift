//
//  Address.swift
//  ZAMAStore
//
//  Created by zyad Baset on 03/09/2024.
//

import Foundation
struct Address: Codable {
    let id, customerID: Int
    //let firstName, lastName: String
    //let company: String?
    let address1: String
    let address2: String?
    let city: String
    //let province: String?
    let country,phone :String
   // let zip,
    let name: String
   // let provinceCode: String?
   // let countryCode, countryName: String
    let addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
       // case firstName = "first_name"
       // case lastName = "last_name"
       // case company
        case address1, address2, city
        //case province,
        case country, phone, name
       // case provinceCode = "province_code"
       // case countryCode = "country_code"
       // case countryName = "country_name"
        case addressDefault = "default"
    }
}

//struct Address:Codable{
//    var add:[Add]
//}
