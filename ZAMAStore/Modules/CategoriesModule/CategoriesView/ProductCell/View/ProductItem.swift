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
    var viewModel:ProductCellViewModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.layer.cornerRadius = 10
    }
    func putData(){
        lblPrice.text = viewModel?.product.variants.first?.price
        lblTitle.text = viewModel?.product.title
        img.sd_setImage(with: URL(string: (viewModel?.product.image.src)!)!, placeholderImage: UIImage(named: "placeholder.png"))
    }

}
