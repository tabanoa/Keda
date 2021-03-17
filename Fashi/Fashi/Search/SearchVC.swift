//
//  SearchVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SearchVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var searchController = UISearchController(searchResultsController: nil)
    private var containerView = SearchContainerView()
    
    lazy var allProducts: [Product] = []
    lazy var products: [Product] = []
    lazy var filter: [Product] = []
    lazy var suggestions: [String] = []
    
    private var recentSearchesModel: [RecentSearchesModel] = []
    
    private var isPush = true
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let tableV = containerView.tableView
        getRecentSearchesModelFromCoreData()
        getRecentSearchesModel(tableV)
        getRecentlyViewedModel(tableV)
        
        DispatchQueue.main.async {
            tableV.reloadData()
        }
        
        perform(#selector(self.searchActive), with: nil, afterDelay: 0.01)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
        setupDarkMode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeFromSuperview()
        searchController.isActive = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPush = true
    }
}

//MARK: - Configures

extension SearchVC {
    
    func setupSearchBar() {
        view.backgroundColor = .white
        createSearchBarController(searchController, navigationItem, resultU: self, vc: self, sbDl: self)
        searchController.delegate = self
    }
    
    @objc func searchActive() {
        searchController.searchBar.text = nil
        searchController.searchBar.becomeFirstResponder()
    }
    
    func setupContainerView() {
        containerView.setupContView(view, dl: self)
        containerView.sVC = self
    }
    
    func setupTableView() {
        tableView.register(SearchTVCell.self, forCellReuseIdentifier: SearchTVCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        kWindow!.addSubview(tableView)
        updateTableView()
    }
    
    func updateTableView() {
        searchController.searchBar.superview?.bringSubviewToFront(tableView)
        
        var tableFrame = CGRect(x: 0.0, y: 0.0,
                                width: screenWidth,
                                height: screenHeight)
        tableFrame.origin = view.convert(tableFrame.origin, to: nil)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.tableView.frame = tableFrame
        }
        
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 70.0
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15+58, bottom: 0.0, right: 15.0)
        tableView.contentInset = UIEdgeInsets(top: -40.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.reloadData()
        tableView.isHidden = true
    }
}

//MARK: - Functions

extension SearchVC {
    
    func getRecentSearchesModelFromCoreData() {
        recentSearchesModel = []
        RecentSearchesModel.fetchFromCoreData { (recentSearchesModel) in
            self.recentSearchesModel = recentSearchesModel
        }
    }
    
    func getRecentSearchesModel(_ tv: UITableView) {
        Product.tags.removeAll()
        RecentSearchesModel.fetchRecentSearches { (tags) in
            Product.tags = tags
            DispatchQueue.main.async {
                tv.reloadData()
            }
        }
    }
    
    func getRecentlyViewedModel(_ tv: UITableView) {
        Product.recentlyViewed.removeAll()
        RecentlyViewedModel.fetchRecentlyViewed { (products) in
            Product.recentlyViewed = products
            DispatchQueue.main.async {
                tv.reloadData()
            }
        }
    }
    
    func addCoreData(_ tag: String) {
        let model = RecentSearchesModel(tag: tag, createdTime: createTime())
        if !recentSearchesModel.contains(model) {
            let recent = RecentSearches(context: appDl.coreDataStack.managedObjectContext)
            recent.tag = model.tag
            recent.createdTime = model.createdTime
            appDl.coreDataStack.saveContext()
            getPath()
        }
    }
}

//MARK: - UISearchControllerDelegate

extension SearchVC: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("will dismiss search controller")
    }
}

//MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        containerView.isHidden = !searchText.isEmpty
        
        guard isInternetAvailable() else { return }
        tableView.isHidden = searchText.isEmpty
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !isInternetAvailable() { tableView.isHidden = true }
        internetView.setupInternetAvailable(view, dl: self, kHidden: false, completion: nil)
        
        guard let text = searchBar.text?.lowercased() else { return }
        handlePushVC(text)
    }
    
    func handlePushVC(_ text: String) {
        let filteredVC = FilteredVC()
        filteredVC.products = filter
        filteredVC.hidesBottomBarWhenPushed = true
        
        tableView.isHidden = true
        containerView.isHidden = true
        
        handleHUD(1.5, traitCollection: self.traitCollection) {
            guard self.isPush else { return }
            self.addCoreData(text)
            self.navigationController?.pushViewController(filteredVC, animated: true)
            self.isPush = false
        }
    }
}

//MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isActive() {
            return filter.count
            
        } else {
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTVCell.identifier, for: indexPath) as! SearchTVCell
        
        if isActive() {
            cell.product = filter[indexPath.item]
            
        } else {
            cell.product = products[indexPath.item]
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let product: Product
        if isActive() {
            product = filter[indexPath.item]
            
        } else {
            product = products[indexPath.item]
        }
        
        let productVC = ProductVC()
        productVC.isSearch = true
        productVC.product = product
        productVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

//MARK: - SearchContainerViewDelegate

extension SearchVC: SearchContainerViewDelegate {
    
    func handleViewAllDidTap() {
        handleHUD(traitCollection: traitCollection)
        delay(duration: 0.5) {
            self.handlePushFilted(Product.recentlyViewed)
        }
    }
    
    func handleDidSelect(_ tag: String) {
        addCoreData(tag)
        handleHUD(traitCollection: traitCollection)
        delay(duration: 0.5) {
            let products = Product.searchTapItems(self.allProducts, tag)
            self.handlePushFilted(products)
        }
    }
    
    func handlePushFilted(_ prs: [Product]) {
        let filteredVC = FilteredVC()
        filteredVC.products = prs
        filteredVC.titleTxt = "Shopping"
        filteredVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(filteredVC, animated: true)
    }
    
    func handlePresent(_ pr: Product) {
        let productVC = ProductVC()
        productVC.isRecentlyViewed = true
        productVC.product = pr
        navigationController?.pushViewController(productVC, animated: true)
    }
}

//MARK: - InternetViewDelegate

extension SearchVC: InternetViewDelegate {
    
    func handleReload() {
        guard isInternetAvailable() else { return }
        internetView.removeFromSuperview()
        perform(#selector(searchActive), with: nil, afterDelay: 0.01)
    }
}

//MARK: - UISearchResultsUpdating

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let text = searchText.lowercased()
        
        filter.removeAll()
        filter = Product.searchTapItems(products, text)
        
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

extension SearchVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: darkModeNaviBar()
            case .dark: darkModeNaviBar(true)
            default: break
            }
        } else {
            darkModeNaviBar()
        }
    }
    
    private func darkModeNaviBar(_ isDarkMode: Bool = false) {
        searchController.searchBar.customFontSearchBar(isDarkMode)
        perform(#selector(searchActive), with: nil, afterDelay: 0.01)
        
        if containerView.isHidden { containerView.isHidden = false }
        if !tableView.isHidden { tableView.isHidden = true }
        
        view.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        navigationController?.navigationBar.tintColor = isDarkMode ? .white : .black
        appDl.window?.tintColor = isDarkMode ? .white : .black
        containerView.setupDMView(isDarkMode)
    }
}
