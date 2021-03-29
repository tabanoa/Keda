//
//  CategoriesColorSizeTVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Firebase

class CategoriesColorSizeTVC: UITableViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    private var refresh = UIRefreshControl()
    private let cancelBtn = ShowMoreBtn()
    private let doneBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    
    private let cancelTxt = NSLocalizedString("Cancel", comment: "CategoriesColorSizeTVC.swift: Cancel")
    private let doneTxt = NSLocalizedString("Done", comment: "CategoriesColorSizeTVC.swift: Done")
    
    lazy var selectedColors: [UIColor] = []
    lazy var selectedSizes: [String] = []
    
    lazy var prColors: [ProductColor] = []
    lazy var tags: [String] = []
    
    var category: String = ""
    var prUID: String = ""
    var type: String = ""
    
    lazy var prInfo: ProductInfoModel! = {
        return ProductInfoModel(name: "", price: 0.0, saleOff: 0.0, imageLinks: [], description: "")
    }()
    
    private var product: Product?
    private lazy var savePrColors: [ProductColor] = []
    private lazy var savePrSizes: [ProductSize] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for color in selectedColors {
            var prSizes: [ProductSize] = []
            
            defer {
                let prColor = ProductColor(color: color.getHexStr(), prSizes: prSizes)
                if !prColors.contains(prColor) {
                    prColors.append(prColor)
                    tableView.reloadData()
                }
            }

            for size in selectedSizes {
                let prSize = ProductSize(size: size, prInfoModel: prInfo)
                if !prSizes.contains(prSize) {
                    prSizes.append(prSize)
                }
            }
        }
    }
}

//MARK: - Configures

extension CategoriesColorSizeTVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Cancel
        let attributedCancel = setupTitleAttri(cancelTxt, size: 17.0)
        let isCancel = cancelTxt == "Cancel" ? true : false
        cancelBtn.setAttributedTitle(attributedCancel, for: .normal)
        cancelBtn.frame = CGRect(x: -5.0, y: 0.0, width: isCancel ? 60:40, height: 40.0)
        cancelBtn.contentMode = .left
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        naContainerV.addSubview(cancelBtn)
        
        //TODO: - Title
        titleLbl.configureTitleForNavi(naContainerV, isTxt: category)
        
        //TODO: - Done
        let attributedDone = setupTitleAttri(doneTxt, size: 17.0)
        doneBtn.setAttributedTitle(attributedDone, for: .normal)
        doneBtn.frame = CGRect(x: naContainerV.frame.width-45.0, y: 0.0, width: 60.0, height: 40.0)
        doneBtn.contentMode = .right
        doneBtn.addTarget(self, action: #selector(doneDidTap), for: .touchUpInside)
        doneBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        naContainerV.addSubview(doneBtn)
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            handleMessageAlert(vc: self, traitCollection: self.traitCollection) {
                self.handlePopToVC {}
            }
        }
    }
    
    @objc func doneDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let hud = createdHUD()
            let model = ProModel(uid: self.prUID, createdTime: createTime(), prColors: self.prColors, type: self.type, tags: self.tags, active: false)
            self.product = Product(prModel: model)
            
            guard let pr = self.product else { return }
            DispatchQueue.global(qos: .background).async {
                Product.savePr(pr) {
                    delay(duration: 2.0) {
                        self.handlePopToVC {
                            hud.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    
    func handlePopToVC(completion: @escaping () -> Void) {
        guard let navi = navigationController else { return }
        for vc in navi.viewControllers {
            if vc.isKind(of: ProductsListVC.self) {
                self.navigationController?.popToViewController(vc, animated: true)
                completion()
            }
        }
    }
    
    func updateUI() {
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
        tableView.backgroundColor = groupColor
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = 44.0
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15.0)
        tableView.register(CategoriesColorSizeTVCell.self, forCellReuseIdentifier: CategoriesColorSizeTVCell.identifier)
        tableView.reloadData()
    }
    
    @objc func handleRefresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            delay(duration: 1.0) { self.refresh.endRefreshing() }
        }
    }
}

//MARK: - UITableViewDataSource

extension CategoriesColorSizeTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return prColors.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prColors[section].prSizes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesColorSizeTVCell.identifier, for: indexPath) as! CategoriesColorSizeTVCell
        let prColor = prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.sizeLbl.text = prSize.size
        cell.images = prSize.prInfoModel.images
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CategoriesColorSizeTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesColorSizeTVCell else { return }
        cell.collectionView.reloadData()
        tableView.reloadData()
        
        let prColor = prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        let prModel = prSize.prInfoModel
        touchAnim(cell, frValue: 0.8) {
            self.handlePresent(cell, prInfo: prModel, indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        let rect = CGRect(x: 15.0, y: 2.5, width: 35.0, height: 35.0)
        let colorView = UIView(frame: rect)
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 3.0
        colorView.layer.borderColor = UIColor.gray.cgColor
        colorView.layer.borderWidth = 0.5
        colorView.backgroundColor = prColors[section].color.getHexColor()
        kView.addSubview(colorView)
        
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
    
    func handlePresent(_ cell: CategoriesColorSizeTVCell, prInfo: ProductInfoModel, indexPath: IndexPath) {
        let categoriesInfoTVC = CategoriesInfoTVC(style: .grouped)
        let prColor = prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        
        let color = prColor.color
        let size = prSize.size
        
        categoriesInfoTVC.prUID = prUID
        categoriesInfoTVC.type = type
        categoriesInfoTVC.kTags = tags
        categoriesInfoTVC.category = category
        categoriesInfoTVC.kName = prInfo.name
        categoriesInfoTVC.kPrice = prInfo.price
        categoriesInfoTVC.kDescription = prInfo.description
        categoriesInfoTVC.kSaleOff = prInfo.saleOff
        categoriesInfoTVC.kImages = prInfo.images
        categoriesInfoTVC.kImageLinks = []
        categoriesInfoTVC.cell = cell
        categoriesInfoTVC.kColor = color
        categoriesInfoTVC.kSize = size
        categoriesInfoTVC.delegate = self
        categoriesInfoTVC.isEdit = false
        navigationController?.pushViewController(categoriesInfoTVC, animated: true)
    }
}

//MARK: - CategoriesColorSizeTVCellDelegate

extension CategoriesColorSizeTVC: CategoriesColorSizeTVCellDelegate {
    
    func handleDidSelect(_ cell: CategoriesColorSizeTVCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let prColor = prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        let prInfo = prSize.prInfoModel
        handlePresent(cell, prInfo: prInfo, indexPath: indexPath)
    }
}

//MARK: - CategoriesInfoTVCDelegate

extension CategoriesColorSizeTVC: CategoriesInfoTVCDelegate {
    
    func fetchPrInfo(_ prInfo: ProductInfoModel, vc: CategoriesInfoTVC, cell: CategoriesColorSizeTVCell, tags: [String]) {
        self.tags = tags
        vc.navigationController?.popViewController(animated: true)
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let section = indexPath.section
        let item = indexPath.item
        
        self.prInfo = prInfo
        self.prColors[section].prSizes[item].prInfoModel = prInfo
        reload(cell)
    }
    
    func reload(_ cell: CategoriesColorSizeTVCell) {
        cell.collectionView.reloadData()
        tableView.reloadData()
    }
}

//MARK: - DarkMode

extension CategoriesColorSizeTVC {
    
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
        view.backgroundColor = isDarkMode ? .black : groupColor
        tableView.backgroundColor = isDarkMode ? .black : groupColor
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        tableView.reloadData()
    }
}
