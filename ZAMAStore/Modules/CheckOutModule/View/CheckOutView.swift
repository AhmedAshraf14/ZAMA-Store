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
    @IBOutlet weak var totalTax: UILabel!
    @IBOutlet weak var tableView: UITableView!
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
        let currency = self.viewModel?.getCurrency()
        self.discountLabel.text = "0.00" + " \(currency?.0 ?? "")"
        viewModel.renderData = {
            var convertedSubPrice = 0.0
            var convertedTotalPrice = 0.0
            var convertedTotalTax = 0.0
            if let subTotalPriceString = self.viewModel.currentOrder?.subTotalPrice,
               let subTotalPrice = Double(subTotalPriceString),
               let totalPriceString = self.viewModel.currentOrder?.totalPrice,
               let totalPrice = Double(totalPriceString),
               let totalTaxString = self.viewModel.currentOrder?.totalTax,
               let totalTax = Double(totalTaxString){
                
                convertedSubPrice = subTotalPrice * (currency?.1 ?? 1.0)
                convertedTotalPrice = totalPrice * (currency?.1 ?? 1.0)
                convertedTotalTax = totalTax * (currency?.1 ?? 1.0)
            }
            self.subTotalPriceLabel.text = String(format: "%.2f", convertedSubPrice) + " \(currency?.0 ?? "")"
            self.totalPriceLabel.text = String(format: "%.2f", convertedTotalPrice) + " \(currency?.0 ?? "")"
            self.totalTax.text = String(format: "%.2f", convertedTotalTax) + " \(currency?.0 ?? "")"
        }
        
        
    }
    
    @IBAction func validatePressed(_ sender: UIButton) {
    }
    
    @IBAction func continueToPaymentPressed(_ sender: UIButton) {
        let paymentVC = UIStoryboard(name: "Main4", bundle: nil).instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
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
