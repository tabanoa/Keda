//
//  FilteredVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FilteredVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let filteredLayout = FilteredLayout()
    
    private let naContainerV = UIView()
    private let refresh = UIRefreshControl()
    
    private let bagBtn = UIButton()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let quantityLbl = UILabel()
    private let existLbl = UILabel()
    
    lazy var products: [Product] = []
    
    var titleTxt = NSLocalizedString("Filered", comment: "FilteredVC.swift: Filered")
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupCV()
        setupDarkMode()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedIndex), name: Notification.Name("DismissHomeVC"), object: nil)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            collectionView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if products.count <= 0 {
            collectionView.isHidden = true
            createNotiLbl()
        }
        
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

extension FilteredVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Bag
        bagBtn.configureFilterBtn(naContainerV, imgNamed: "icon-bag", selector: #selector(bagDidTap), controller: self)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: bagBtn)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-23.0
        quantityLbl.frame = CGRect(x: x, y: 0.0, width: 30.0, height: 30.0)
    }
    
    @objc func backDidTap() {
        guard let navigationController = navigationController else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        for vc in navigationController.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                self.navigationController?.popToViewController(vc, animated: true)
                
            } else if vc.isKind(of: ShopVC.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
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
    
    func setupCV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.refreshControl = refresh
        collectionView.register(RecentlyViewedViewAllCVCell.self, forCellWithReuseIdentifier: RecentlyViewedViewAllCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        
        collectionView.collectionViewLayout = filteredLayout
        filteredLayout.scrollDirection = .vertical
        filteredLayout.delegate = self
        filteredLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                guard isInternetAvailable() else {
                    handleBackToTabHome()
                    return
                }
                
                //Reload
                self.products.shuffledInPlace()
                self.collectionView.reloadData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - Functions

extension FilteredVC {
    
    func createNotiLbl() {
        let txt = NSLocalizedString("Product does not exist", comment: "FilteredVC.swift: Product does not exist")
        existLbl.configureNameForCell(false, line: 2, txtColor: .black, fontSize: 15.0, isTxt: txt, fontN: fontNamedBold)
        existLbl.textAlignment = .center
        view.addSubview(existLbl)
        existLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            existLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            existLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        backDidTap()
    }
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
}

//MARK: - UICollectionViewDataSource

extension FilteredVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedViewAllCVCell.identifier, for: indexPath) as! RecentlyViewedViewAllCVCell
        cell.product = products[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension FilteredVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecentlyViewedViewAllCVCell
        let product = products[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            let productVC = ProductVC()
            productVC.product = product
            productVC.isFilteredVC = true
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FilteredVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let width = collectionView.frame.size.width
        let sizeItem = (width - (inset.left + inset.right + 2.0))/2.0
        return CGSize(width: sizeItem, height: sizeItem)
    }
}

//MARK: - FilteredLayoutDelegate

extension FilteredVC: FilteredLayoutDelegate {
    
    func collectionView(heightForPhotoAt indexPath: IndexPath) -> CGFloat {
        let sizeItem = (screenWidth - 6)/2.0
        let random = CGFloat.random(min: 80, max: 150)
        return CGFloat.random(min: sizeItem, max: sizeItem + random)
    }
}

//MARK: - InternetViewDelegate

extension FilteredVC: InternetViewDelegate {
    
    func handleReload() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                if let vc = vc as? HomeVC {
                    if vc.isHomeVC {
                        handleBackToTabHome()
                        
                    } else {
                        return
                    }
                }
                
            } else if vc.isKind(of: ShopVC.self) {
                if let vc = vc as? ShopVC {
                    if vc.isShopVC {
                        handleBackToTabShop()
                        
                    } else {
                        return
                    }
                }
            }
        }
    }
}

//MARK: - DarkMode

extension FilteredVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: darkModeView()
            case .dark: darkModeView(true)
            default: break
            }
        } else {
            darkModeView()
        }
    }
    
    private func darkModeView(_ isDarkMode: Bool = false) {
        let color: UIColor = isDarkMode ? .white : .black
        view.backgroundColor = isDarkMode ? .black : .white
        existLbl.textColor = color
        internetView.setupDarkMode(isDarkMode)
    }
}
