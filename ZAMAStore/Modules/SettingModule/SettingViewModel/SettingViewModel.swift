//
//  ViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
class SettingViewModel{
    let networkService:NetworkServiceProtocol
    var customer = MyAccount.shared.currentUser
    var reloadTV:(()->Void)={}
    init() {
        networkService = NetworkService()
    }
    func deleteAddress(index:Int){
        networkService.deleteData1(path: "customers/\(customer!.id)/addresses/\(customer!.addresses![index].id!)"){
            self.reloadUser()
        }
        
    }
    func reloadUser() {
        MyAccount.shared.reloadCustomer(){
            self.customer = MyAccount.shared.currentUser
            self.reloadTV()
        }
    }
    
    func putDefaultAddress(index:Int){
        let parameters: [String: Any] = [
            "customer_address": [
                "id": customer!.addresses![index].id!,
                "customer_id": customer!.id // Fixed the typo here
            ]
        ]
        networkService.postData(path: "customers/\(customer!.id)/addresses/\(customer!.addresses![index].id!)/default", parameters: parameters, postFlag: false) { data, error in
            // MyAccount.shared.reloadCustomer()
            self.reloadUser()
            
        }
        
    }
    
    func changeCurrency(from baseCurrency: String="EGP",to targetCurrency:String){
        if targetCurrency == baseCurrency {
            UserDefaults.standard.setValue(1.0, forKey: "rate")
            UserDefaults.standard.setValue(targetCurrency, forKey: "currency")
            return
        }
        let currencyParameters: [String:Any] = [
            "access_key": "dd0fb152-c4ee85fd-f1e4ca1a-941be63e",
            "from": baseCurrency,
            "to": targetCurrency,
            "amount": "1",
            
        ]
        networkService.getData(path: "convert", parameters: currencyParameters, model: ConversionResponse.self) { result, error in
            if let result = result{
                UserDefaults.standard.setValue(result.result.rate, forKey: "rate")
                UserDefaults.standard.setValue(targetCurrency, forKey: "currency")
            }else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func checkCurrency()->Int{
        guard let currency = UserDefaults.standard.string(forKey: "currency") else {return 0}
            switch currency {
            case "EGP":
                return 0
            case "EUR":
                return 1
            case "USD":
                return 2
            default:
                // Handle unknown currency, e.g., set to a default index
                return 0
            }
    }
}
