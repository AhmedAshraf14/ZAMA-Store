//
//  LoginView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit
import GoogleSignIn


class LoginView: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var viewModel : LoginViewModel!
    var isHiddenEye = true
    
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.setupActivityIndicator(in: view)
        setupViewModel()
    }
    
    
    
    @IBAction func guestBtnAction(_ sender: Any) {
        viewModel.navigateForward()
    }
    
    
    
    private func setupViewModel(){
        viewModel.configureGoogleSignIn()
        viewModel.noResult = {error in
            self.activityIndicator.hideActivityIndicator()
            self.presentAlert(title: "SignIn Error", message: error, buttonTitle: "OK")
        }
        viewModel.navigateForward = {
            
            self.activityIndicator.hideActivityIndicator()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            initialViewController?.modalPresentationStyle = .fullScreen
            self.present(initialViewController!, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func signinPressed(_ sender: UIButton) {
        self.activityIndicator.showActivityIndicator()
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
    
    
    @IBAction func signWithGooglePressed(_ sender: UIButton) {
        viewModel.signInWithGoogle(view: self)
    }
}
