//
//  RecentlyViewedViewAllVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class RecentlyViewedViewAllVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let naContainerV = UIView()
    private let refresh = UIRefreshControl()
    
    private let filterBtn = UIButton()
    private let backBtn = UIButton()
    
    var products: [Product] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupCV()
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
    }
}

//MARK: - Configures

extension RecentlyViewedViewAllVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Filter
        filterBtn.configureFilterBtn(naContainerV, selector: #selector(filterDidTap), controller: self)

        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
    }
    
    @objc func filterDidTap() {
        let filterVC = FilterVC()
        filterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filterVC, animated: false)
    }
    
    @objc func backDidTap() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                navigationController?.setNavigationBarHidden(false, animated: true)
                navigationController?.popToViewController(vc, animated: true)
                
            } else if vc.isKind(of: WishlistVC.self) {
                navigationController?.setNavigationBarHidden(false, animated: true)
                navigationController?.popToViewController(vc, animated: true)
                
            } else if vc.isKind(of: ShopVC.self) {
                navigationController?.setNavigationBarHidden(false, animated: true)
                navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    func setupCV() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.refreshControl = refresh
        collectionView.register(RecentlyViewedViewAllCVCell.self, forCellWithReuseIdentifier: RecentlyViewedViewAllCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        
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
        let searchTF = UITextField()
        let contW = naContainerV.frame.width
        let tfW = contW-60
        searchTF.configureTF(self, naContainerV, xPos: (contW-tfW)/2.0, width: tfW, dl: self)
    }
}

//MARK: - UICollectionViewDataSource

extension RecentlyViewedViewAllVC: UICollectionViewDataSource {
    
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

extension RecentlyViewedViewAllVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecentlyViewedViewAllCVCell
        let product = products[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            let productVC = ProductVC()
            productVC.product = product
            productVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecentlyViewedViewAllVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = collectionView.contentInset
        let sizeItem = (collectionView.frame.size.width - (inset.left + inset.right + 2.0))/2.0
        return CGSize(width: sizeItem, height: sizeItem)
    }
}

//MARK: - UITextFieldDelegate

extension RecentlyViewedViewAllVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationController?.popViewController(animated: false)
    }
}

//MARK: - InternetViewDelegate

extension RecentlyViewedViewAllVC: InternetViewDelegate {
    
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
