//
//  AdressViewController.swift
//  ZAMAStore
//
//  Created by zyad Baset on 11/09/2024.
//

import UIKit

class AdressViewController: UIViewController {

    @IBOutlet weak var sqitchIsDefault: UISwitch!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAdress2: UITextField!
    @IBOutlet weak var txtAdress1: UITextField!
    var viewModel = AddressViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title="New Address"
    }
    

    @IBAction func addingAdress(_ sender: Any) {
        if(txtAdress1.text?.count != 0 && txtAdress2.text?.count != 0 && txtCity.text!.count != 0 && txtCountry.text!.count != 0){
            viewModel.address?.customer_address?.address1=txtAdress1.text!
            viewModel.address?.customer_address?.address2=txtAdress2.text
            viewModel.address?.customer_address?.city=txtCity.text!
            viewModel.address?.customer_address?.country=txtCountry.text!
            viewModel.address?.customer_address?.addressDefault=sqitchIsDefault.isOn
            viewModel.address?.customer_address?.customerID=MyAccount.shared.currentUser.id
            viewModel.pushData()
        }else{
            self.presentAlert(title: "Error", message: "Fill all fields", buttonTitle: "OK")
        }
        
    }
}
