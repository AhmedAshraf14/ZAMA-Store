//
//  PayViewController.swift
//  ZAMAStore
//
//  Created by zyad Baset on 16/09/2024.
//

import UIKit
import PassKit
class PayViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    private var paymentRequest : PKPaymentRequest = PKPaymentRequest()
    var selectedPay:Int=0
    @IBOutlet weak var cardCircle: UIImageView!
    @IBOutlet weak var cashCircle: UIImageView!
    @IBOutlet weak var appleCircle: UIImageView!
    @IBOutlet weak var btnPayPal: UIButton!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var viewPayMethod: UIView!
    var viewModel:PayViewModel=PayViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //View SetUp
        SetupView()
        //Apple setting
        prepareApple()
        // Do any additional setup after loading the view.
    }
    
    
    func SetupView(){
        viewPayMethod.layer.cornerRadius=20
    }
    func prepareApple(){
        self.configurePaymentRequest(request: paymentRequest)
    }
    @IBAction func FinishPayBtn(_ sender: UIButton) {
        
        switch selectedPay{
        case 0 : showAlert()
        case 1: payWithCard()
        case 2: payWithApplePay()
        
        default:
            showAlert()
        }
    }
    
    func payWithCard(){
        let vc=UIStoryboard(name: "Main4", bundle: nil).instantiateViewController(withIdentifier: "CreditViewController") as! CreditViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showAlert() {
        self.presentAlert(title: "Payment", message: "Please choose the payment method", buttonTitle: "OK")
    }

    @IBAction func applePayact(_ sender: Any) {
        cardCircle.image=UIImage(systemName: "circle")
        appleCircle.image=UIImage(systemName: "circle.fill")
        cashCircle.image=UIImage(systemName: "circle")
        selectedPay = 2
    }
    
    

    @IBAction func cardBtnAction(_ sender: Any) {
        cardCircle.image=UIImage(systemName: "circle.fill")
        appleCircle.image=UIImage(systemName: "circle")
        cashCircle.image=UIImage(systemName: "circle")
        selectedPay = 1
    }
    
}


//MARK: - Pay with Apple
extension PayViewController{
    
    func configurePaymentRequest(request: PKPaymentRequest){
        request.merchantIdentifier = "HEIN.com.shopify.pay" // doesn't matter
        request.supportedNetworks = [.masterCard, .visa]
        request.supportedCountries = ["EG", "US"]
        request.merchantCapabilities = .threeDSecure
        request.countryCode = "EG"
        request.currencyCode = "USD" // put you currency
    }
    func payWithApplePay(){
        let amount = String(1200) // order toatal amoun
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Cart Order", amount: NSDecimalNumber(string: amount ))]
            
            let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            if controller != nil {
                controller!.delegate = self
                present(controller!, animated: true, completion: nil)
            }
    }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        // after completing the payment
        viewModel.pushOrder()
    }

}
