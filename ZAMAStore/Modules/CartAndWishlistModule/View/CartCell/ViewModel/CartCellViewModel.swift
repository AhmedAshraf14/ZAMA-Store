//
//  CartCellViewModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 13/09/2024.
//

import Foundation
class CartCellViewModel{
    var lineItem:LineItem!
    var index:Int
    var indexLineItem:Int!
    var product:ProductModel
    var netWorkService:NetworkServiceProtocol
    var viewController:DraftOrderViewControllerProtocol
    
    init(index:Int,product:ProductModel,obj:DraftOrderViewControllerProtocol){
        netWorkService = NetworkService()
        self.index=index
        self.product=product
        viewController = obj
        for (i,currentlineItem) in MyDraftlist.cartListShared.currentDraftlist!.lineItems!.enumerated(){
            if(currentlineItem.productID == product.id){
                self.lineItem = currentlineItem
                self.indexLineItem = i
            }
        }
    }

    
    func updateQuantity(quantity:Int) {
        MyDraftlist.cartListShared.putQuantity(quantity: quantity, index: indexLineItem){
            self.viewController.changePrice()
        }
    }
}
