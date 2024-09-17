//
//  SettingView.swift
//  ZAMAShop
//
//  Created by zyad Baset on 02/09/2024.
//

import UIKit

class SettingViewController: UIViewController {
    var viewModel:SettingViewModel=SettingViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currencyControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        viewModel.reloadUser()
        viewModel.reloadTV={
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        currencyControl.selectedSegmentIndex = viewModel.checkCurrency()
    }
    
    @IBAction func currencyChanged(_ sender: UISegmentedControl) {
        viewModel.changeCurrency(to: sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        
    }
    @IBAction func signOut(_ sender: Any) {
        
        viewModel.signOutUser {
            if let window = UIApplication.shared.windows.first {
                let storyboard = UIStoryboard(name: "Main3", bundle: nil)
                let newRootViewController = storyboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
                window.rootViewController = UINavigationController(rootViewController: newRootViewController)
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
        
    }
    
    
    

}



//MARK: Dealing with TVDelagate&DataSource
extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.customer?.addresses?.count ?? 1
    }
    func setupView(){
        let pencilButton = UIBarButtonItem.pencilButton(target: self)
        self.navigationItem.rightBarButtonItems = [pencilButton]
        self.title="Setting"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "AdressViewController") as! AdressViewController
        //vc.viewModel=AddressViewModel()
        vc.viewModel.isShow=true
        vc.viewModel.address=AddressResponse(add: viewModel.customer!.addresses![indexPath.row])
        self.present(vc, animated: true)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Addresses"
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
            if self.viewModel.customer?.addresses?.count == 1 {
                handler(true)
                return}
            self.presentActionAlert(title: "Warning", message: "This address will be deleted") {
                self.viewModel.deleteAddress(index: indexPath.row)
            }
            handler(true)
        }
        deleteAction.image=UIImage(systemName: "trash.fill")
        return(UISwipeActionsConfiguration(actions: [deleteAction]))
    }
}
