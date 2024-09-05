//
//  DiscountCell.swift
//  ZAMAStore
//
//  Created by zyad Baset on 04/09/2024.
//

import UIKit

class DiscountCell: UICollectionViewCell {

    @IBOutlet weak var imgBC: UIImageView!
    @IBOutlet weak var copiedCode: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        copiedCode.isHidden = true
        // Initialization code
    }
    func showLbl(){
        copiedCode.isHidden.toggle()
    }

}
