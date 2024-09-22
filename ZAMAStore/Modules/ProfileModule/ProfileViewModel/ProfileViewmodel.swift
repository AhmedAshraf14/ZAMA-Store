//
//  viewmodel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import FirebaseAuth
class MyAccount{
    static let shared=MyAccount()
    var currentUser:Customer!
    var networkService:NetworkServiceProtocol
    var orders: [Order] = []
    var reloadTv : (()->Void) = {}
    private init() {
        networkService = NetworkService()
    }
    func reloadCustomer(handler:@escaping()->Void){
        NetworkService().getData(path: "customers/search", parameters: ["query":"email:\(currentUser.email)"], model: CustomersResponse.self) { data, error in
            MyAccount.shared.currentUser = data?.customers[0]
            handler()
        }
    }
    
    func putCustomer(draftOrderID:Int,attribute:String="tags"){
        let str:String? = attribute == "tags" ? "" : nil
        let paramaters : [String:Any] = ["customer":["id":currentUser!.id,attribute: draftOrderID==0 ? str : "\(draftOrderID)"]]
        networkService.postData(path: "customers/\(currentUser!.id)", parameters: paramaters, postFlag: false) { result, error in
            MyAccount.shared.reloadCustomer {
                
            }
        }
    }
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
    
    func getOrders() {
          
        networkService.getData(path: "customers/\(currentUser!.id)/orders" ,parameters: ["status":"any"], model: OrdersResponse.self) { [weak self] data, error in
            if let data = data {
                self?.orders = data.orders
                self?.reloadTv()
            }else{
                print(error!.localizedDescription)
            }
          }
      }
}
