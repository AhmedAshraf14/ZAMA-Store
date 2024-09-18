//
//  PaymentViewController.swift
//  ZAMAStore
//
//  Created by zyad Baset on 16/09/2024.
//

import UIKit
import RxSwift
import RxCocoa
class CreditViewController: UIViewController {

    @IBOutlet weak var imgCredit: UIImageView!
    @IBOutlet weak var cardHolder: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtexpireDate: UITextField!
    @IBOutlet weak var txtCardNum: UITextField!
    @IBOutlet weak var cardView: UIView!
    var viewModel = CreditViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.changeCardType={[weak self]cardName in
            self?.imgCredit.image = UIImage(named: cardName.rawValue)
        }
        txtCardNum.rx.controlEvent(.editingChanged).debounce(.seconds(2), scheduler: MainScheduler()).subscribe { [self] observe in
            viewModel.detectCardType(from: txtCardNum.text!)
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("Complete")
        } onDisposed: {
            print("Disposed")
        }.disposed(by: disposeBag)


        
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        txtCardNum.addTarget(self, action: #selector(cardNumberDidChange(_:)), for: .editingChanged)
        txtexpireDate.addTarget(self, action: #selector(cardNumberDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc private func cardNumberDidChange(_ textField: UITextField) {
        if let cardNumber = textField.text {
            if cardNumber.count%4==0{
                textField.text?.append("-")
            }
        }
    }
    @objc private func expireDataDidChange(_ textField: UITextField) {
        if let cardNumber = textField.text {
            if cardNumber.count%4==0{
                textField.text?.append("/")
            }
        }
    }

}


extension CreditViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxNum = 100
        switch textField{
        case txtCardNum : maxNum = 16
        case txtCVV : maxNum = 3
        case txtexpireDate : maxNum = 5
        default : maxNum = 100
        }
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= maxNum
    }
}
