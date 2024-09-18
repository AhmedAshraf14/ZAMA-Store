//
//  viewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

class BrandsViewModel {
    var ReloadCV : (()->Void) = {}
    var navigateForward : (()->Void) = {}
    var brandsArray : [SmartCollection] = [] {
        didSet {
           ReloadCV()
        }
    }
    var PriceRuleArray : [PriceRule] = []
    
    var DiscountArray : [DiscountModel] = []{
        didSet{
            ReloadCV()
        }
    }
    var nwService:NetworkServiceProtocol
    init(){
        nwService = NetworkService()
    }
    func getBrands(){
        nwService.getData(path: "smart_collections", parameters: [:], model: BrandsResponse.self) { data, error in
            if let data = data {
                self.brandsArray = data.smartCollections!
            } else {
                print("error")
            }
        }
    }
    func getData(){
        nwService.getData(path: "price_rules", parameters: [:], model: PriceRuleResponse.self) { data, error in
            if let data = data {
                self.PriceRuleArray = data.priceRules
                
                for item in self.PriceRuleArray{
                    self.getData(id: item.id)
                }
            }
        }
    }
    func getData(id:Int){
        nwService.getData(path: "price_rules/\(id)/discount_codes", parameters: [:], model: DiscountResponse.self) { data, error in
            if let data = data {
                self.DiscountArray.append(contentsOf: data.discountCode)
            }
        }
    }
    
    
    

    
}
