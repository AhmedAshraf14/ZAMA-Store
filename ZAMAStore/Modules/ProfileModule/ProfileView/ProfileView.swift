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
    }
    //#selector(firstButtonTapped)
    func setupView(){
        lblName.text = "Welcome \(viewModel.currentUser.firstName!)"
        let heartButton = UIBarButtonItem.heartButton(target: self, action: #selector(firstButtonTapped))
        let gearButton = UIBarButtonItem.gearButton(target: self, action: #selector(secondButtonTapped))
        self.tabBarController?.navigationItem.rightBarButtonItems = [gearButton, heartButton]
        self.tabBarController?.title="Profile"

    }
    @objc func firstButtonTapped() {
        print("First button tapped")
    }

    @objc func secondButtonTapped() {
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
    initialViewController?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(initialViewController!, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text="Celll"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return viewModel.currentUser.ordersCount
        }
        return viewModel.currentUser.ordersCount
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
    
}
