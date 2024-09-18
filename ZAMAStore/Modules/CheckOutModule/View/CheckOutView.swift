//
//  CheckOutView.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 16/09/2024.
//

import UIKit

class CheckOutView: UIViewController {
    @IBOutlet weak var subTotalPriceLabel: UILabel!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var validateButton: UIButton!
    var viewModel : CheckOutViewModel!
    
    required init?(coder: NSCoder) {
        self.viewModel = CheckOutViewModel()
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.getOrder()
        couponTextField.addTarget(self, action: #selector(editTF), for: .editingChanged)
        let currency = self.viewModel?.getCurrency()
        viewModel.renderData = {
            var convertedSubPrice = 0.0
            var convertedTotalPrice = 0.0
            if let subTotalPriceString = self.viewModel.currentOrder?.subTotalPrice,
               let subTotalPrice = Double(subTotalPriceString),
               let totalPriceString = self.viewModel.currentOrder?.totalPrice,
               let totalPrice = Double(totalPriceString),
               let totalTaxString = self.viewModel.currentOrder?.totalTax,
               let totalTax = Double(totalTaxString){
                
                convertedSubPrice = subTotalPrice * (currency?.1 ?? 1.0)
                convertedTotalPrice = (totalPrice - totalTax) * (currency?.1 ?? 1.0)
                //convertedTotalTax = totalTax * (currency?.1 ?? 1.0)
            }
            self.subTotalPriceLabel.text = String(format: "%.2f", convertedSubPrice) + " \(currency?.0 ?? "")"
            self.totalPriceLabel.text = String(format: "%.2f", convertedTotalPrice) + " \(currency?.0 ?? "")"
            self.discountLabel.text = "0.0 %"
        }
        
        viewModel.errorResult = {error in
            self.presentAlert(title: "Warning", message: error, buttonTitle: "OK")
        }
        
        
    }
    
    @IBAction func validatePressed(_ sender: UIButton) {
        viewModel.getPriceRules {
            self.viewModel.checkCoupon(code: self.couponTextField.text ?? "")
        }
        viewModel.validCode = { amount in
            let currency = self.viewModel?.getCurrency()
            let oldPriceString = self.totalPriceLabel.text?.replacingOccurrences(of: " EGP", with: "").replacingOccurrences(of: " EUR", with: "").replacingOccurrences(of: " USD", with: "")
            let oldPrice = Double(oldPriceString!)!
            let newAmount = Double(amount)!
            let newPrice = oldPrice * (newAmount * -1 / 100)
    
            self.discountLabel.text = "\(newAmount * -1)%"
            self.totalPriceLabel.text = String(format: "%.2f", newPrice) + " \(currency?.0 ?? "")"
            self.validateButton.isEnabled = false
        }
    }
    
    @objc func editTF(){
        viewModel.renderData()
        self.validateButton.isEnabled = true
    }
    
    @IBAction func continueToPaymentPressed(_ sender: UIButton) {
        let paymentVC = UIStoryboard(name: "Main4", bundle: nil).instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
        paymentVC.viewModel = PayViewModel(discountCode: couponTextField.text ?? "", amount: discountLabel.text!, totalPrice: self.totalPriceLabel.text ?? "")
        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
}

extension CheckOutView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = viewModel.items[indexPath.row].title
        (cell.viewWithTag(2) as! UILabel).text = "Quantity : \(viewModel.items[indexPath.row].quantity)"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your cart items"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}


extension CheckOutView : UITextFieldDelegate{
    
}
