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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        tableView.reloadData()
    }
    //#selector(firstButtonTapped)
    func setupView(){
        lblName.text = "Welcome \(viewModel.currentUser.firstName!)"
        let cartButton = UIBarButtonItem.cartButton(target: self)
        let gearButton = UIBarButtonItem.gearButton(target: self)
        self.tabBarController?.navigationItem.rightBarButtonItems = [gearButton, cartButton]
        self.tabBarController?.title="Profile"

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            (cell.viewWithTag(1) as! UILabel).text = MyDraftlist.wishListShared.currentDraftlist?.lineItems?[indexPath.row].title ?? "NO Title"
        default:
            (cell.viewWithTag(1) as! UILabel).text = MyDraftlist.wishListShared.currentDraftlist?.lineItems?[indexPath.row].title ?? "NO Title"
            (cell.viewWithTag(2) as! UILabel).text = "Price : \(MyDraftlist.wishListShared.currentDraftlist?.lineItems?[indexPath.row].price ?? "N/A")"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return viewModel.currentUser.ordersCount
        }
        if MyDraftlist.wishListShared.currentDraftlist?.lineItems?.count ?? 0 < 2{
            return MyDraftlist.wishListShared.currentDraftlist?.lineItems?.count ?? 0
        }else {
            return 2
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the container view for the header
        let headerView = UIView()
        headerView.backgroundColor = .clear // Set the background color for the header

        // Create the label
        let titleLabel = UILabel()
        titleLabel.text = section==0 ? "Orders" : "Wishlist" // Set the text for the label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        // Create the button
        let button = UIButton(type: .system)
        button.setTitle("More", for: .normal)// Set the title for the button
        button.setTitleColor(UIColor(named: "mintGreen"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = section
        button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        headerView.addSubview(button)

        // Set constraints for the label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        // Set constraints for the button
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
            
        }else {
            let wishlistVC = UIStoryboard(name: "Main3", bundle: nil).instantiateViewController(withIdentifier: "DraftOrderViewController") as! DraftOrderViewController
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        }
    }
    
}
