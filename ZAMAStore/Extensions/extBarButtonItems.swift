//
//  extBarButtonItems.swift
//  ZAMAStore
//
//  Created by zyad Baset on 11/09/2024.
//

import Foundation
import UIKit
extension UIBarButtonItem{
    static func heartButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: target, action: action)
    }
    static func gearButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: target, action: action)
    }
    static func cartButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: target, action: action)
    }
    static func pencilButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: target, action: action)
    }
    static func searchButton(target:Any,action:Selector)->UIBarButtonItem{
        return UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: target, action: action)
    }
}
