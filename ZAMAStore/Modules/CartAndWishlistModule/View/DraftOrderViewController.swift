//
//  DraftOrderViewController.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import UIKit

class DraftOrderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel : DraftOrderViewModel!
    
    
    required init?(coder: NSCoder) {
        self.viewModel = DraftOrderViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    private func setupTable(){
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WishlistCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Wishlist"
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel.getFavProducts()
        viewModel.reloadTV = {
            self.tableView.reloadData()
        }
        viewModel.noResult={
            self.tableView.isHidden = true
        }
    }
}

extension DraftOrderViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        cell.setupImage(imageUrl: viewModel.products[indexPath.row].image.src)
        cell.productNameLabel.text = viewModel.products[indexPath.row].title
        cell.productPriceLabel.text = "Price : \(viewModel.products[indexPath.row].variants[0].price)"
        cell.productVendorLabel.text = "Vendor : \(viewModel.products[indexPath.row].vendor)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsView") as! ProductDetailsView
        productDetailVC.viewModel.product = viewModel.products[indexPath.row]
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { action, view, handler in
            self.viewModel.deleteFavDraftOrder(product: self.viewModel.products[indexPath.row])
            self.viewModel.getFavProducts()
            handler(true)
        }
        deleteAction.image=UIImage(systemName: "trash.fill")
        return(UISwipeActionsConfiguration(actions: [deleteAction]))
    }
}
