//
//  viewModel.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import Foundation

class CategoriesViewModel{
    var ReloadCV : (()->Void) = {}
    var navigateForward : (()->Void) = {}
    var products:[ProductModel]=[]
    var allProducts:[ProductModel]=[]
    var productsTypeArray:[ProductModel]=[]
    var nwService:NetworkServiceProtocol
    var isBrand : Bool = false
    var BrandOfDataString = ""
    init(){
        nwService = NetworkService()
    }
    //func check
    
    func getData(param : [String : Any] = [:]) {
        nwService.getData(path: "products", parameters: param, model: ProductResponse.self) {[weak self] data, error in
            if let data = data{
                self?.products = data.products
                self?.allProducts = data.products
                self?.ReloadCV()
            }else{
                print(error!.localizedDescription)
            }
            
        }
    }
    func filterData(type:String,tag:String){
        filterData1(tag: tag)
        if(type=="All"){
            products = productsTypeArray
        }else{
            for product in productsTypeArray{
                if (product.productType.rawValue == type){
                    products.append(product)
                }
            }
            //products = productsTypeArray
        }
        ReloadCV()
    }
   
    func filterData1(tag:String){
        productsTypeArray=[]
        products=[]
        if(tag=="All"){
            productsTypeArray = allProducts
        }else{
            for product in allProducts{
                if (product.tags.localizedStandardContains(tag)){
                    productsTypeArray.append(product)
                }
            }
            //products = productsTypeArray
        }
    }
}
