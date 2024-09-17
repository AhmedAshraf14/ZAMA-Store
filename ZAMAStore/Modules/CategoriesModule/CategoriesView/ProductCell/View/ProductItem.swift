//
//  ProductItem.swift
//  ZAMAStore
//
//  Created by zyad Baset on 06/09/2024.
//

import UIKit
import SDWebImage
class ProductItem: UICollectionViewCell {

    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    var viewModel:ProductCellViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.cornerRadius = 10
    }
    
    /*
     func postFavDraftOrder(){
         let lineItem = LineItem(id: 0, variantID: product.variants[0].id, productID: product.id, title: product.title, quantity: 1, price: "")
         
         let favDraftOrder = DraftOrderResponseModel(draftOrder: DraftOrder(id: 0, lineItems: [lineItem], customer: DraftCustomer(id: user!.id), useCustomerDefaultAddress: true))
         
         let jsonObj = try? JSONEncoder().encode(favDraftOrder)
         let dic = try? JSONSerialization.jsonObject(with: jsonObj!, options: [])
         let paramaters = dic as! [String:Any]

         networkService.postData(path: "draft_orders", parameters: paramaters, postFlag: true) { result, error in
             if let data = result{
                 do{
                     let localdata = data as! [String:Any]
                     let draftOrder = localdata["draft_order"] as! [String:Any]
                     let id = draftOrder["id"] as! Int
                     let draftOrderResponseData = try! JSONSerialization.data(withJSONObject: data, options: [])
                     let decodedDraftOrder = try! JSONDecoder().decode(DraftOrderResponseModel.self, from: draftOrderResponseData)
                     #warning("احمد اشرف قال حط ورنينج هنا")
                     MyAccount.shared.putCustomer(draftOrderID: id)
                     MyDraftlist.wishListShared.currentDraftlist = decodedDraftOrder.draftOrder
                 }
                 catch{
                     print(error.localizedDescription)
                 }
             }
         }
     }
     */
    func showLbl(){
        warningLabel.isHidden.toggle()
    }
    @IBAction func addToCartAct(_ sender: Any) {
        
        if MyAccount.shared.currentUser.note==nil{
            viewModel?.postToCartDraftOrder()
        }
            else{
                viewModel?.putCartDraftOrder()
                viewModel?.showError = { 
                    self.showLbl()
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        self.showLbl()
                    }
                }
            }
        }
    
    func putData(){
        let currency = viewModel?.getCurrency()
        var convertedPrice = 0.0
        if let priceString = viewModel?.product.variants.first?.price,
           let price = Double(priceString) {
            convertedPrice = price * (currency?.1 ?? 1.0)
        }
        lblPrice.text = String(format: "%.2f", convertedPrice) + " \(currency?.0 ?? "")"
        lblTitle.text = viewModel?.product.title
        img.sd_setImage(with: URL(string: (viewModel?.product.image?.src ?? "")), placeholderImage: UIImage(named: "placeholder.png"))
    }

}
