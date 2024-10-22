//
//  WishListCellViewModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 14/09/2024.
//

import Foundation
class WishListCellViewModel{
    var showError:((String)->Void)={error in }
    var networkService:NetworkServiceProtocol
    var product:ProductModel
    var cartDraftOrder = MyDraftlist.cartListShared
    
    init(product:ProductModel){
        networkService = NetworkService()
        self.product = product
    }
    func postToCartDraftOrder(){
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        let cartDraftOrder = DraftOrderResponseModel(draftOrder: DraftOrder(id: 0, lineItems: [lineItem], customer: DraftCustomer(id: MyAccount.shared.currentUser.id), useCustomerDefaultAddress: true))
        MyDraftlist.cartListShared.currentDraftlist = DraftOrder(id: 0, lineItems: [], customer: DraftCustomer(id: MyAccount.shared.currentUser.id), useCustomerDefaultAddress: true)
        
        let jsonObj = try? JSONEncoder().encode(cartDraftOrder)
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
                         // #warning("احمد اشرف قال حط ورنينج هنا")
                    MyAccount.shared.putCustomer(draftOrderID: decodedDraftOrder.draftOrder.id,attribute: "note")
                    
                    MyDraftlist.cartListShared.currentDraftlist?.id=id
                    MyDraftlist.cartListShared.reloadCart(){
                        
                    }
                }
              
            }
        }
        
        
        
    }
    
    func putCartDraftOrder(){
        for myproduct in cartDraftOrder.currentDraftlist!.lineItems{
            if(myproduct.productID == product.id){
                showError("This product Already Exist")
                return
            }
        }
        let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
        cartDraftOrder.putLineItem(lineItem: lineItem,isCart: true)
    }
    
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
}
