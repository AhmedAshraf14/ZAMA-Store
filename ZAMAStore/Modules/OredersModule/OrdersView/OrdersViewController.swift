//
//  OrdersViewController.swift
//  ZAMAStore
//
//  Created by Enas Mohamed on 10/09/2024.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var viewModel = OrdersViewModell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        let nib = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTableView.register(nib, forCellReuseIdentifier: "OrdersTableViewCell")
        
        // Bind the result to update the UI
        viewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.ordersTableView.reloadData()
            }
        }
        
        // Fetch the orders
        viewModel.getOrders()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersTableViewCell", for: indexPath) as! OrdersTableViewCell
      //  cell.trackingNumberLabel.text = "Tracking number: " + viewModel.orders[indexPath.row].orderNumber.map { "\($0)" }!
        cell.totalNumberLabel.text = "Total Amount " + viewModel.orders[indexPath.row].totalPrice.map{ "\($0)" }!
        //cell.quantityLabel.text = viewModel.orders[indexPath.row].lineItems[indexPath.row].quantity.map{"\($0)"}
        if let lineItems = viewModel.orders[indexPath.row].lineItems {
            cell.quantityLabel.text = "Numbers Of Product: " + "\(lineItems.count ?? 0)"
           } else {
               cell.quantityLabel.text = "Quantity: N/A"
           }
        
        cell.OrderNumberLabel.text = "Order number: " + viewModel.orders[indexPath.row].orderNumber.map { "\($0)" }!
        cell.statusLabel.text = "Deliverd"
        cell.statusLabel.textColor = UIColor(named: "mintGreen")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 // Height of each cell
    }
  

}
