//
//  ProductDetailsViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

class ProductDetailsViewModel{
    var networkService : NetworkServiceProtocol!
    var productID = 7847468400777
    var product : ProductModel!
    
    
    init(){
        networkService = NetworkService()
    }
    
    func numberOfProductImages()->Int{
        return product.images.count
    }
}
