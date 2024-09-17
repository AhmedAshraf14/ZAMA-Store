//
//  DraftOrder.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import Foundation





//MARK: - Draft Func
class MyDraftlist{
    var currentDraftlist: DraftOrder?
    var networkService:NetworkServiceProtocol
    private init() {
        networkService = NetworkService()
    }
    // Put New Line Item
    func putLineItem(lineItem:LineItem,isCart:Bool){
        //append line item to currentLineItem
        currentDraftlist?.lineItems.append(lineItem)
        //making Response and encode it
        let response = DraftOrderResponseModel(draftOrder: currentDraftlist!)
        let jsonObj = try? JSONEncoder().encode(response)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let newLineItems = dic as? [String:Any]
         // put data to network
        networkService.postData(path: "draft_orders/\(currentDraftlist!.id)", parameters: newLineItems ?? [:], postFlag: false) { result, error in
            // reload data if it cart
            if isCart{
                self.reloadCart(){
                    
                }
            }
            
        }
    }
    
    func deleteWholeDraftOrder(attribute:String,handler:@escaping()->Void){
        networkService.deleteData(path: "draft_orders/\(currentDraftlist!.id)")
        currentDraftlist = nil
        #warning("خلي بالك من الحته ديه")
        MyAccount.shared.putCustomer(draftOrderID: 0,attribute: attribute)
        MyAccount.shared.reloadCustomer {
            if attribute == "note"{
                handler()
            }
        }
    }
    // delete line item inside draftorder
    func deleteLineItem(lineItem:LineItem,attribute:String="tags",handler:@escaping()->Void){
        // check if this last line item so delete it and update customer note or tag
        if currentDraftlist?.lineItems.count == 1{
            deleteWholeDraftOrder(attribute: attribute, handler: handler)
        }else{
            currentDraftlist?.lineItems.removeAll { item in
                item.variantID == lineItem.variantID
            }
            let response = DraftOrderResponseModel(draftOrder: currentDraftlist!)
            let jsonObj = try? JSONEncoder().encode(response)
            let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
            let newLineItems = dic as? [String:Any]
            
            networkService.postData(path: "draft_orders/\(currentDraftlist!.id)", parameters: newLineItems ?? [:], postFlag: false) { result, error in
                if attribute == "note"{
                    self.reloadCart(){
                        handler()
                    }
                    
                }
            }
        }
    }
}

//MARK: - CartList Func
extension MyDraftlist{
    static let cartListShared=MyDraftlist()
    // Change the quantity inside Cart draft orders
    func putQuantity(quantity:Int,index:Int,handler:@escaping(()->Void)) {
        currentDraftlist?.lineItems[index].quantity=quantity
        let response = DraftOrderResponseModel(draftOrder: currentDraftlist!)
        let jsonObj = try? JSONEncoder().encode(response)
        let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
        let newLineItems = dic as? [String:Any]
        networkService.postData(path: "draft_orders/\(currentDraftlist!.id)", parameters: newLineItems ?? [:], postFlag: false) { result, error in
            self.reloadCart(){
                handler()
            }
            
        }
    }
    // reloading card after any update
    func reloadCart(handler:@escaping(()->Void)){
        networkService.getDraftOrders(path: "draft_orders/\(currentDraftlist!.id)", parameters: [:]) { result, error in
            if let result = result {
                self.settingDraftlist(data: result,draftList:  MyDraftlist.cartListShared )
                handler()
            }else {
                print(error!.localizedDescription)
            }
        }
    }
    // using to fix json file when getting data
    #warning("الفانكشن ديه موجوده هنا و السين ديلجات يبقي حطها ف الجيمنيرال ")
    func settingDraftlist(data:Data,draftList:MyDraftlist){
        do{
            if let dataString = String(data: data, encoding: .utf8){
                if let jsonData = dataString.data(using: .utf8) {
                    let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: [])
                    let fixedJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    if let jsonString = String (data: fixedJsonData, encoding: .utf8) {
                        let ourJson = jsonString.data(using: .utf8)
                        let draft = try! JSONDecoder().decode(DraftOrderResponseModel.self, from: ourJson!)
                        draftList.currentDraftlist = draft.draftOrder
                    }
                }
            }
        }
    }
    
}
//MARK: - WishList Func
extension MyDraftlist{
    static let wishListShared=MyDraftlist()
}
