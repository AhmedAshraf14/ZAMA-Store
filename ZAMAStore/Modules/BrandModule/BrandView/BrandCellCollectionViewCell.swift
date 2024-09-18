//
//  BrandCellCollectionViewCell.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 03/09/2024.
//

import UIKit

class BrandCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 28
        brandName.text = "Adidas"
        brandImage.image = UIImage(systemName: "heart.fill")
    }
    

}
