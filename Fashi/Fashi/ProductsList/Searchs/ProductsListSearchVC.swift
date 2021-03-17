//
//  ProductsListSearchVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductsListSearchVCDelegate: class {
    func handleDeletePr(_ vc: ProductsListSearchVC)
}

class ProductsListSearchVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: ProductsListSearchVCDelegate?
    private var searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var navView = UIView()
    private let backBtn = UIButton()
    
    lazy var products: [Product] = []
    lazy var filter: [Product] = []
    
    var searchText: String?
    var filterIndexPath = IndexPath()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupSearchBar()
        setupTableView()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isInternetAvailable() else {
            tableView.isHidden = true
            return
        }
        
        searchController.searchBar.text = searchText
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false
        definesPresentationContext = false
    }
}

//MARK: - Configures

extension ProductsListSearchVC {
    
    func setupSearchBar() {
        navView = UIView(frame: CGRect(x: 0.0, y: 1.0, width: screenWidth-30, height: 40.0))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navView)
        
        backBtn.frame.size = CGSize(width: 40.0, height: 40.0)
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 9.0, left: 0.0, bottom: 0.0, right: 0.0)
        backBtn.setImage(UIImage(named: "icon-back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backdidTap), for: .touchUpInside)
        
        let cancelTxt = NSLocalizedString("Cancel", comment: "ProductsListSearchVC.swift: Cancel")
        let searchBar = searchController.searchBar
        let width = navView.frame.width-40
        let height = navView.frame.height
        searchBar.frame.size = CGSize(width: width, height: height)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar.searchBarStyle = .prominent
        searchBar.customFontSearchBar()
        searchBar.setValue(cancelTxt, forKey: "cancelButtonText")
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        
        let views = [backBtn, searchBar]
        let sv = createdStackView(views, spacing: 5.0, axis: .horizontal, distribution: .fill, alignment: .top)
        sv.frame = navView.bounds
        navView.addSubview(sv)
    }
    
    @objc func backdidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15+58, bottom: 0.0, right: 15.0)
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        tableView.register(ProductsListSearchTVCell.self, forCellReuseIdentifier: ProductsListSearchTVCell.identifier)
        tableView.rowHeight = 60.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource

extension ProductsListSearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActive() ? filter.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsListSearchTVCell.identifier, for: indexPath) as! ProductsListSearchTVCell
        cell.product = isActive() ? filter[indexPath.item] : products[indexPath.item]
        filterIndexPath = indexPath
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProductsListSearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = isActive() ? filter[indexPath.item] : products[indexPath.item]
        handlePushVC(product, indexPath)
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
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

//MARK: - ProductsListDetailVCDelegate

extension ProductsListSearchVC: ProductsListDetailVCDelegate {
    
    func handleDeleteProduct(indexPath: IndexPath, vc: ProductsListDetailVC, pr: Product) {
        vc.navigationController?.popViewController(animated: true)
        
        let index = products.firstIndex(of: pr)!
        products.remove(at: index)
        tableView.reloadData()
        
        delegate?.handleDeletePr(self)
    }
}

//MARK: - ProductsListSearchVCDelegate

extension ProductsListSearchVC: ProductsListSearchVCDelegate {
    
    func handleDeletePr(_ vc: ProductsListSearchVC) {
        for v in vc.navigationController!.viewControllers {
            if v.isKind(of: ProductsListVC.self) {
                vc.navigationController?.popToViewController(v, animated: true)
                (v as! ProductsListVC).fetchData()
                (v as! ProductsListVC).tableView.reloadData()
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension ProductsListSearchVC: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.33) {
            self.backBtn.isHidden = true
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.33) {
            self.backBtn.isHidden = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != searchText else { return }
        
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

//MARK: - UISearchResultsUpdating

extension ProductsListSearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let text = searchText.lowercased()

        filter.removeAll()
        filter = products.filter({
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

//MARK: - DarkMode

extension ProductsListSearchVC {
    
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
        
        searchController.searchBar.customFontSearchBar(isDarkMode)
        navigationController?.navigationBar.tintColor = isDarkMode ? .white : .black
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
}
