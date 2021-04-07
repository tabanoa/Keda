//
//  CategoriesDetailVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesDetailVC: UIViewController {
    
    //MARK: - Properties
    let headerView = CategoriesDetailHV()
    private let contentView = CategoriesDetailContV()
    private let refresh = UIRefreshControl()
    
    private let internetView = InternetView()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    lazy var categories: [Product] = []
    lazy var products: [Product] = [] //If categories.count <= 0
    
    private var isLoad = true
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        updateUI()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        guard isInternetAvailable() else {
            headerView.isHidden = true
            contentView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        guard isLoad else { return }
        headerView.isHidden = true
        contentView.isHidden = true
        let hud = createdHUD()
        
        removeHUD(hud) {
            self.headerView.isHidden = false
            self.contentView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isLoad = false
    }
}

//MARK: - Configures

extension CategoriesDetailVC {
    
    func updateUI() {
        headerView.setupHeaderView(view, dl: self)
        
        refresh.frame.origin.x = view.center.x
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        contentView.categoriesDetailVC = self
        contentView.setupContentView(view, headerV: headerView, refresh: refresh, dl: self)
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                guard isInternetAvailable() else {
                    handleBackToTabHome()
                    return
                }
                
                self.categories.shuffledInPlace()
                self.contentView.collectionView.reloadData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - Functions

extension CategoriesDetailVC {
    
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

//MARK: - UINavigationControllerDelegate

extension CategoriesDetailVC: UINavigationControllerDelegate {
    
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

//MARK: - CategoriesDetailHVDelegate

extension CategoriesDetailVC: CategoriesDetailHVDelegate {
    
    func handleBackDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleSearchDidTap() {
        let searchVC = SearchVC()
        searchVC.products = categories.count != 0 ? categories : products
        searchVC.allProducts = products
        searchVC.suggestions = Product.suggestions(products)
        navigationController?.pushViewController(searchVC, animated: false)
    }
}

//MARK: - CategoriesDetailContVDelegate

extension CategoriesDetailVC: CategoriesDetailContVDelegate {
    
    func handleCVDidTap(_ product: Product) {
        let productVC = ProductVC()
        productVC.product = product
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func handleScrollDown() {
        UIView.animate(withDuration: 0.5) {
            self.headerView.stackView.isHidden = true
            self.headerView.shopLbl.text = self.headerView.titleTxt
            self.headerView.shopLbl.textColor = defaultColor
            self.contentView.contVTopCons.constant = -screenWidth*0.77
            self.contentView.layoutIfNeeded()
        }
    }
    
    func handleScrollUp() {
        UIView.animate(withDuration: 0.5) {
            self.headerView.stackView.isHidden = false
            self.headerView.shopLbl.text = "Rent"
            self.headerView.shopLbl.textColor = .white
            self.contentView.contVTopCons.constant = -screenWidth*0.6
            self.contentView.layoutIfNeeded()
        }
    }
}

//MARK: - InternetViewDelegate

extension CategoriesDetailVC: InternetViewDelegate {
    
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
                
            } else if vc.isKind(of: WishlistVC.self) {
                if let vc = vc as? WishlistVC {
                    if vc.isWishlistVC {
                        handleBackToTabWishlish()
                        
                    } else {
                        return
                    }
                }
            }
        }
    }
}

//MARK: - DarkMode

extension CategoriesDetailVC {
    
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
        view.backgroundColor = isDarkMode ? .black : .white
        headerView.setupDarkMode(isDarkMode)
        contentView.setupDarkMode(isDarkMode)
        internetView.setupDarkMode(isDarkMode)
    }
}
