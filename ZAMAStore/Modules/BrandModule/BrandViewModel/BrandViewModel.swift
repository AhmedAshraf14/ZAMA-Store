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
    var brandsArray = [Brand(brandName: "ADIDAS", brandImage: "Adidas"),Brand(brandName: "VANS", brandImage: "Vans"),Brand(brandName: "SUPRA", brandImage: "Supra"),Brand(brandName: "TIMBERLAND", brandImage: "timperland"),Brand(brandName: "ASICS TIGER", brandImage: "asics"),Brand(brandName: "CONVERSE", brandImage: "Converse"),Brand(brandName: "DR MARTENS", brandImage: "Dr martens"),Brand(brandName: "FLEX FIT", brandImage: "FlexFit"),Brand(brandName: "NIKE", brandImage: "Nike"),Brand(brandName: "PALLADIUM", brandImage: "Palladium"),Brand(brandName: "PUMA", brandImage: "Puma"),Brand(brandName: "HERSCHEL", brandImage: "Herschel")]
    
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
    func getData(){
        nwService.getData(path: "price_rules", parameters: [:], model: PriceRuleResponse.self) { data, error in
            if let data = data {
                self.PriceRuleArray = data.priceRules
                print(data)
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
                print(data)
            }
        }
    }
    
    

    
}
