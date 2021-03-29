//
//  QuantityIMGViewVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class QuantityIMGViewVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let naContainerV = UIView()
    private let quantityLbl = UILabel()
    private let bagBtn = UIButton()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    lazy var imageLinks: [String] = []
    var review: Review!
    var prRating: Rating?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupNavi()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        guard isLogIn() else { return }
        ShoppingCart.fetchShoppingCart(completion: { (shoppingCart) in
            if let shoppingCart = shoppingCart {
                self.quantityLbl.text = "\(shoppingCart.productCarts.count)"
                
            } else {
                self.quantityLbl.text = "\(0)"
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isLogIn() else { return }
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Configures

extension QuantityIMGViewVC {
    
    func updateUI() {
        view.backgroundColor = .white
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.register(QuantityIMGViewCVCell.self, forCellWithReuseIdentifier: QuantityIMGViewCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5.0),
        ])
    }
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Bag
        bagBtn.configureFilterBtn(naContainerV, imgNamed: "icon-bag", selector: #selector(bagDidTap), controller: self)

        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Photos From Client", comment: "QuantityIMGViewVC.swift: Photos From Client")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: bagBtn)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-23.0
        quantityLbl.frame = CGRect(x: x, y: 0.0, width: 30.0, height: 30.0)
    }
    
    @objc func bagDidTap() {
        if isLogIn() {
            handleBackToTabCart()
            
            for vc in navigationController!.viewControllers {
                if vc.isKind(of: HomeVC.self) {
                    navigationController?.popToViewController(vc, animated: true)
                    
                } else if vc.isKind(of: WishlistVC.self) {
                    navigationController?.popToViewController(vc, animated: true)
                }
            }
            
        } else {
            presentWelcomeVC(self, isPresent: true)
        }
    }
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
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

extension QuantityIMGViewVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuantityIMGViewCVCell.identifier, for: indexPath) as! QuantityIMGViewCVCell
        guard imageLinks.count != 0 else { return cell }
        cell.link = imageLinks[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension QuantityIMGViewVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showIMGViewVC = ShowIMGViewVC()
        showIMGViewVC.imageLinks = imageLinks
        showIMGViewVC.indexPath = indexPath
        showIMGViewVC.review = review
        showIMGViewVC.prRating = prRating
        showIMGViewVC.modalPresentationStyle = .fullScreen
        present(showIMGViewVC, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension QuantityIMGViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (screenWidth-25)/4
        return CGSize(width: width, height: width)
    }
}

//MARK: - UINavigationControllerDelegate

extension QuantityIMGViewVC: UINavigationControllerDelegate {
    
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

//MARK: - DarkMode

extension QuantityIMGViewVC {
    
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
        view.backgroundColor = isDarkMode ? .black : .white
    }
}
