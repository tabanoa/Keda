//
//  ProductsListVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductsListVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private var searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView(frame: .zero, style: .grouped)
    private var hud = HUD()
    private let refresh = UIRefreshControl()
    private let addView = UIView()
    private let addBtn = UIButton()
    
    lazy var prsActive: [Product] = []
    lazy var prsNotActive: [Product] = []
    lazy var filter: [Product] = []
    
    private var filterIndexPath = IndexPath()
    private lazy var newArrivalsUID: [String] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupSearchBar()
        setupTableView()
        createAddView()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isInternetAvailable() else {
            addView.isHidden = true
            addBtn.isHidden = true
            searchController.searchBar.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if prsActive.count <= 0 {
            addView.isHidden = true
            addBtn.isHidden = true
            tableView.isHidden = true
            hud = createdHUD()
        }
        
        //TODO: - FetchData
        fetchData()
        
        let shared = NotificationFor.sharedInstance
        shared.fetchNotificationFrom(child: shared.newArrival) { (newArrivalsUID) in
            self.newArrivalsUID = newArrivalsUID
        }
    }
    
    func fetchData() {
        prsNotActive.removeAll()
        Product.fetchProductsNotActive { (products) in
            self.prsNotActive = products.sorted(by: { $0.createdTime < $1.createdTime })
            self.tableView.reloadData()
        }

        Product.fetchProducts { (products) in
            self.prsActive = products.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()
            removeHUD(self.hud, duration: 0.5) {
                self.tableView.isHidden = self.prsActive.count <= 0
                self.addView.isHidden = false
                self.addBtn.isHidden = false
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.searchBar.text = nil
        searchController.isActive = false
        definesPresentationContext = false
    }
}

//MARK: - Configures

extension ProductsListVC {
    
    func setupSearchBar() {
        createSearchBarController(searchController, navigationItem, resultU: self, vc: self, sbDl: self)
    }
    
    func setupTableView() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.refreshControl = refresh
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15+58, bottom: 0.0, right: 15.0)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        tableView.register(ProductsListTVCell.self, forCellReuseIdentifier: ProductsListTVCell.identifier)
        tableView.rowHeight = 60.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createAddView() {
        let addW: CGFloat = 50.0
        addView.backgroundColor = .white
        addView.clipsToBounds = true
        addView.layer.cornerRadius = addW/2
        addView.layer.masksToBounds = false
        addView.layer.shadowColor = UIColor.black.cgColor
        addView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        addView.layer.shadowRadius = 4.0
        addView.layer.shadowOpacity = 0.3
        addView.layer.shouldRasterize = true
        addView.layer.rasterizationScale = UIScreen.main.scale
        view.insertSubview(addView, aboveSubview: tableView)
        addView.translatesAutoresizingMaskIntoConstraints = false
        
        addBtn.setImage(UIImage(named: "icon-addPr"), for: .normal)
        addBtn.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        addBtn.addTarget(self, action: #selector(addDidTap), for: .touchUpInside)
        view.insertSubview(addBtn, aboveSubview: addView)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addView.widthAnchor.constraint(equalToConstant: addW),
            addView.heightAnchor.constraint(equalToConstant: addW),
            addView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            addView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            
            addBtn.widthAnchor.constraint(equalToConstant: addW),
            addBtn.heightAnchor.constraint(equalToConstant: addW),
            addBtn.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            addBtn.centerYAnchor.constraint(equalTo: addView.centerYAnchor),
        ])
    }
    
    @objc func addDidTap() {
        let categoriesTVC = CategoriesTVC(style: .grouped)
        categoriesTVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(categoriesTVC, animated: true)
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.async {
            delay(duration: 1.0) {
                self.fetchData()
                sender.endRefreshing()
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension ProductsListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard prsNotActive.count == 0 else { return 2 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if prsNotActive.count != 0 {
            if section == 0 {
                return prsNotActive.count
                
            } else {
                return isActive() ? filter.count : prsActive.count
            }
            
        } else {
            return isActive() ? filter.count : prsActive.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsListTVCell.identifier, for: indexPath) as! ProductsListTVCell
        let section = indexPath.section
        
        if prsNotActive.count != 0 {
            if section == 0 {
                cell.product = prsNotActive[indexPath.item]
                cell.delegate = self
                
            } else {
                cell.product = isActive() ? filter[indexPath.item] : prsActive[indexPath.item]
                cell.delegate = nil
                filterIndexPath = indexPath
            }
            
        } else {
            cell.product = isActive() ? filter[indexPath.item] : prsActive[indexPath.item]
            cell.delegate = nil
            filterIndexPath = indexPath
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProductsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if prsNotActive.count != 0 {
                let product = prsNotActive[indexPath.item]
                handlePushVC(product, indexPath)
                
            } else {
                let product = isActive() ? filter[indexPath.item] : prsActive[indexPath.item]
                handlePushVC(product, indexPath)
            }
            
        } else {
            let product = isActive() ? filter[indexPath.item] : prsActive[indexPath.item]
            handlePushVC(product, indexPath)
        }
    }
    
    private func handlePushVC(_ pr: Product, _ indexPath: IndexPath) {
        let productsListDetailVC = ProductsListDetailVC()
        productsListDetailVC.product = pr
        productsListDetailVC.indexPath = indexPath
        productsListDetailVC.delegate = self
        productsListDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productsListDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if prsNotActive.count != 0 { return 40 }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if prsNotActive.count != 0 { return 10 }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if prsNotActive.count != 0 {
            switch section {
            case 0:
                let notActLbl = UILabel()
                let txt = NSLocalizedString("NOT ACTIVE", comment: "ProductsListVC.swift: NOT ACTIVE")
                notActLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
                notActLbl.configureHeaderTitle(kView)
            default:
                let actLbl = UILabel()
                let txt = NSLocalizedString("ACTIVE", comment: "ProductsListVC.swift: ACTIVE")
                actLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
                actLbl.configureHeaderTitle(kView)
            }
        }
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: kView.backgroundColor = groupColor
            case .dark: kView.backgroundColor = .black
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        
        return kView
    }
}

//MARK: - ProductsListTVCellDelegate

extension ProductsListVC: ProductsListTVCellDelegate {
    
    func handleActiveDidTap(_ cell: ProductsListTVCell) {
        guard isInternetAvailable() else { return }
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let product = prsNotActive[indexPath.row]
        let newArr = NSLocalizedString("New Arrival - ", comment: "ProductsListVC.swift: New Arrival - ")
        let title = "\(newArr)\(product.type)"
        let body = "\(product.name) - \(product.price.formattedWithCurrency)"
        pushNotificationForInfo(keyName: notifKeyNewArrival, title: title, body: body)
        
        let modelFB = NotificationModel(title: title, body: body, prUID: product.uid, type: newArrivalKey)
        let notif = NotificationFB(model: modelFB)
        notif.saveNotification {
            self.newArrivalsUID.forEach({
                let modelU = NotificationUserModel(notifUID: notif.uid, value: 1)
                let notifU = NotificationUser()
                notifU.saveNotificationUser(userUID: $0, modelU)
            })
        }
        
        product.updateActiveForPr {
            let txt = NSLocalizedString("Success", comment: "ProductsListVC.swift: Success")
            handleInternet(txt, imgName: "icon-checkmark") {
                self.fetchData()
            }
        }
    }
}

//MARK: - ProductsListDetailVCDelegate

extension ProductsListVC: ProductsListDetailVCDelegate {
    
    func handleDeleteProduct(indexPath: IndexPath, vc: ProductsListDetailVC, pr: Product) {
        vc.navigationController?.popViewController(animated: true)
        fetchData()
        
        /*
        if indexPath.section == 0 {
            if prsNotActive.count != 0 {
                prsNotActive.remove(at: indexPath.row)
                tableView.reloadData()

            } else {
                let index = prsActive.firstIndex(of: pr)!
                prsActive.remove(at: index)
                tableView.reloadData()
            }

        } else {
            let index = prsActive.firstIndex(of: pr)!
            prsActive.remove(at: index)
            tableView.reloadData()
        }
 */
        
    }
}
//MARK: - UISearchBarDelegate

extension ProductsListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard isInternetAvailable() else {
            searchController.searchBar.isHidden = true
            tableView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        if filter.count <= 0 {
            searchBar.text = nil
            searchController.isActive = false
            definesPresentationContext = false
            return
            
        } else if filter.count == 1 {
            handlePushVC(filter.first!, filterIndexPath)
            
        } else if filter.count > 1 {
            let prsListSearchVC = ProductsListSearchVC()
            prsListSearchVC.products = filter
            prsListSearchVC.searchText = searchBar.text
            prsListSearchVC.delegate = self
            prsListSearchVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(prsListSearchVC, animated: true)
        }
    }
}

//MARK: - ProductsListSearchVCDelegate

extension ProductsListVC: ProductsListSearchVCDelegate {
    
    func handleDeletePr(_ vc: ProductsListSearchVC) {
        fetchData()
    }
}

//MARK: - UISearchResultsUpdating

extension ProductsListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let text = searchText.lowercased()
        
        filter.removeAll()
        filter = prsActive.filter({
            $0.name.lowercased().range(of: text,
                                       options: [.diacriticInsensitive, .caseInsensitive],
                                       range: nil,
                                       locale: .current) != nil
        })
        
        tableView.reloadData()
    }
    
    func isActive() -> Bool {
        return searchController.isActive && !isSearchText()
    }
    
    func isSearchText() -> Bool {
        return searchController.searchBar.text!.isEmpty
    }
}

//MARK: - InternetViewDelegate

extension ProductsListVC: InternetViewDelegate {
    
    func handleReload() {
        handleBackToTabPrList()
    }
}

//MARK: - DarkMode

extension ProductsListVC {
    
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
        tableView.backgroundColor = isDarkMode ? .black : .white
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        tableView.reloadData()
        
        addView.layer.shadowColor = isDarkMode ? UIColor.white.cgColor : UIColor.black.cgColor
        searchController.searchBar.customFontSearchBar(isDarkMode)
        navigationController?.navigationBar.tintColor = isDarkMode ? .white : .black
        appDl.window?.tintColor = isDarkMode ? .white : .black
        internetView.setupDarkMode(isDarkMode)
    }
}
