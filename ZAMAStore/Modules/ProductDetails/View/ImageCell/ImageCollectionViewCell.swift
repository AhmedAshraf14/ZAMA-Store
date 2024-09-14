//
//  ImageCollectionViewCell.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 09/09/2024.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.clipsToBounds = true
    }
    
    func setupCell(imageUrl : String){
        imageView.sd_setImage(with: URL(string: imageUrl))
    }

}
