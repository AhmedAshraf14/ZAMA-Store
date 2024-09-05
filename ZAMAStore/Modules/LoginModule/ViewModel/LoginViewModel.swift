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
                        self?.navigateForward()
                    }
                }
            }else {
                self?.noResult("Try again please")
            }
        }
    }
}
