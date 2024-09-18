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
        copiedCode.alpha = 0.0
        copiedCode.clipsToBounds = true
        copiedCode.layer.cornerRadius = 20
    }
    func showLbl(){
        copiedCode.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

     
            UIView.animate(withDuration: 1.0, animations: {
                self.copiedCode.alpha = 1.0  // Fade in
                self.copiedCode.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) {[weak self] _ in
                
                UIView.animate(withDuration: 1.0, animations: {
                    self?.copiedCode.alpha = 0.0
                    self?.copiedCode.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                })
            }
    }
    
    func setupCell(index:Int){
        imgBC.image = UIImage(named: viewModel.images[index%4])
    }

}
