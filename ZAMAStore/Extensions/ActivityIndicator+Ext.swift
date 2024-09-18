//
//  ActivityIndicator+Ext.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 17/09/2024.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {

    // Set up the activity indicator
    func setupActivityIndicator(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.color = .mintGreen
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.isHidden = true
    }

    // Show the activity indicator with animation
    func showActivityIndicator() {
       // UIView.animate(withDuration: 0.3) {
            self.isHidden = false
            self.startAnimating()
       // }
    }

    // Hide the activity indicator with animation
    func hideActivityIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.stopAnimating()
            self.isHidden = true
        }
    }
}

