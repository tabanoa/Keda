//
//  AddCardVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Stripe

class AddCardVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let cardImageView = UIImageView()
    private var hud = HUD()
    
    private lazy var cardTF: STPPaymentCardTextField = {
        return STPPaymentCardTextField()
    }()
    
    var total: Double = 0.0
    var address: Address?
    var user: User?
    var shoppingCart = ShoppingCart()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupTV()
        setupHeaderView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func endEditing() {
        tableView.endEditing(true)
    }
}

//MARK: - Configures

extension AddCardVC {
    
    func updateUI() {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("Add A Card", comment: "AddCardVC.swift: Add A Card")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDidTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidTap))
        navigationItem.rightBarButtonItem!.isEnabled = cardTF.isValid
    }
    
    func setupTV() {
        tableView.configureTVNonSepar(groupColor, ds: self, dl: self, view: view)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddCardTVCell")
        tableView.rowHeight = 50.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setupHeaderView() {
        cardImageView.image = UIImage(named: "stp_card_form_front")?.withRenderingMode(.alwaysTemplate)
        cardImageView.tintColor = .darkGray
        cardImageView.contentMode = .center
        cardImageView.frame = CGRect(x: 0.0, y: 50.0,
                                     width: view.bounds.size.width,
                                     height: cardImageView.bounds.size.height+50+(57*2))
        tableView.tableHeaderView = cardImageView
    }
    
    @objc func cancelDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneDidTap() {
        endEditing()
        submitToStripe()
    }
    
    func submitToStripe() {
        view.isUserInteractionEnabled = false
        hud = createdHUD()
        
        MyAPIClient().createCustomer(user!) { (customerId) in
            guard let customerId = customerId else { return }
            MyAPIClient().createPaymentIntent(total: self.total, customerId: customerId) { (clientSecret) in
                guard let clientSecret = clientSecret else { return }
                let cardParams = self.cardTF.cardParams
                let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                
                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                    switch status {
                    case .succeeded:
                        History.saveHistory(hud: self.hud, address: self.address, shoppingCart: self.shoppingCart, paymentMethod: "Paid by Visa", vc: self) {}
                        break
                    case .canceled:
                        self.view.isUserInteractionEnabled = true
                        self.hud.removeFromSuperview()
                        print("Canceled")
                        break
                    case .failed:
                        self.view.isUserInteractionEnabled = true
                        self.hud.removeFromSuperview()
                        print("Failed")
                        
                        let titleTxt = NSLocalizedString("Whoops!!!", comment: "AddCardVC.swift: Whoops!!!")
                        let cancelTxt = NSLocalizedString("Cancel", comment: "AddCardVC.swift: Cancel")
                        let tryAgainTxt = NSLocalizedString("Try Again", comment: "AddCardVC.swift: Try Again")
                        let alert = UIAlertController(title: titleTxt, message: error!.localizedDescription, preferredStyle: .alert)
                        let cancelAct = UIAlertAction(title: cancelTxt, style: .cancel, handler: nil)
                        let tryAgainAct = UIAlertAction(title: tryAgainTxt, style: .default) { (_) in
                            self.doneDidTap()
                        }
                        
                        alert.addAction(cancelAct)
                        alert.addAction(tryAgainAct)
                        self.present(alert, animated: true, completion: nil)
                        
                        break
                    default:
                        self.view.isUserInteractionEnabled = true
                        self.hud.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
    
    /*
    func submitToStripe() {
        let cardParams = STPCardParams()
        cardParams.number = cardTF.cardNumber
        cardParams.cvc = cardTF.cvc
        cardParams.expMonth = cardTF.expirationMonth
        cardParams.expYear = cardTF.expirationYear

        hud = createdHUD()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let token = token {
                self.tokenToStripe(token: token)
            }
        }
    }
     
    func tokenToStripe(token: STPToken) {
        let link = "http://localhost:8888/stripe-php/payment.php"
        let total = Int(self.total)
        let parameters: [String: Any] = [
            "stripeToken": token.tokenId,
            "amount": total,
            "currency": "usd",
            "description": user!.email
        ]

        let manager = AFHTTPSessionManager()
        manager.post(link, parameters: parameters, headers: nil, progress: nil, success: { (dataTask, response) in
            print("Success")
            self.hud.removeFromSuperview()

        }) { (dataTask, error) in
            print("Error")
            self.hud.removeFromSuperview()

            let alert = UIAlertController(title: "Oops!!!", message: error.localizedDescription, preferredStyle: .alert)
            let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let tryAgainAct = UIAlertAction(title: "Try Again", style: .default) { (_) in
                self.doneDidTap()
            }

            alert.addAction(cancelAct)
            alert.addAction(tryAgainAct)
            self.present(alert, animated: true, completion: nil)
        }
    }
    */
}

//MARK: - UITableViewDataSource

extension AddCardVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCardTVCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        setupCardTF(cell.contentView)
        return cell
    }
    
    private func setupCardTF(_ view: UIView) {
        cardTF.font = UIFont(name: fontNamedBold, size: 17.0)
        cardTF.textColor = .darkGray
        cardTF.delegate = self
        view.addSubview(cardTF)
        cardTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardTF.topAnchor.constraint(equalTo: view.topAnchor),
            cardTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            cardTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            cardTF.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - UITableViewDelegate

extension AddCardVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

//MARK: - STPPaymentCardTextFieldDelegate

extension AddCardVC: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        navigationItem.rightBarButtonItem!.isEnabled = cardTF.isValid
    }
    
    func paymentCardTextFieldWillEndEditing(forReturn textField: STPPaymentCardTextField) {
        textField.resignFirstResponder()
        doneDidTap()
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        let isAmex = STPCardValidator.brand(forNumber: textField.cardNumber ?? "") == STPCardBrand.amex
        
        let newImg: UIImage?
        let animTransition: UIView.AnimationOptions
        if isAmex {
            newImg = UIImage(named: "stp_card_form_amex_cvc")
            animTransition = .transitionCrossDissolve
            
        } else {
            newImg = UIImage(named: "stp_card_form_back")
            animTransition = .transitionFlipFromRight
        }
        
        UIView.transition(with: cardImageView,
                          duration: 0.2,
                          options: animTransition,
                          animations: {
                            self.cardImageView.image = newImg?.withRenderingMode(.alwaysTemplate)
                            self.cardImageView.tintColor = .darkGray
        },
                          completion: nil)
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        let isAmex = STPCardValidator.brand(forNumber: textField.cardNumber ?? "") == STPCardBrand.amex
        let animTransition: UIView.AnimationOptions = isAmex ?
            .transitionCrossDissolve : .transitionFlipFromLeft
        
        UIView.transition(with: cardImageView,
                          duration: 0.2,
                          options: animTransition,
                          animations: {
                            self.cardImageView.image = UIImage(named: "stp_card_form_front")?.withRenderingMode(.alwaysTemplate)
                            self.cardImageView.tintColor = .darkGray
        },
                          completion: nil)
    }
}

//MARK: - STPAuthenticationContext

extension AddCardVC: STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
