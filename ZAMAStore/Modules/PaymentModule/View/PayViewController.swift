//
//  PayViewController.swift
//  ZAMAStore
//
//  Created by zyad Baset on 16/09/2024.
//

import UIKit
import PassKit
class PayViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    
    @IBOutlet weak var view2: UIView!
    
    
    
    @IBOutlet weak var imgViewFinish: UIImageView!
    private var paymentRequest : PKPaymentRequest = PKPaymentRequest()
    var selectedPay:Int=0
    @IBOutlet weak var cardCircle: UIImageView!
    @IBOutlet weak var cashCircle: UIImageView!
    @IBOutlet weak var appleCircle: UIImageView!
    @IBOutlet weak var btnPayPal: UIButton!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var viewPayMethod: UIView!
    var viewModel:PayViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //View SetUp
        SetupView()
        //Apple setting
        prepareApple()
        self.title = "Payment Method"
        //Sucess View
        viewModel.showSucessView = {self.showPaymentSuccess()}
        self.view2.alpha = 0.0
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
        case 3: viewModel.pushOrder()
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

    @IBAction func cardBtnAction(_ sender: UIButton) {
        //cardCircle.image=UIImage(systemName: "circle\(sender.tag == 1 ? ".fill" : "")")
        appleCircle.image=UIImage(systemName: "circle\(sender.tag == 2 ? ".fill" : "")")
        cashCircle.image=UIImage(systemName: "circle\(sender.tag == 3 ? ".fill" : "")")
        selectedPay = sender.tag
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
        request.currencyCode = UserDefaults.standard.string(forKey: "currency") ?? "EGP" // put you currency
    }
    func payWithApplePay(){
        let amount = viewModel.totalPrice// order toatal amoun
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




//MARK: - Animation of finishing payment
extension PayViewController{
    func showPaymentSuccess() {

        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view2.alpha = 1.0
        }) { _ in
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                self.view2.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                
                UIView.animate(withDuration: 0.3) {
                    self.view2.transform = CGAffineTransform.identity
                }
            }

  
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                self.view2.alpha = 0.0
            }) { _ in
                self.view2.removeFromSuperview()
                self.returnToHomeScreen()
            }
        }
    }
    
    
    func returnToHomeScreen(){
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newRootViewController = storyboard.instantiateInitialViewController()

            
            window.rootViewController = newRootViewController

            
            window.makeKeyAndVisible()

           
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}


