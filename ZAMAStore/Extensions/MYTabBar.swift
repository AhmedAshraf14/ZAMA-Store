//
//  MYTabBar.swift
//  ZAMAStore
//
//  Created by zyad Baset on 17/09/2024.
//

import UIKit

class MYTabBar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // This delegate method gets called whenever a tab is selected
    func tabBarController(_tabBarController: UITabBarController, shouldSelectviewController: UIViewController) -> Bool {
        // Check if the third view controller is about to be selected
        if let viewControllers=tabBarController?.viewControllers,let index = viewControllers.firstIndex(of: shouldSelectviewController),index == 2 {
            let flag = UserDefaults.standard.bool(forKey: "flag")
            if !flag{
                return false
            }
            
        }
        return true
    }
}
