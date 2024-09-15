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
        lblTitle.text=viewModel.lineItem.title
        lblPrice.text=viewModel.lineItem.price
        lblVendor.text=viewModel.product.vendor
        lblCount.text="\(viewModel.lineItem.quantity)"
        stepperQuantity.value = Double(viewModel.lineItem.quantity)
        setupImage(imageUrl: viewModel.product.image?.src ?? "")
        
        
    }
    /*
     let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
     cell.viewModel=CartCellViewModel(lineItem:viewModel.draftOrders[indexPath.row] , index: indexPath.row)
     cell.setupImage(imageUrl: viewModel.products[indexPath.row].image.src)
     cell.lblTitle.text = viewModel.products[indexPath.row].title
     cell.lblPrice.text = "Price : \(viewModel.products[indexPath.row].variants[0].price)"
     cell.lblVendor.text = "Vendor : \(viewModel.products[indexPath.row].vendor)"
     cell.lblCount.text = "\(viewModel.draftOrders[indexPath.row].quantity)"
     cell.stepperQuantity.value = Double(viewModel.draftOrders[indexPath.row].quantity)
     cell.viewModel=CartCellViewModel(lineItem: viewModel.draftOrders[indexPath.row], index: indexPath.row)
     */
    
}
