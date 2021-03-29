//
//  CheckoutVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Stripe
import PassKit
import Braintree

class CheckoutVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let naContainerV = UIView()
    private let topView = CheckoutTopView()
    private let paymentView = PaymentView()
    private let bottomView = CheckoutBottomView()
    private let addPaymentBtn = ShowMoreBtn()
    private let backBtn = UIButton()
    private var hud = HUD()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private var scrollIndex = 0
    
    private var indexPaymentMethod: Int?
    private var isSelectPaymentMethod = false
    
    var total: Double = 0.0
    var user: User?
    var address: Address?
    var shoppingCart = ShoppingCart()
    
    private var paymentSuccess = false //ApplePay
    private var braintreeClient: BTAPIClient? //PayPal
    private var payPalDriver: BTPayPalDriver? //PayPal
    
    let whoopsTxt = NSLocalizedString("Whoops!!!", comment: "CheckoutVC.swift: Whoops!!!")
    let continueTxt = NSLocalizedString("Continue", comment: "CheckoutVC.swift: Continue")
    let methodTxt = NSLocalizedString("Select Payment Method", comment: "CheckoutVC.swift: Select Payment Method")
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        setupCV()
        configureBraintree()
        //fetchClientToken()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

//MARK: - Configures

extension CheckoutVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        topView.setupTopView(view, paymentV: paymentView, vc: self)
        bottomView.setupBottomView(view, addPayBtn: addPaymentBtn, dl: self)
    }
    
    func setupCV() {
        collectionView.configureCVInsert(groupColor, ds: self, dl: self, view: view, below: topView)
        collectionView.register(VisaCVCell.self, forCellWithReuseIdentifier: VisaCVCell.identifier)
        collectionView.register(PayPalCVCell.self, forCellWithReuseIdentifier: PayPalCVCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        collectionView.isPagingEnabled = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
    }
}

//MARK: - Functions

extension CheckoutVC {
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
            navigationController?.popViewController(animated: true)
        case .changed:
            if let interractiveTransition = interactiveTransition {
                interractiveTransition.update(progress)
            }
            
            shouldFinish = progress > percentThreshold
        case .cancelled, .failed:
            interactiveTransition.cancel()
        case .ended:
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
}

//MARK: - UICollectionViewDataSource

extension CheckoutVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisaCVCell.identifier, for: indexPath) as! VisaCVCell
            cell.delegate = self
            cell.total = total
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PayPalCVCell.identifier, for: indexPath) as! PayPalCVCell
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension CheckoutVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CheckoutVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

//MARK: - UINavigationControllerDelegate

extension CheckoutVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionCurve = .easeOut
            
        } else {
            interactiveTransition = nil
        }
        
        return interactiveTransition
    }
}

//MARK: - UIScrollViewDelegate

extension CheckoutVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0.0 {
            collectionView.contentOffset.x = 0.0
            
        } else if scrollView.contentOffset.x >= screenWidth {
            collectionView.contentOffset.x = screenWidth
        }
        
        paymentView.horLeadingAnchor.constant = scrollView.contentOffset.x/2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        paymentView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        changeBtnTxt(addPaymentBtn, index: indexPath.item)
    }
    
    func scrollToPaymentIndex(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        changeBtnTxt(addPaymentBtn, index: indexPath.item)
    }
    
    func changeBtnTxt(_ btn: ShowMoreBtn, index: Int) {
        scrollIndex = index
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeBtn()
            case .dark: setupDarkModeBtn(true)
            default: break
            }
        } else {
            setupDarkModeBtn()
        }
    }
}

//MARK: - CheckoutBottomViewDelegate

extension CheckoutVC: CheckoutBottomViewDelegate {
    
