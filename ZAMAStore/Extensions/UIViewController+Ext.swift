//
//  UIViewController+Ext.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 04/09/2024.
//

import Foundation
import UIKit

extension UIViewController{
    func presentAlert(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    @objc func navigateToCartList(){
        let cartView = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
        cartView.viewModel.isCart=true
        self.navigationController?.pushViewController(cartView, animated: true)
    }
    @objc func navigateToWishList() {
        let favVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
        self.navigationController?.pushViewController(favVC, animated: true)
    }
    @objc func navigateToSearchList() {
//        let favVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
//        self.navigationController?.pushViewController(favVC, animated: true)
        #warning("Fix this Search button Ahmed Please")
        print("Search Button Clicked")
    }
    @objc func navigateToSetting() {
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        initialViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(initialViewController!, animated: true)
    }
    
    @objc
    func navigateToAdrres(){
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdressViewController") as! AdressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
