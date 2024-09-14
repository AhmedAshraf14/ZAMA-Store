//
//  BrandCollectionViewCell.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 03/09/2024.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var brandName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setupShadow()
    }
//    private func setupShadow(){
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 5)
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.5
//        self.layer.masksToBounds = false
//    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.borderColor = UIColor.mintGreen.cgColor
        self.layer.borderWidth = 1
    }
}
