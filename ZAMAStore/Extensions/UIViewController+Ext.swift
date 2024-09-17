//
//  UIViewController+Ext.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 04/09/2024.
//

import Foundation
import UIKit

extension UIViewController{
//    let us  = UserDefaults.standard
//    let flag = us.bool(forKey: "flag")
    var flag:Bool {
        let us  = UserDefaults.standard
        return us.bool(forKey: "flag")
    }
    func presentAlert(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func presentActionAlert(title: String, message: String, okAction: @escaping (()->Void)){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                okAction()
            } ))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func presentSignInAlert(){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Sign UP", message: "You need to sign in to use this feature", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                if let window = UIApplication.shared.windows.first {
                    let storyboard = UIStoryboard(name: "Main3", bundle: nil)
                    let newRootViewController = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
                    window.rootViewController = UINavigationController(rootViewController: newRootViewController)
                    window.makeKeyAndVisible()
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
                }
            } ))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    @objc func navigateToCartList(){
        if !self.flag{
            self.presentSignInAlert()
            return
        }
        let cartView = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
        cartView.viewModel.isCart=true
        self.navigationController?.pushViewController(cartView, animated: true)
    }
    @objc func navigateToWishList() {
        if !self.flag{
            self.presentSignInAlert()
            return
        }
        let favVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
        self.navigationController?.pushViewController(favVC, animated: true)
    }
    @objc func navigateToSearchList() {
        if type(of: self) == BrandView.self{
            let currentVC = tabBarController?.viewControllers![1] as! CategoriesViewController
            //currentVC.viewModel.isSearching = true
            currentVC.setupSearchNavBar()
            self.tabBarController!.selectedIndex = 1
        }else{
            let currentVC = tabBarController?.selectedViewController as! CategoriesViewController
            currentVC.setupSearchNavBar()
        }
    }
    @objc func navigateToSetting() {
        if !self.flag{
            self.presentSignInAlert()
            return
        }
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        initialViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(initialViewController!, animated: true)
    }
    
    @objc
    func navigateToAdrres(){
        if !self.flag{
            self.presentSignInAlert()
            return
        }
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdressViewController") as! AdressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
