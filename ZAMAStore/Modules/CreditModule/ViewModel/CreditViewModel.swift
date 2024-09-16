//
//  PaymentViewModel.swift
//  ZAMAStore
//
//  Created by zyad Baset on 16/09/2024.
//

import Foundation
class CreditViewModel{
    var changeCardType:(cardType)->Void={_ in}
    
    
    func detectCardType(from cardNumber: String) {
        // Remove any spaces or dashes from the card number
        let cleanedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        
        // Check if the cleaned card number is long enough
        guard cleanedCardNumber.count >= 4 else {
            changeCardType(.error)
            return
        }
        
        // Visa cards start with 4
        if cleanedCardNumber.hasPrefix("4") {
            changeCardType(.visa)
        }
        // MasterCard starts with numbers in the range 51 to 55 or 2221 to 2720
        else if let firstTwoDigits = Int(cleanedCardNumber.prefix(2)), (51...55).contains(firstTwoDigits) {
            changeCardType(.master)
        } else if let firstFourDigits = Int(cleanedCardNumber.prefix(4)), (2221...2720).contains(firstFourDigits) {
            changeCardType(.master)
        }
        // American Express starts with 34 or 37
        else if cleanedCardNumber.hasPrefix("34") || cleanedCardNumber.hasPrefix("37") {
            changeCardType(.american)
        }
        
        
        // If no known patterns match, return nil
        changeCardType(.error)
    }
    
    func checkExpireData(text:String)->Bool{
        let arr = text.split(separator: "/")
        if Int(arr[0])!>=1 && Int(arr[0])!<=12{
            return true
        }else{
            return false
        }
    }
    
}

enum cardType:String {
case american = "American"
    case visa = "Visa"
    case master = "Master"
    case error = "Error"
}
