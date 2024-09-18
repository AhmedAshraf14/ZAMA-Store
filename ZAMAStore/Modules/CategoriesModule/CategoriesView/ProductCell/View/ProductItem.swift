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
    var vc : CategoriesViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.cornerRadius = 10
    }
    func showLbl(){
        warningLabel.isHidden.toggle()
    }
    @IBAction func addToCartAct(_ sender: Any) {
        if(!vc.flag){
            vc.presentSignInAlert()
            return
        }
        
        if MyAccount.shared.currentUser.note==nil{
            viewModel?.postToCartDraftOrder()
        }
            else{
                viewModel?.putCartDraftOrder()
                viewModel?.showError = {
                    self.vc.presentAlert(title: "Warning", message: "this product already exist in cart", buttonTitle: "OK")
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
