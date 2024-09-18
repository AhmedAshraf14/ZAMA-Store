//
//  CurrencyRate.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 16/09/2024.
//

import Foundation

class CurrencyRate{
    let sharedRate = CurrencyRate()
    private init(){
        conversionRate = nil
    }
    let conversionRate : Double?
}
