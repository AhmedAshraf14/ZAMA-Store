//
//  LoginViewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewModel {
    var networkService: NetworkServiceProtocol!
    var noResult: ((String) -> Void) = { _ in }
    var navigateForward: (() -> Void) = {}
    let userDefaults = UserDefaults.standard
    
    init() {
        self.networkService = NetworkService()
    }
    
    func isValidAccount(email: String, password: String) {
        let parameters = ["query": "email:\(email)"]
        
        networkService.getData(path: "customers/search", parameters: parameters, model: CustomersResponse.self) { [weak self] result, error in
            guard let result = result else {
                self?.noResult("Try again please")
                return
            }
            
            self?.signInWithEmail(result: result, password: password)
        }
    }
    
    private func signInWithEmail(result: CustomersResponse, password: String) {
        let customerEmail = result.customers[0].email
        
        Auth.auth().signIn(withEmail: customerEmail, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.noResult("Email or password is incorrect")
                return
            }
            
            MyAccount.shared.currentUser = result.customers[0]
            self?.setUpLoginData(password: password)
            self?.navigateForward()
        }
    }
    
    private func setUpLoginData(password: String) {
        let currentUser = MyAccount.shared.currentUser
        userDefaults.setValue(currentUser!.email, forKey: "email")
        userDefaults.setValue(password, forKey: "password")
        userDefaults.setValue(true, forKey: "flag")
        userDefaults.setValue(currentUser?.currency ?? "EGP", forKey: "currency")
        userDefaults.setValue(1.0, forKey: "rate")
    }
    
    func configureGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    func signInWithGoogle(view: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: view) { [weak self] result, error in
            if let error = error {
                self?.noResult("Error signing in with Google")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self?.noResult("Google sign-in failed")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            self?.signInGoogle(credential: credential)
        }
    }
    
    private func signInGoogle(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let authResult = authResult, error == nil else {
                self?.noResult("Error signing in with Google")
                return
            }
            self?.fetchCustomerOrCreate(authResult: authResult)
        }
    }
    
    private func fetchCustomerOrCreate(authResult: AuthDataResult) {
        let parameters = ["query": "email:\(authResult.user.email ?? "N/A")"]
        
        networkService.getData(path: "customers/search", parameters: parameters, model: CustomersResponse.self) { [weak self] result, error in
            if let result = result {
                self?.handleExistingGoogleCustomer(result: result)
            } else {
                self?.createNewGoogleCustomer(authResult: authResult)
            }
        }
    }
    
    private func handleExistingGoogleCustomer(result: CustomersResponse) {
        MyAccount.shared.currentUser = result.customers[0]
        setUpLoginData(password: "")
        userDefaults.setValue(true, forKey: "isGoogle")
        navigateForward()
    }
    
    private func createNewGoogleCustomer(authResult: AuthDataResult) {
        let parameters: [String: Any] = [
            "customer": [
                "first_name": authResult.user.displayName ?? "N/A",
                "last_name": authResult.user.displayName ?? "N/A",
                "email": authResult.user.email ?? "N/A",
                "phone": "01000000001",
                "addresses": [],
                "password": "",
                "password_confirmation": "",
                "send_email_welcome": false,
                "verified_email": true
            ]
        ]
        
        networkService.postData(path: "customers", parameters: parameters, postFlag: true) { [weak self] result, error in
            if let error = error {
                self?.noResult("Error creating new customer")
            } else {
                self?.setUpNewGoogleCustomer(authResult: authResult)
            }
        }
    }
    
    private func setUpNewGoogleCustomer(authResult: AuthDataResult) {
        let customer = Customer(id: 0, email: authResult.user.email ?? "N/A", firstName: authResult.user.displayName ?? "N/A",
                                lastName: authResult.user.displayName ?? "N/A", ordersCount: 0, totalSpent: "0",
                                lastOrderID: nil, lastOrderName: nil, currency: "", note: nil, tags: "",
                                phone: "01000000001", addresses: nil, defaultAddress: nil, password: "")
        
        MyAccount.shared.currentUser = customer
        setUpLoginData(password: "")
        userDefaults.setValue(true, forKey: "isGoogle")
        navigateForward()
    }
}
