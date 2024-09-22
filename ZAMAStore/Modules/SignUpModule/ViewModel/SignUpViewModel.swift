//
//  SignUpViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import FirebaseAuth

class SignUpViewModel{
    
    var networkService : NetworkServiceProtocol!
    var noResult : ((String)->Void) = {error in }
    var navigate : (()->Void) = {}
    
    init() {
        self.networkService = NetworkService()
    }
    
    func createCustomer(customer: Customer){
        if !isValidName(customer.firstName!) {
            self.noResult(ValidationError.invalidFirstName.rawValue)
            return
        }
        
        if !isValidName(customer.lastName!) {
            self.noResult(ValidationError.invalidLastName.rawValue)
            return
        }
        
        if !isValidEmail(customer.email) {
            self.noResult(ValidationError.invalidEmail.rawValue)
            return
        }
        
        if !isValidPhone(customer.phone!) {
            self.noResult(ValidationError.invalidPhone.rawValue)
            return
        }
        
        if !isValidPassword(customer.password!) {
            self.noResult(ValidationError.invalidPassword.rawValue)
            return
        }
        Auth.auth().createUser(withEmail: customer.email, password: customer.password!) { [weak self] authResult, error in
            if let error = error {
                self?.noResult(error.localizedDescription)
                return
            }
            
            let paramater : [String:Any] =
            ["customer":
                [
                    "first_name": customer.firstName!,
                    "last_name": customer.lastName!,
                    "email": customer.email,
                    "phone": customer.phone!,
                    "addresses": customer.addresses ?? [],
                    "password": customer.password!,
                    "password_confirmation": customer.password!,
                    "send_email_welcome": false,
                    "verified_email": true,
                ]
            ]
            self?.networkService.postData(path: "customers", parameters: paramater, postFlag: true) { [weak self]result, error in
                if let error = error{
                    self?.noResult("phone already registerd for another account")
                }else {
                    self?.navigate()
                }
            }
        }
    }
    
    private func isValidName(_ name: String) -> Bool {
        let regex = "^[A-Za-z]{4,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool{
        let passwordRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    private func isValidPhone(_ phone: String) -> Bool{
        let phoneRegEx = "^01[0-9]\\d{8}$"
        
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    
}
