//
//  FilterVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol FilterVCDelegate: class {
    func backFilterDetailView()
}

protocol FilteredVCDelegate: class {
    func handleDoneDidTap(_ color: String, _ rating: Int, vc: FilterVC)
    func handleDoneDidTap(_ color: String, vc: FilterVC)
    func handleDoneDidTap(_ rating: Int, vc: FilterVC)
}

class FilterVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: FilterVCDelegate?
    weak var kDelegate: FilteredVCDelegate?
    let containerView = FilterContainerView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var color: String = ""
    var ratingStr: String = ""
    var rating: Int = 0
    lazy var allProducts: [Product] = []
    
    private lazy var names: [String] = {
        return [
            NSLocalizedString("Color", comment: "FilterVC.swift: Color"),
            NSLocalizedString("Rating", comment: "FilterVC.swift: Rating")
        ]
    }()
    
    private lazy var colors: [String] = []
    private lazy var ratings: [String] = {
        return [
            "⭑⭑⭑⭑⭑",
            "⭑⭑⭑⭑",
            "⭑⭑⭑",
            "⭑⭑",
            "⭑"
        ]
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePop), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePop))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        colors = Product.allColors(allProducts)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: - Configures

extension FilterVC {
    
    func setupUI() {
        view.backgroundColor = .black
        navigationItem.setHidesBackButton(true, animated: false)
        containerView.setupContView(view, dl: self)
    }
    
    func setupTableView() {
        tableView.configureTVSepar(ds: self, dl: self, view: containerView.centerView)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 20.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.register(FilterTVCell.self, forCellReuseIdentifier: FilterTVCell.identifier)
        tableView.rowHeight = 44.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.centerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.centerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.centerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.centerView.bottomAnchor),
        ])
    }
}

//MARK: - UITableViewDataSource

extension FilterVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVCell.identifier, for: indexPath) as! FilterTVCell
        cell.selectionStyle = .none
        cell.titleLbl.text = names[indexPath.row]
        cell.colorView.isHidden = indexPath.row != 0
        cell.subTitleLbl.isHidden = indexPath.row == 0
        
        if !cell.colorView.isHidden {
            let borderC: UIColor = color == "" ? .clear : .lightGray
            cell.colorView.layer.borderColor = borderC.cgColor
            cell.colorView.backgroundColor = color.getHexColor()
        }
        
        if !cell.subTitleLbl.isHidden { cell.subTitleLbl.text = ratingStr }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FilterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let filterDetailVC = FilterDetailVC()
        
        if indexPath.row == 0 {
            filterDetailVC.colors = colors
            filterDetailVC.selectedColor = color
            
        } else {
            filterDetailVC.ratings = ratings
            filterDetailVC.selectedRating = ratingStr
        }
        
        filterDetailVC.delegate = self
        filterDetailVC.filterVC = self
        addChild(filterDetailVC)
        containerView.centerView.addSubview(filterDetailVC.view)
        filterDetailVC.view.frame = containerView.centerView.bounds
        filterDetailVC.didMove(toParent: self)
        
        filterDetailVC.view.transform = CGAffineTransform(translationX: screenWidth*0.7, y: 0.0)
        filterDetailVC.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            filterDetailVC.view.transform = .identity
            filterDetailVC.view.alpha = 1.0
            self.containerView.centerView.alpha = 0.4
        }) { (_) in
            self.containerView.backBtn.isHidden = false
            self.containerView.centerView.alpha = 1.0
        }
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

//MARK: - FilterDetailVCDelegate

extension FilterVC: FilterDetailVCDelegate {
    
    func popVCColor(_ color: String, vc: FilterDetailVC) {
        self.color = color
        tableView.reloadData()
        vc.backFilterDetailView()
    }
    
    func popVCRating(_ ratingStr: String, rating: Int, vc: FilterDetailVC) {
        self.ratingStr = ratingStr
        self.rating = rating
        tableView.reloadData()
        vc.backFilterDetailView()
    }
}

//MARK: - UIGestureRecognizerDelegate

extension FilterVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === view
    }
}

//MARK: - FilterContainerViewDelegate

extension FilterVC: FilterContainerViewDelegate {
    
    func handleDoneDidTap() {
        if color != "", ratingStr == "" {
            handleHUD(traitCollection: traitCollection)
            kDelegate?.handleDoneDidTap(color, vc: self)
            
        } else if color == "", ratingStr != "" {
            handleHUD(traitCollection: traitCollection)
            kDelegate?.handleDoneDidTap(rating, vc: self)
            
        } else if color != "", ratingStr != "" {
            handleHUD(traitCollection: traitCollection)
            kDelegate?.handleDoneDidTap(color, rating, vc: self)
            
        } else {
            handlePop()
            return
        }
    }
    
    func handleClearAllDidTap() {
        color = ""
        ratingStr = ""
        tableView.reloadData()
        handlePop()
    }
    
    func handleBackDidTap() {
        delegate?.backFilterDetailView()
    }
    
    @objc func handlePop() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - DarkMode

extension FilterVC {
    
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
        tableView.backgroundColor = isDarkMode ? darkColor : .white
        tableView.separatorColor = isDarkMode ? UIColor(hex: 0x2E2E2E) : lightSeparatorColor
        containerView.setupDarkMode(isDarkMode)
    }
}
