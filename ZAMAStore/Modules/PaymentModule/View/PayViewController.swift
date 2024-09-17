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
        
        //Sucess View
        viewModel.showSucessView = {self.showPaymentSuccess()}
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
        request.currencyCode = UserDefaults.standard.string(forKey: "currency") ?? "EGP" // put you currency
    }
    func payWithApplePay(){
        let amount = viewModel.cart.currentDraftlist?.totalPrice // order toatal amoun
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
        // Create a UIView for the success message
        let successView = UIView(frame: CGRect(x: 50, y: 200, width: 300, height: 100))
        successView.backgroundColor = .mintGreen
        successView.layer.cornerRadius = 15
        successView.alpha = 0.0 
        successView.center = self.view.center// Initially hidden

        // Add a UILabel to the success view
        let successLabel = UILabel(frame: successView.bounds)
        successLabel.text = "Order Comfirmed!"
        successLabel.textAlignment = .center
        successLabel.textColor = .white
        successLabel.font = UIFont.boldSystemFont(ofSize: 18)
        successView.addSubview(successLabel)
        
        // Add the success view to the main view
        self.view.addSubview(successView)

        // Transition and animate the success view appearance
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            successView.alpha = 1.0  // Fade in
        }) { _ in
            // Once the view is visible, add a scale bounce effect
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                successView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)  // Scale up
            }) { _ in
                // Scale back to original size
                UIView.animate(withDuration: 0.3) {
                    successView.transform = CGAffineTransform.identity
                }
            }

            // After a 2-second delay, hide the view with a fade-out transition
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                successView.alpha = 0.0  // Fade out
            }) { _ in
                successView.removeFromSuperview()  // Remove the view from the hierarchy
                self.returnToHomeScreen()
            }
        }
    }
    
    
    func returnToHomeScreen(){
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newRootViewController = storyboard.instantiateInitialViewController()

            // Set the new root view controller
            window.rootViewController = newRootViewController

            // Make the new root view controller visible
            window.makeKeyAndVisible()

            // Optionally, you can add a custom transition animation
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}


