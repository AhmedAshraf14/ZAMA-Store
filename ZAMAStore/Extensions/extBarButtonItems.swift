//
//  extBarButtonItems.swift
//  ZAMAStore
//
//  Created by zyad Baset on 11/09/2024.
//

import Foundation
import UIKit
extension UIBarButtonItem{
    static func heartButton(target:UIViewController)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: target, action: #selector(target.navigateToWishList))
    }
    
    static func gearButton(target:UIViewController)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: target, action: #selector(target.navigateToSetting))
    }
    static func cartButton(target:UIViewController)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: target, action: #selector(target.navigateToCartList))
    }
    static func pencilButton(target:UIViewController)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: target, action:#selector(target.navigateToAdrres))
    }
    #warning("متنساش تظبط الحته ديه")
    static func searchButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: target, action: action)
    }
}
