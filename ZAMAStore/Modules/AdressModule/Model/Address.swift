//
//  Address.swift
//  ZAMAStore
//
//  Created by zyad Baset on 03/09/2024.
//

import Foundation

struct AddressResponse:Codable{
    var customer_address:Address?
    init(){
        customer_address=Address(addressDefault: false)
    }
    init(add:Address){
        customer_address=add
    }
}
struct Address: Codable {
    var id, customerID: Int?
    var address1: String?
    var address2: String?
    var city: String?
    var country,phone :String?
    var name: String?
    var addressDefault: Bool

    
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
