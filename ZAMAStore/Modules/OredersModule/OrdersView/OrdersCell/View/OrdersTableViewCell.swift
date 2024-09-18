//
//  OrdersTableViewCell.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var OrderNumberLabel: UILabel!
    @IBOutlet weak var numberOfProductsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ordersView.layer.cornerRadius = 12
        ordersView.layer.borderWidth = 0.5
        ordersView.layer.borderColor = UIColor.mintGreen.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
