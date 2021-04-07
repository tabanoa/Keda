//
//  ArrivalsDetailVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ArrivalsDetailVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let naContainerV = UIView()
    private let arrivalsDetailLayout = ArrivalsDetailLayout()
    private let refresh = UIRefreshControl()
    private let filterBtn = UIButton()
    private let backBtn = UIButton()
    private let searchTF = UITextField()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private var color: UIColor = .clear
    private var star: Int = 0
    
    lazy var arrivals: [Product] = []
    lazy var products: [Product] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupCV()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            collectionView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        //TODO - SearchTextField
        setupSearchTF()
        setupDarkMode()
        
        guard !appDl.isArrivalsDetailVC else { return }
        naContainerV.isHidden = true
        collectionView.isHidden = true
        let hud = createdHUD()
        
        removeHUD(hud) {
            self.naContainerV.isHidden = false
            self.collectionView.isHidden = false
            appDl.isArrivalsDetailVC = true
        }
    }
}

//MARK: - Configures

extension ArrivalsDetailVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Filter
        filterBtn.configureFilterBtn(naContainerV, selector: #selector(filterDidTap), controller: self)

        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
    }
    
    @objc func filterDidTap() {
        let filterVC = FilterVC()
        filterVC.kDelegate = self
        filterVC.allProducts = products
        filterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupCV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.refreshControl = refresh
        collectionView.register(ArrivalsDetailCVCell.self, forCellWithReuseIdentifier: ArrivalsDetailCVCell.identifier)
        
        collectionView.collectionViewLayout = arrivalsDetailLayout
        arrivalsDetailLayout.contentPadding = SpacingMode(horizontal: 2.0, vertical: 2.0)
        arrivalsDetailLayout.cellPadding = 2.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
                sender.endRefreshing()
            }
        }
    }
    
    func setupSearchTF() {
        let contW = naContainerV.frame.width
        let tfW = contW-60
        searchTF.configureTF(self, naContainerV, xPos: (contW-tfW)/2.0, width: tfW, dl: self)
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

extension ArrivalsDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrivals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArrivalsDetailCVCell.identifier, for: indexPath) as! ArrivalsDetailCVCell
        cell.arrival = arrivals[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ArrivalsDetailVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ArrivalsDetailCVCell
        let arrival = arrivals[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            let productVC = ProductVC()
            productVC.product = arrival
            productVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ArrivalsDetailVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 10.0))/2.0

        return CGSize(width: sizeItem, height: sizeItem)
    }
}

//MARK: - UITextFieldDelegate

extension ArrivalsDetailVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        let searchVC = SearchVC()
        searchVC.products = arrivals
        searchVC.allProducts = products
        searchVC.suggestions = Product.suggestions(products)
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: false)
    }
}

//MARK: - UINavigationControllerDelegate

extension ArrivalsDetailVC: UINavigationControllerDelegate {
    
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

//MARK: - FilterVCDelegate

extension ArrivalsDetailVC: FilteredVCDelegate {
    
    func handleDoneDidTap(_ color: String, _ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColorAndRating(color, rating, prs: arrivals) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ color: String, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByColor(color, prs: arrivals) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handleDoneDidTap(_ rating: Int, vc: FilterVC) {
        vc.handlePop()
        
        Product.filterByRating(rating, prs: arrivals) { (prs) in
            self.handlePushFilteredVC(prs)
        }
    }
    
    func handlePushFilteredVC(_ prs: [Product]) {
        let filteredVC = FilteredVC()
        filteredVC.products = prs
        filteredVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filteredVC, animated: false)
    }
}

//MARK: - InternetViewDelegate

extension ArrivalsDetailVC: InternetViewDelegate {
    
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
            }
        }
    }
}

//MARK: - DarkMode

extension ArrivalsDetailVC {
    
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
        searchTF.backgroundColor = isDarkMode ? darkColor : .white
        internetView.setupDarkMode(isDarkMode)
    }
}
