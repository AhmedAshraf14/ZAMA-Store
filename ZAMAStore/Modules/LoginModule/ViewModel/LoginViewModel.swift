//
//  LoginViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import FirebaseAuth
class LoginViewModel{
    var networkService : NetworkServiceProtocol!
    var noResult : ((String)->Void) = {error in }
    var navigateForward : (()->Void) = {}
    let us = UserDefaults.standard
    
    init() {
        self.networkService = NetworkService()
    }
    
    func isValidAccount(email: String, password: String){
        networkService.getData(path: "customers/search", parameters: ["query":"email:\(email)"], model: CustomersResponse.self) {[weak self] result, error in
            if let result = result{
                Auth.auth().signIn(withEmail: result.customers[0].email, password: password) { [weak self] authresult, error in
                    if let _ = error{
                        self?.noResult("email or password is Incorrect")
                    }else {
                        MyAccount.shared.currentUser = result.customers[0]
                        self?.setUpLoginData(password: password)
                        self?.navigateForward()
                    }
                }
            }else {
                self?.noResult("Try again please")
            }
        }
    }
    
    func setUpLoginData(password:String){
        us.setValue(MyAccount.shared.currentUser.email, forKey: "email")
        us.setValue(password, forKey: "password")
        us.setValue(true, forKey: "flag")
        us.setValue(MyAccount.shared.currentUser.currency ?? "EGP", forKey: "currency")
        us.setValue(1.0, forKey: "rate")
    }
}
