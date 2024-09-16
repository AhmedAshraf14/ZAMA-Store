//
//  DraftOrderViewController.swift
//  ZAMAStore
//
//  Created by Ahmed Ashraf on 12/09/2024.
//

import UIKit
protocol DraftOrderViewControllerProtocol {
    func changePrice()
}
class DraftOrderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceee: UILabel!
    var viewModel : DraftOrderViewModel!
    required init?(coder: NSCoder) {
        self.viewModel = DraftOrderViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!viewModel.isCart){
            lblPriceee.isHidden=true
            lblPrice.isHidden=true
            btnCheckOut.setTitle("Continue Shopping", for: .normal)
        }
        
        
        let currency = self.viewModel?.getCurrency()
        var convertedPrice = 0.0
        if let priceString = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice,
           let price = Double(priceString) {
            convertedPrice = price * (currency?.1 ?? 1.0)
        }
        self.lblPrice.text = String(format: "%.2f", convertedPrice) + " \(currency?.0 ?? "")"
        
        //lblPrice.text = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice
        setupTable()
    }
    
    private func setupTable(){
        
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WishlistCell")
        let nib1 = UINib(nibName: "CartCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = viewModel.isCart ? "My Cart" : "Wishlist"
        setupViewModel()
    }
    
    private func setupViewModel(){
        viewModel.getDraftProducts()
        viewModel.reloadTV = {
            self.tableView.reloadData()
            let currency = self.viewModel?.getCurrency()
            var convertedPrice = 0.0
            if let priceString = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice,
               let price = Double(priceString) {
                convertedPrice = price * (currency?.1 ?? 1.0)
            }
            self.lblPrice.text = String(format: "%.2f", convertedPrice) + " \(currency?.0 ?? "")"
            //self.lblPrice.text = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice
        }
        viewModel.noResult={
            self.tableView.isHidden = true
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        
        print("Button Clicked")
    }
    
}


//MARK: - Extension hedic
extension DraftOrderViewController : UITableViewDelegate, UITableViewDataSource{
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(viewModel.isCart){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            cell.viewModel=CartCellViewModel(index: indexPath.row, product: viewModel.products[indexPath.row],obj: self)
            cell.setUpCell()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
            cell.viewModel=WishListCellViewModel(product: viewModel.products[indexPath.row])
            cell.setupCell()
            return cell
        }
        
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
            self.viewModel.deleteDraftOrder(product: self.viewModel.products[indexPath.row])
            
            handler(true)
        }
        deleteAction.image=UIImage(systemName: "trash.fill")
        return(UISwipeActionsConfiguration(actions: [deleteAction]))
    }
}
extension DraftOrderViewController:DraftOrderViewControllerProtocol{
    func changePrice() {
            // Animate fade out
            UIView.animate(withDuration: 0.3, animations: {
                self.lblPrice.alpha = 0.0
            }) { _ in
                // Update the label text after fade out
                let currency = self.viewModel?.getCurrency()
                var convertedPrice = 0.0
                if let priceString = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice,
                   let price = Double(priceString) {
                    convertedPrice = price * (currency?.1 ?? 1.0)
                }
                self.lblPrice.text = String(format: "%.2f", convertedPrice) + " \(currency?.0 ?? "")"
                //self.lblPrice.text = MyDraftlist.cartListShared.currentDraftlist?.subTotalPrice
                
                // Animate fade in
                UIView.animate(withDuration: 0.3) {
                    self.lblPrice.alpha = 1.0
                }
            }
        }
}

