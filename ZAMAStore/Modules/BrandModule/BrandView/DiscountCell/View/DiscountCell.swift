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
    var viewModel = DiscountViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        copiedCode.isHidden = true
        // Initialization code
        copiedCode.layer.cornerRadius = 20
        copiedCode.layer.opacity = 1
    }
    func showLbl(){
        copiedCode.isHidden.toggle()
    }
    
    func setupCell(index:Int){
        imgBC.image = UIImage(named: viewModel.images[index%4])
    }

}
