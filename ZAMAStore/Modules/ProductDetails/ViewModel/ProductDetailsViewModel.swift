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
    var wishlist = MyDraftlist.wishListShared
    var cartDraftOrder = MyDraftlist.cartListShared
    var errorResult : ((String)->Void) = {error in }
    var isFav : Bool = false
    
    init(){
        networkService = NetworkService()
    }
    
    func numberOfProductImages()->Int{
        return product.images!.count
    }
    
    func productIsFav(){
        if (user?.tags != ""){
            for product in wishlist.currentDraftlist?.lineItems ?? []{
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
    
    func postToDraftOrder(isCart:Bool){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        
        let favDraftOrder = DraftOrderResponseModel(draftOrder: DraftOrder(id: 0, lineItems: [lineItem], customer: DraftCustomer(id: user!.id), useCustomerDefaultAddress: true))
        if(isCart){
            MyDraftlist.cartListShared.currentDraftlist = DraftOrder(id: 0, lineItems: [], customer: DraftCustomer(id: MyAccount.shared.currentUser.id), useCustomerDefaultAddress: true)
        }
        
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
                   
                    MyAccount.shared.putCustomer(draftOrderID: id,attribute: isCart ? "note":"tags")
                    if(isCart){
                        MyDraftlist.cartListShared.currentDraftlist?.id=id
                        MyDraftlist.cartListShared.reloadCart(){
                            
                        }
                    }else{
                        MyDraftlist.wishListShared.currentDraftlist = decodedDraftOrder.draftOrder
                    }
                    
                }
            }
        }
    }
    
    
    
    func putToDraftOrder(isCart:Bool){
        if(isCart){
            for myproduct in cartDraftOrder.currentDraftlist!.lineItems{
                if(myproduct.productID == product.id){
                    self.errorResult("This product is already in your cart.")
                    return
                }
            }
        }
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: product.variants[0].price)
        if isCart{
            cartDraftOrder.putLineItem(lineItem: lineItem,isCart: true)
        }else{
            wishlist.putLineItem(lineItem: lineItem,isCart: false)
        }
        
    }
    
    func deleteFavDraftOrder(){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        wishlist.deleteLineItem(lineItem: lineItem){
            
        }
    }
    
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
}



