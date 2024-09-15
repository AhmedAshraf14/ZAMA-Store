//
//  WishlistCell.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import UIKit

class WishlistCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productVendorLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    var viewModel:WishListCellViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupImage(imageUrl : String){
        productImageView.sd_setImage(with: URL(string: imageUrl))
    }
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        if MyAccount.shared.currentUser.note==nil{
            viewModel?.postToCartDraftOrder()
        }
            else{
                viewModel?.putCartDraftOrder()
            }
    }
    func setupCell(){
        setupImage(imageUrl: viewModel.product.image?.src ?? "")
        productNameLabel.text=viewModel.product.title
        productPriceLabel.text=viewModel.product.variants[0].price
        productVendorLabel.text=viewModel.product.vendor
    }
    
}