    func handleAddPayDidTap() {
        if self.scrollIndex == 0 {
            if self.isSelectPaymentMethod {
                if self.indexPaymentMethod == 0 {
                    guard isInternetAvailable() else { internetNotAvailable(); return }
                    guard Stripe.deviceSupportsApplePay() else {
                        let mesTxt = NSLocalizedString("Device does not support Apple Pay", comment: "CheckoutVC.swift: Device does not support Apple Pay")
                        
                        handleErrorAlert(whoopsTxt, mes: mesTxt, act: "OK", vc: self)
                        return
                    }
                    
                    self.handleApplePayBtnTapped()
                    
                } else if self.indexPaymentMethod == 1 {
                    guard isInternetAvailable() else { internetNotAvailable(); return }
                    
                    let addCardVC = AddCardVC()
                    addCardVC.total = total
                    addCardVC.address = address
                    addCardVC.user = user
                    addCardVC.shoppingCart = shoppingCart
                    navigationController?.pushViewController(addCardVC, animated: true)
                    
                } else if self.indexPaymentMethod == 2 {
                    guard isInternetAvailable() else { internetNotAvailable(); return }
                    
                    let confi = STPPaymentConfiguration()
                    confi.requiredShippingAddressFields = [.postalAddress]
                    
                    let theme = STPTheme()
                    theme.emphasisFont = UIFont(name: fontNamedBold, size: 17.0)
                    theme.font = UIFont(name: fontNamedBold, size: 17.0)
                    theme.accentColor = .darkGray
                    
                    let address = STPAddress()
                    if let addr = self.address {
                        address.name = addr.firstName + " " + addr.lastName
                        address.line1 = addr.addrLine1
                        address.line2 = addr.addrLine2
                        address.country = addr.country
                        address.state = addr.state
                        address.city = addr.city
                        address.postalCode = addr.zipcode
                        address.phone = addr.phoneNumber
                    }
                    
                    let total = NSDecimalNumber(value: self.total)
                    let shippingMethod = PKShippingMethod(label: "Total", amount: total)
                    let userInfo = STPUserInformation()
                    userInfo.shippingAddress = address
                    
                    let addrVC = STPShippingAddressViewController(configuration: confi, theme: theme, currency: "USD", shippingAddress: address, selectedShippingMethod: shippingMethod, prefilledInformation: userInfo)
                    addrVC.delegate = self
                    navigationController?.pushViewController(addrVC, animated: true)
                    
                } else {
                    return
                }
                
            } else {
                handleInternet(methodTxt, imgName: "icon-error")
            }
            
        } else {
            guard isInternetAvailable() else { internetNotAvailable(); return }
            self.startCheckout()
        }
    }
}

//MARK: - VisaCVCellDelegate

extension CheckoutVC: VisaCVCellDelegate {
    
    func handlePaymentMethod(_ isSelect: Bool, index: Int) {
        isSelectPaymentMethod = isSelect
        indexPaymentMethod = index
        darkModePaymentMethod()
    }
    
    private func darkModePaymentMethod() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupPaymentBtn()
            case .dark: setupPaymentBtn(true)
            default: break
            }
        } else {
            setupPaymentBtn()
        }
    }
    
    private func setupPaymentBtn(_ isDarkMode: Bool = false) {
        let attC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(continueTxt, txtColor: attC, size: 17.0)
        addPaymentBtn.setAttributedTitle(attributed, for: .normal)
        addPaymentBtn.backgroundColor = isDarkMode ? .white : .black
    }
}

//MARK: - STPShippingAddressViewControllerDelegate

extension CheckoutVC: STPShippingAddressViewControllerDelegate {
    
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        guard let name = address.name,
            let line1 = address.line1,
            let country = address.country,
            let state = address.state,
            let city = address.city,
            let zipcode = address.postalCode else {
                print("Error")
                self.removeHUD()
                completion(.invalid, nil, nil, nil)
                return
        }
        
        print("Success")
        print(name)
        print(line1)
        print(address.line2 ?? "")
        print(country)
        print(state)
        print(city)
        print(zipcode)
        print(address.phone ?? "")
        view.isUserInteractionEnabled = false
        hud = createdHUD()
        completion(.valid, nil, nil, nil)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        delay(duration: 0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                self.hud.removeFromSuperview()
                
                History.saveHistory(hud: self.hud, address: self.address, shoppingCart: self.shoppingCart, paymentMethod: "Cash payment on delivery", vc: self) {}
            })
        }
    }
}

//MARK: - ApplePay

extension CheckoutVC {
    
    func handleApplePayBtnTapped() {
        let merchanId = "merchant.com.keda.t06"
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchanId, country: "CA", currency: "CAD")
        
        let total = NSDecimalNumber(value: self.total)
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total", amount: total),
            PKPaymentSummaryItem(label: "iOrder, Inc", amount: total)
        ]
        
        if Stripe.canSubmitPaymentRequest(paymentRequest),
            let paymentAuthorizationVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
            paymentAuthorizationVC.delegate = self
            present(paymentAuthorizationVC, animated: true, completion: nil)
            
        } else {
            let mes = NSLocalizedString("There is a problem with your Apple Pay configuration", comment: "CheckoutVC.swift: There is a problem with your Apple Pay configuration")
            handleErrorAlert(whoopsTxt, mes: mes, act: "OK", vc: self)
        }
    }
}

//MARK: - PKPaymentAuthorizationViewControllerDelegate

