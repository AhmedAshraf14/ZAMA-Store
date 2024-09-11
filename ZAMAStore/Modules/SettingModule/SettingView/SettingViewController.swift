//
//  SettingView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var viewModel:SettingViewModel=SettingViewModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.reloadTV={
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        tableView.delegate=self
        tableView.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {
      setupView()
        viewModel.reloadUser()
    }
    
    @IBAction func signOut(_ sender: Any) {
        
        let us = UserDefaults.standard
        us.setValue(false, forKey: "flag")
        us.setValue("", forKey: "email")
        us.setValue("", forKey: "password")
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Main3", bundle: nil)
            let newRootViewController = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView

            // Set the new root view controller
            window.rootViewController = UINavigationController(rootViewController: newRootViewController)

            // Make the new root view controller visible
            window.makeKeyAndVisible()

            // Optionally, you can add a custom transition animation
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(viewModel.customer?.addresses?.count == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text="No address"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text=viewModel.customer?.addresses![indexPath.row].address1
        cell.detailTextLabel?.text=viewModel.customer?.addresses![indexPath.row].address2
        if(viewModel.customer!.addresses![indexPath.row].addressDefault){
            cell.backgroundColor = .mintGreen
        }else{
            cell.backgroundColor = .lightGrey
        }
        cell.layer.cornerRadius=20
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { action, view, handler in
            self.viewModel.deleteAddress(index: indexPath.row)
            handler(true)
        }
        deleteAction.image=UIImage(systemName: "trash.fill")
        return(UISwipeActionsConfiguration(actions: [deleteAction]))
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let defaultAction = UIContextualAction(style: .normal, title: "pin") { action, view, handler in
            self.viewModel.putDefaultAddress(index: indexPath.row)
            handler(true)
        }
        defaultAction.image=UIImage(systemName: "pin.fill")?.withTintColor(.mintGreen, renderingMode: .alwaysOriginal)
        //defaultAction.image?.withTintColor(.mintGreen)
        defaultAction.backgroundColor = .secondaryLightGrey
        return(UISwipeActionsConfiguration(actions: [defaultAction]))
    }

}


extension SettingViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.customer?.addresses?.count ?? 1
    }
    func setupView(){
        let pencilButton = UIBarButtonItem.pencilButton(target: self, action: #selector(addNewAddress))
        self.navigationItem.rightBarButtonItems = [pencilButton]
        self.title="Setting"
    }
    
    @objc
    func addNewAddress(){
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdressViewController") as! AdressViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Addresses"
    }
}
