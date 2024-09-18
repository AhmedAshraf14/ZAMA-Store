//
//  OrdersViewController.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ordersTableView: UITableView!
    var viewModel : OrdersViewModell!
    
    required init?(coder: NSCoder) {
        self.viewModel = OrdersViewModell()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        let nib = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTableView.register(nib, forCellReuseIdentifier: "OrdersTableViewCell")
        self.title = "Your orders"
        if viewModel.orders.count == 0 {
            ordersTableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
        cell.OrderNumberLabel.text = "Order number : \(viewModel.orders[indexPath.row].orderNumber ?? 0)"
        let currency = viewModel.getCurrency()
        var convertedPrice = 0.0
        if let priceString = viewModel.orders[indexPath.row].totalPrice,
           let price = Double(priceString) {
            convertedPrice = price * (currency.1)
        }
        cell.totalPriceLabel.text = "Total price : \(String(format: "%.2f", convertedPrice))"  + " \(currency.0)"
        cell.numberOfProductsLabel.text = "Number of products : \(viewModel.orders[indexPath.row].lineItems?.count ?? 0)"
        cell.dateLabel.text = "Date : \(viewModel.formatDateStringToNumbers(viewModel.orders[indexPath.row].createdAt) ?? "N/A")"
        cell.statusLabel.text = "Shipping address : \(viewModel.orders[indexPath.row].shippingAddress?.address1 ?? "N/A")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
  

}
