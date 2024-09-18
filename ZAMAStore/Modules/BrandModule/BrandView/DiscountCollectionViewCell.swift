//
//  DiscountCollectionViewCell.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 03/09/2024.
//

import UIKit

class DiscountCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discountImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        discountImage.image = UIImage(systemName: "heart")
    }

}
