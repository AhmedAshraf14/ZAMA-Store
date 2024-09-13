//
//  ProductDetailsViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

class ProductDetailsViewModel{
    var networkService : NetworkServiceProtocol!
    var product : ProductModel!
    var user = MyAccount.shared.currentUser
    var wishlist = MyWishlist.shared
    var isFav : Bool = false
    
    init(){
        networkService = NetworkService()
    }
    
    func numberOfProductImages()->Int{
        return product.images.count
    }
    
    func productIsFav(){
        if (user?.tags != ""){
            for product in wishlist.currentWishlist?.lineItems ?? []{
                if self.product.id == product.productID{
                    isFav = true
                    return
                }else {
                    print(self.product.id)
                    isFav = false
                }
            }
        }
    }
    
    func postFavDraftOrder(){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        
        let favDraftOrder = DraftOrderResponseModel(draftOrder: DraftOrder(id: 0, lineItems: [lineItem], customer: DraftCustomer(id: user!.id), useCustomerDefaultAddress: true))
        
        let jsonObj = try? JSONEncoder().encode(favDraftOrder)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let paramaters = dic as! [String:Any]

        networkService.postData(path: "draft_orders", parameters: paramaters, postFlag: true) { result, error in
            if let data = result{
                do{
                    let localdata = data as! [String:Any]
                    let draftOrder = localdata["draft_order"] as! [String:Any]
                    let id = draftOrder["id"] as! Int
                    let draftOrderResponseData = try! JSONSerialization.data(withJSONObject: data, options: [])
                    let decodedDraftOrder = try! JSONDecoder().decode(DraftOrderResponseModel.self, from: draftOrderResponseData)
                    
                    MyAccount.shared.putCustomer(draftOrderID: id)
                    MyWishlist.shared.currentWishlist = decodedDraftOrder.draftOrder
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func putFavDraftOrder(){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        wishlist.putLineItem(lineItem: lineItem)
    }
    
    func deleteFavDraftOrder(){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        wishlist.deleteLineItem(lineItem: lineItem)
    }
}



