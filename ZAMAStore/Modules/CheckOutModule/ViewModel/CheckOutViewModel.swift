//
//  CheckOutView.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 16/09/2024.
//

import Foundation

class CheckOutViewModel{
    var currentOrder = MyDraftlist.cartListShared.currentDraftlist
    var networkService : NetworkServiceProtocol!
    var renderData : (()->Void) = {}
    var validCode : ((String)->Void) = {amount in}
    var PriceRuleArray : [PriceRule] = []
    var errorResult : ((String)-> Void) = {error in}
    var items : [LineItem] = MyDraftlist.cartListShared.currentDraftlist?.lineItems ?? []
    init() {
        self.networkService = NetworkService()
    }
    
    func getOrder(){
        let draftOrderID = MyDraftlist.cartListShared.currentDraftlist?.id
        MyDraftlist.cartListShared.reloadCart {
            self.renderData()
        }
        
    }
    
    func getPriceRules(handler: @escaping (()->Void)){
        networkService.getData(path: "price_rules", parameters: [:], model: PriceRuleResponse.self) { data, error in
            if let data = data {
                self.PriceRuleArray = data.priceRules
                handler()
            }else {
                self.errorResult("Error in connection")
            }
        }
    }
    
    func checkCoupon(code:String){
        for ruleCode in PriceRuleArray {
            if code == ruleCode.title {
                self.validCode(ruleCode.value ?? "0")
                return
            }
        }
        self.errorResult("Not Valid Coupon")
    }
    
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
}


