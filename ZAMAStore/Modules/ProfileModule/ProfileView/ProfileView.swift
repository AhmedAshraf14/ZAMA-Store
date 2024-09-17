//
//  ProfileView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit
class ProfileView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var viewModel = MyAccount.shared
    @IBOutlet weak var lblName: UILabel!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.setupActivityIndicator(in: view)
        
        tableView.delegate=self
        tableView.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.showActivityIndicator()
        setupView()
        viewModel.getOrders()
        //tableView.reloadData()
        viewModel.reloadTv = {
            self.tableView.reloadData()
            self.activityIndicator.hideActivityIndicator()
            self.lblName.isHidden = false
            self.tableView.isHidden = false
        }
    }
    //#selector(firstButtonTapped)
    func setupView(){
        lblName.text = "Welcome \(viewModel.currentUser.firstName!)"
        let cartButton = UIBarButtonItem.cartButton(target: self)
        let gearButton = UIBarButtonItem.gearButton(target: self)
        self.tabBarController?.navigationItem.rightBarButtonItems = [gearButton, cartButton]
        self.tabBarController?.navigationItem.leftBarButtonItems = []
        self.tabBarController?.title="Profile"
        self.tabBarController?.navigationItem.searchController = nil

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let currency = viewModel.getCurrency()
        var convertedPrice = 0.0
        switch indexPath.section {
        case 0:
            (cell.viewWithTag(1) as! UILabel).text = "Order Number : \(viewModel.orders[indexPath.row].orderNumber ?? 0)"
            if let priceString = viewModel.orders[indexPath.row].totalPrice ,
               let price = Double(priceString) {
                convertedPrice = price * (currency.1)
            }
            (cell.viewWithTag(2) as! UILabel).text = "Total Price : " + String(format: "%.2f", convertedPrice) + " \(currency.0)"
        default:
            (cell.viewWithTag(1) as! UILabel).text = "Product : \(MyDraftlist.wishListShared.currentDraftlist?.lineItems[indexPath.row].title ?? "N/A")"
            if let priceString = MyDraftlist.wishListShared.currentDraftlist?.lineItems[indexPath.row].price,
               let price = Double(priceString) {
                convertedPrice = price * (currency.1)
            }
            (cell.viewWithTag(2) as! UILabel).text = "Price : " + String(format: "%.2f", convertedPrice) + " \(currency.0)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let lineItemsCount = MyDraftlist.wishListShared.currentDraftlist?.lineItems.count ?? 0
        
        if section == 0 {
            return viewModel.orders.count < 2 ? viewModel.orders.count : 2
        } else {
            return lineItemsCount < 2 ? lineItemsCount : 2
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the container view for the header
        let headerView = UIView()
        headerView.backgroundColor = .clear

        
        let titleLabel = UILabel()
        titleLabel.text = section==0 ? "Orders" : "Wishlist"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        
        let button = UIButton(type: .system)
        button.setTitle("More", for: .normal)// Set the title for the button
        button.setTitleColor(UIColor(named: "mintGreen"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = section
        button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        headerView.addSubview(button)

        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc private func moreTapped(_ sender: UIButton){
        if sender.tag == 0{
            let ordersVC = UIStoryboard(name: "Main1", bundle: nil).instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            ordersVC.viewModel.customerID = MyAccount.shared.currentUser.id
            self.navigationController?.pushViewController(ordersVC, animated: true)
        }else {
            let wishlistVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let cartButton = UIBarButtonItem.cartButton(target: self)
        let heartButton = UIBarButtonItem.heartButton(target: self)
        let searchButton = UIBarButtonItem.searchButton(target: self)
        self.tabBarController?.navigationItem.rightBarButtonItems = [heartButton, cartButton]
        self.tabBarController?.navigationItem.leftBarButtonItem = searchButton
        
        self.lblName.isHidden = true
        self.tableView.isHidden = true
    }

}
