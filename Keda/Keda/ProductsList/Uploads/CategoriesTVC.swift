//
//  CategoriesTVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class CategoriesTVC: UITableViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    
    lazy var categories: [Category] = {
        return Category.fetchCategories()
    }()
    
    var selectedName = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        setupDarkMode()
    }
}

//MARK: - Configures

extension CategoriesTVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let titleTxt = NSLocalizedString("Categories", comment: "CategoriesTVC.swift: Categories")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 44.0
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15.0)
        tableView.register(CategoriesTVCell.self, forCellReuseIdentifier: CategoriesTVCell.identifier)
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension CategoriesTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTVCell.identifier, for: indexPath) as! CategoriesTVCell
        cell.selectionStyle = .none
        
        let category = categories[indexPath.row]
        cell.category = category
        configureCell(category.name, cell: cell)
        return cell
    }
    
    func configureCell(_ name: String, cell: CategoriesTVCell) {
        if selectedName == name {
            cell.accessoryType = .checkmark
            
        } else {
            cell.accessoryType = .disclosureIndicator
        }
    }
}

//MARK: - UITableViewDelegate

extension CategoriesTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesTVCell else { return }
        touchAnim(cell, frValue: 0.8) {
            let category = self.categories[indexPath.row]
            self.selectedName = ""
            self.selectedName = category.name
            cell.accessoryType = .checkmark
            self.tableView.reloadData()
            
            let categoriesColorsCVC = CategoriesColorsCVC(collectionViewLayout: UICollectionViewFlowLayout())
            categoriesColorsCVC.category = category.name
            self.navigationController?.pushViewController(categoriesColorsCVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}

//MARK: - DarkMode

extension CategoriesTVC {
    
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
    }
}
