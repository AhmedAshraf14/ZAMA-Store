//
//  OrdersViewModel.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import Foundation

class OrdersViewModell{
    var bindResultToViewController: (()->()) = {}
    var orders: [Order] = []
    
    func formatDateStringToNumbers(_ dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
    func getCurrency()->(String,Double){
        if UserDefaults.standard.double(forKey: "rate") == 0{
            return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",1)
        }
        return (UserDefaults.standard.string(forKey: "currency") ?? "EGP",UserDefaults.standard.double(forKey: "rate"))
    }
    
}

