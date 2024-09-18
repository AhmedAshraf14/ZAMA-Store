//
//  CartCell.swift
//  ZAMAStore
//
//  Created by zyad Baset on 13/09/2024.
//

import UIKit
import RxSwift
import RxCocoa
class CartCell: UITableViewCell {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var stepperQuantity: UIStepper!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVendor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cartImg: UIImageView!
    var viewModel:CartCellViewModel!
    var dispose:DisposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stepperChange()
    }
    func stepperChange(){
        stepperQuantity.rx.value.changed.debounce(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(queue: .global())).subscribe { value in
            self.viewModel.updateQuantity(quantity: Int(value))
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("Disposed")
        }.disposed(by: dispose)

    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        lblCount.text = "\(Int(sender.value))"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupImage(imageUrl : String){
        cartImg.sd_setImage(with: URL(string: imageUrl))
    }
    
    func setUpCell(){
        let currency = viewModel?.getCurrency()
        var convertedPrice = 0.0
        if let priceString = viewModel.lineItem.price,
           let price = Double(priceString) {
            convertedPrice = price * (currency?.1 ?? 1.0)
        }
        lblPrice.text = String(format: "%.2f", convertedPrice) + " \(currency?.0 ?? "")"
        
        lblTitle.text=viewModel.lineItem.title
        lblVendor.text=viewModel.product.vendor
        lblCount.text="\(viewModel.lineItem.quantity)"
        stepperQuantity.value = Double(viewModel.lineItem.quantity)
        setupImage(imageUrl: viewModel.product.image?.src ?? "")
        
        
    }
    
}
