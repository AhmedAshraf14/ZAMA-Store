//
//  OrdersViewModel.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import Foundation

class OrdersViewModell{
    var bindResultToViewController: (()->()) = {}
    var helper:NetworkServiceProtocol
    var orders: [Order] = []
    var customerID = 7341601423497
    
    init(){
        helper = NetworkService()
    }
    func getOrders() {
          
        helper.getData(path: "customers/\(customerID)/orders" ,parameters: ["status":"any"], model: OrdersResponse.self) { [weak self] data, error in
            if let data = data {
                self?.orders = data.orders ?? []
                print("-------------")
                print(self?.orders)
                self?.bindResultToViewController()
            }else{
                print(error!.localizedDescription)
            }
             
          }
      }
      
    
}

