//
//  LoginView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class LoginView: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var viewModel : LoginViewModel!
    var isHiddenEye = true
    
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel.noResult = {error in
            self.presentAlert(title: "SignIn Error", message: error, buttonTitle: "OK")
        }
        viewModel.navigateForward = {
            
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateInitialViewController()
            initialViewController?.modalPresentationStyle = .fullScreen
            self.present(initialViewController!, animated: true, completion: nil)
        }

    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            self.presentAlert(title: "Validation Error", message: "All fields are required", buttonTitle: "OK")
            return
        }
        viewModel.isValidAccount(email: emailTextField.text!, password: passwordTextField.text!)
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
