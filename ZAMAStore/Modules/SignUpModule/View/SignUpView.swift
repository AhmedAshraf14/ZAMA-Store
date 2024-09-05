//
//  SignUpView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class SignUpView: UIViewController {
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel : SignUpViewModel!
    var isHiddenEye = true
    
    required init?(coder: NSCoder) {
        self.viewModel = SignUpViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel.noResult = { [weak self] error in
            self?.presentAlert(title: "Validation Error", message: error, buttonTitle: "OK")
        }
        viewModel.navigate = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        guard let firstName = fNameTextField.text, !firstName.isEmpty,
              let lastName = lNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            self.presentAlert(title: "Validation Error", message: "All fields are required", buttonTitle: "OK")
            return
        }
        
        let customer = Customer(id: 0, email: email, firstName: firstName, lastName: lastName, ordersCount: 0, totalSpent: "0", lastOrderID: nil, lastOrderName: nil, phone: phone, addresses: nil, defaultAddress: nil, password: password)
        
        viewModel.createCustomer(customer: customer)
    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showAndUnshowPassword(_ sender: UIButton) {
        if isHiddenEye{
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
            isHiddenEye = false
        }else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            isHiddenEye = true
        }
        passwordTextField.isSecureTextEntry.toggle()
    }
    
}
