//
//  SearchContainerView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol SearchContainerViewDelegate: class {
    func handleViewAllDidTap()
    func handleDidSelect(_ tag: String)
    func handlePresent(_ pr: Product)
}

class SearchContainerView: UIView {
    
    //MARK: - Properties
    weak var delegate: SearchContainerViewDelegate?
    var tableView = UITableView(frame: .zero, style: .plain)
    
    var sVC: SearchVC!
    lazy var tags: [String] = {
        return Product.tags.count <= 0 ? sVC.suggestions : Product.tags
    }()
    
    let searchLbl = UILabel()
    let recentlyViewedLbl = UILabel()
    let viewAllBtn = UIButton()
    private var kView = UIView()
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension SearchContainerView {
    
    func setupContView(_ view: UIView, dl: SearchContainerViewDelegate) {
        tableView.configureTVNonSepar(groupColor, ds: self, dl: self, view: self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150.0
        
        tableView.register(RecentSearchesTVCell.self, forCellReuseIdentifier: RecentSearchesTVCell.identifier)
        tableView.register(RecentlyViewedTVCell.self, forCellReuseIdentifier: RecentlyViewedTVCell.identifier)
        
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        delegate = dl
    }
}

//MARK: - UITableViewDataSource

extension SearchContainerView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch true {
        case section == 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchesTVCell.identifier, for: indexPath) as! RecentSearchesTVCell
            cell.selectionStyle = .none
            cell.searchCV = self
            cell.collectionView.reloadData()
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentlyViewedTVCell.identifier, for: indexPath) as! RecentlyViewedTVCell
            cell.selectionStyle = .none
            cell.isHidden = Product.recentlyViewed.count <= 0
            cell.collectionView.reloadData()
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension SearchContainerView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? tableView.rowHeight : 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        kView = UIView().configureHeaderView(self, tableView: tableView)
        
        if section == 0 {
            searchLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 14.0, isTxt: "")
            searchLbl.configureHeaderTitle(kView)
            
            if Product.tags.count <= 0 {
                let recentStxt = NSLocalizedString("Search Suggestions", comment: "SearchContainerView.swift: Search Suggestions")
                searchLbl.text = recentStxt
                
            } else {
                let recentStxt = NSLocalizedString("Recent Searches", comment: "SearchContainerView.swift: Recent Searches")
                searchLbl.text = recentStxt
            }
            
        } else if section == 1 {
            guard Product.recentlyViewed.count != 0 else { return kView }
            
            let recentlyVtxt = NSLocalizedString("Recently Viewed", comment: "SearchContainerView.swift: Recently Viewed")
            recentlyViewedLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 14.0, isTxt: recentlyVtxt)
            recentlyViewedLbl.configureHeaderTitle(kView)
            
            guard Product.recentlyViewed.count > 4 else { return kView }
            setupViewAllBtn(viewAllBtn)
            viewAllBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 0.0, right: 0.0)
            viewAllBtn.contentVerticalAlignment = .bottom
            viewAllBtn.addTarget(self, action: #selector(viewAllDidTap), for: .touchUpInside)
            kView.addSubview(viewAllBtn)
            viewAllBtn.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                viewAllBtn.centerYAnchor.constraint(equalTo: recentlyViewedLbl.bottomAnchor, constant: -12.0),
                viewAllBtn.trailingAnchor.constraint(equalTo: kView.trailingAnchor, constant: -10.0),
            ])
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
    
    func setupViewAllBtn(_ btn: UIButton, txtC: UIColor = UIColor(hex: 0x2AB5EC)) {
        let viewAllTxt = NSLocalizedString("View All", comment: "SearchContainerView.swift: View All")
        let attributed = setupTitleAttri(viewAllTxt, txtColor: txtC, size: 14.0)
        btn.setAttributedTitle(attributed, for: .normal)
    }
    
    @objc func viewAllDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleViewAllDidTap()
        }
    }
}

//MARK: - RecentSearchesTVCellDelegate

extension SearchContainerView: RecentSearchesTVCellDelegate {
    
    func handleDidSelect(_ tag: String) {
        delegate?.handleDidSelect(tag)
    }
    
    func handleRemoveTag(tvCell: RecentSearchesTVCell, cvCell: RecentSearchesCVCell) {
        guard let indexPath = tvCell.collectionView.indexPath(for: cvCell) else { return }
        tableView.beginUpdates()
        
        let index = indexPath.item
        tags.remove(at: index)
        
        tvCell.collectionView.deleteItems(at: [indexPath])
        tvCell.collectionView.reloadData()
        
        if Product.tags.count > 0 {
            Product.tags.remove(at: index)
        }
        
        tableView.endUpdates()
    }
}

//MARK: - RecentlyViewedTVCellDelegate

extension SearchContainerView: RecentlyViewedTVCellDelegate {
    
    func handlePresent(_ pr: Product) {
        delegate?.handlePresent(pr)
    }
}

//MARK: - DarkMode

extension SearchContainerView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDMView()
            case .dark: setupDMView(true)
            default: break
            }
        } else {
            setupDMView()
        }
    }
    
    func setupDMView(_ isDarkMode: Bool = false) {
        tableView.backgroundColor = isDarkMode ? .black : groupColor
        searchLbl.textColor = isDarkMode ? .lightGray : .darkGray
        recentlyViewedLbl.textColor = isDarkMode ? .lightGray : .darkGray
        searchLbl.textColor = isDarkMode ? .lightGray : .darkGray
        kView.backgroundColor = isDarkMode ? .black : groupColor
        
        let viewAllC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
        setupViewAllBtn(viewAllBtn, txtC: viewAllC)
    }
}
