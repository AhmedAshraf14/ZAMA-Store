//
//  AdressViewController.swift
//  ZAMAStore
//
//  Created by zyad Baset on 11/09/2024.
//

import UIKit

class AdressViewController: UIViewController {

    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var sqitchIsDefault: UISwitch!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var btnAddAdsress: UIButton!
    @IBOutlet weak var txtAdress2: UITextField!
    @IBOutlet weak var txtAdress1: UITextField!
    var viewModel = AddressViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        if viewModel.isShow{
            sqitchIsDefault.isHidden=true
            btnAddAdsress.isHidden=true
            lblDefault.isHidden = true
            txtCountry.text = viewModel.address?.customer_address?.country
            txtAdress1.text = viewModel.address?.customer_address?.address1
            txtAdress2.text = viewModel.address?.customer_address?.address2
            txtCity.text = viewModel.address?.customer_address?.city
        
            txtAdress1.isEnabled=false
            txtAdress2.isEnabled=false
            txtCountry.isEnabled=false
            txtCity.isEnabled=false
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title="New Address"
    }
    

    @IBAction func addingAdress(_ sender: Any) {
        if(viewModel.checkAddress(text: txtAdress1.text) && viewModel.checkAddress(text: txtAdress2.text) && viewModel.checkAddress(text: txtCity.text) && viewModel.checkAddress(text: txtCountry.text)){
            viewModel.address?.customer_address?.address1=txtAdress1.text!
            viewModel.address?.customer_address?.address2=txtAdress2.text
            viewModel.address?.customer_address?.city=txtCity.text!
            viewModel.address?.customer_address?.country=txtCountry.text!
            viewModel.address?.customer_address?.addressDefault=sqitchIsDefault.isOn
            viewModel.address?.customer_address?.customerID=MyAccount.shared.currentUser.id
            viewModel.pushData()
            self.navigationController?.popViewController(animated: true)
        }else{
            self.presentAlert(title: "Error", message: "Fill all fields", buttonTitle: "OK")
        }
        
    }
}
