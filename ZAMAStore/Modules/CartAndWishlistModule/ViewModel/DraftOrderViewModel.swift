//
//  DraftOrderViewModel.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import Foundation

class DraftOrderViewModel{
    
    var networkService : NetworkServiceProtocol
    var draftOrders = MyWishlist.shared.currentWishlist?.lineItems ?? []
    var products : [ProductModel] = []
    
    var reloadTV : (()->Void) = {}
    var noResult : (()->Void) = {}
    var navigateForward : (()->Void) = {}
    
    init() {
        self.networkService = NetworkService()
    }
    
    
    func getFavProducts(){
        draftOrders = MyWishlist.shared.currentWishlist?.lineItems ?? []
        var ids : String = ""
        for product in draftOrders {
            ids += "\(product.productID),"
        }
        
        if ids != ""{
            ids.removeLast()
            networkService.getData(path: "products", parameters: ["ids":ids], model: ProductResponse.self) { result, error in
                if let result = result {
                    self.products = result.products
                    self.reloadTV()
                }
            }
        }else {
            self.products = []
            self.noResult()
        }
    }
    
    func deleteFavDraftOrder(product: ProductModel){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        MyWishlist.shared.deleteLineItem(lineItem: lineItem)
    }
}
