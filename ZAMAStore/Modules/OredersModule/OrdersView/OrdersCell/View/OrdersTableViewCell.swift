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
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func detailsButtonA(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