extension CheckoutVC: PKPaymentAuthorizationViewControllerDelegate, STPAuthenticationContext {
    
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true) {
            if self.paymentSuccess {
                print("Show a receipt page")
                History.saveHistory(hud: self.hud, address: self.address, shoppingCart: self.shoppingCart, paymentMethod: "Paid by Apple Pay", vc: self) {}
                
            } else {
                print("Present error to customer")
                handleErrorAlert("Oops!!!", mes: "Error at checkout", act: "OK", vc: self)
            }
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        submitToStripe { (clientSecret) in
            STPAPIClient.shared().createPaymentMethod(with: payment) { (paymentMethod, error) in
                guard let paymentMethod = paymentMethod, error == nil else { self.removeHUD(); return }
                guard let clientSecret = clientSecret else { self.removeHUD(); return }
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentMethod.stripeId

                STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                    switch status {
                    case .succeeded:
                        self.paymentSuccess = true
                        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    case .canceled:
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    case .failed:
                        let errors = [STPAPIClient.pkPaymentError(forStripeError: error)].compactMap({ $0 })
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
                    default:
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    }
                }
            }
        }
    }
    
    func removeHUD() {
        view.isUserInteractionEnabled = true
        hud.removeFromSuperview()
    }
    
    func submitToStripe(completion: @escaping (String?) -> Void) {
        MyAPIClient().createCustomer(user!) { (customerId) in
            guard let customerId = customerId else { return }
            MyAPIClient().createPaymentIntent(total: self.total,
                                              customerId: customerId,
                                              completion: completion)
        }
    }
}

//MARK: - PayPal

extension CheckoutVC {
    
    func fetchClientToken() {
        let url = URL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                let clientToken = String(data: data, encoding: .utf8)!
                self.braintreeClient = BTAPIClient(authorization: clientToken)
            }
            
        }).resume()
    }
    
    func configureBraintree() {
        braintreeClient = BTAPIClient(authorization: "sandbox_gpmd64cb_h8kckz52t2d9vvfh")
    }
    
    func startCheckout() {
        view.isUserInteractionEnabled = false
        
        payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver?.viewControllerPresentingDelegate = self
        payPalDriver?.appSwitchDelegate = self
        
        //Example: Transaction amount
        let request = BTPayPalRequest(amount: "\(total)")
        request.currencyCode = "USD"
        
        payPalDriver?.requestOneTimePayment(request, completion: { (payPalAccNonce, error) in
            if let payPalAccNonce = payPalAccNonce {
                print("Got a nonce: \(payPalAccNonce.nonce)")
                if let email = payPalAccNonce.email { print(email) }
                if let firstName = payPalAccNonce.firstName { print(firstName) }
                if let lastName = payPalAccNonce.lastName { print(lastName) }
                if let phone = payPalAccNonce.phone { print(phone) }
                
                let _ = payPalAccNonce.billingAddress
                let _ = payPalAccNonce.shippingAddress
                
                History.saveHistory(hud: self.hud, address: self.address, shoppingCart: self.shoppingCart, paymentMethod: "Paid by PayPal", vc: self) {}
                
            } else if let error = error {
                self.removeHUD()
                handleErrorAlert("Oops!!!", mes: error.localizedDescription, act: "OK", vc: self)
                
            } else {
                self.removeHUD()
                handleErrorAlert("Oops!!!", mes: "Canceled payment approval", act: "OK", vc: self)
            }
        })
    }
}

//MARK: - BTViewControllerPresentingDelegate

extension CheckoutVC: BTViewControllerPresentingDelegate {
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

//MARK: - BTAppSwitchDelegate

extension CheckoutVC: BTAppSwitchDelegate {
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        print("willPerformAppSwitch")
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) { print("didPerformSwitchTo")
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        print("WillProcessPaymentInfo")
    }
}

//MARK: - DarkMode

extension CheckoutVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        view.backgroundColor = isDarkMode ? .black : groupColor
        collectionView.backgroundColor = isDarkMode ? .black : groupColor
        setupDarkModeBtn(isDarkMode)
    }
    
    func setupDarkModeBtn(_ isDarkMode: Bool = false) {
        let txt: String
        if scrollIndex == 0 {
            if isSelectPaymentMethod {
                txt = continueTxt
                
            } else {
                txt = methodTxt
            }
            
        } else {
            txt = continueTxt
        }
        
        let attC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(txt, txtColor: attC, size: 17.0)
        addPaymentBtn.setAttributedTitle(attributed, for: .normal)
        addPaymentBtn.backgroundColor = isDarkMode ? .white : .black
    }
}
