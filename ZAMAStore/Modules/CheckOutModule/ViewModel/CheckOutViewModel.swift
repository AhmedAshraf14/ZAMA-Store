//
//  CheckOutView.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 16/09/2024.
//

import Foundation

class CheckOutViewModel{
    var currentOrder : DraftOrder!
    var networkService : NetworkServiceProtocol!
    var renderData : (()->Void)?
    var items : [LineItem]!
    init() {
        self.networkService = NetworkService()
    }
    
    func getOrder(){
        let draftOrderID = MyDraftlist.cartListShared.currentDraftlist?.id
        networkService.getDraftOrders(path: "draft_orders/\(draftOrderID ?? 0)", parameters: [:]) { data, error in
            if let data = data{
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let fixedJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    
                    let draftOrder = try JSONDecoder().decode(DraftOrderResponseModel.self, from: fixedJsonData)
                    self.currentOrder = draftOrder.draftOrder
                    self.renderData!()
                } catch {
                    print("Error decoding draft list: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func checkCoupon(code:String){
        
    }
    
    func getCurrency()->(String,Double){
        return (UserDefaults.standard.string(forKey: "currency")!,UserDefaults.standard.double(forKey: "rate"))
    }
}


