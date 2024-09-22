//
//  DraftOrderViewModel.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import Foundation

class DraftOrderViewModel{
    
    var networkService : NetworkServiceProtocol
    var draftOrders = MyDraftlist.wishListShared.currentDraftlist?.lineItems ?? []
    var isCart:Bool = false
    var products : [ProductModel] = []
    
    var reloadTV : (()->Void) = {}
    var noResult : (()->Void) = {}
    var navigateForward : (()->Void) = {}
    
    init() {
        self.networkService = NetworkService()
        
    }
    func emptyTable(){
        if(draftOrders.count == 0){
            noResult()
        }
    }
    
    
    
    func getDraftProducts(){
        if(isCart){
            draftOrders = MyDraftlist.cartListShared.currentDraftlist?.lineItems ?? []
        }else{
            draftOrders = MyDraftlist.wishListShared.currentDraftlist?.lineItems ?? []
        }
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
    
    
    
    func deleteDraftOrder(product: ProductModel){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        if(isCart){
            MyDraftlist.cartListShared.deleteLineItem(lineItem: lineItem,attribute: "note"){
                self.getDraftProducts()
            }
        }else{
            MyDraftlist.wishListShared.deleteLineItem(lineItem: lineItem){
               
            }
            self.getDraftProducts()
        }
        
    }
    
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
}
