//
//  FilterDetailVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol FilterDetailVCDelegate: class {
    func popVCColor(_ color: String, vc: FilterDetailVC)
    func popVCRating(_ ratingStr: String, rating: Int, vc: FilterDetailVC)
}

class FilterDetailVC: UIViewController {
    
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    var filterVC: FilterVC!
    weak var delegate: FilterDetailVCDelegate?
    
    var ratings: [String] = []
    var colors: [String] = []
    
    var selectedRating: String = ""
    var selectedColor: String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: - Configures

extension FilterDetailVC {
    
    func updateUI() {
        view.backgroundColor = .white
        filterVC.delegate = self
        
        //TODO: - TableView
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.register(FilterDetailColorTVCell.self, forCellReuseIdentifier: FilterDetailColorTVCell.identifier)
        tableView.register(FilterDetailRatingTVCell.self, forCellReuseIdentifier: FilterDetailRatingTVCell.identifier)
        tableView.rowHeight = 44.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - FilterVCDelegate

extension FilterDetailVC: FilterVCDelegate {
    
    func backFilterDetailView() {
        filterVC.containerView.backBtn.isHidden = true
        view.transform = .identity
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(translationX: screenWidth, y: 0.0)
            self.view.alpha = 0.0
        }) { (_) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}

//MARK: - UITableViewDataSource

extension FilterDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return colors.count }
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterDetailColorTVCell.identifier, for: indexPath) as! FilterDetailColorTVCell
            let color = colors[indexPath.item]
            cell.colorView.backgroundColor = color.getHexColor()
            cell.accessoryType = selectedColor == color ? .checkmark : .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterDetailRatingTVCell.identifier, for: indexPath) as! FilterDetailRatingTVCell
            let name = ratings[indexPath.row]
            cell.titleLbl.text = name
            cell.accessoryType = selectedRating == name ? .checkmark : .none
            return cell
        }
    }
    
    func colorView(_ cell: UITableViewCell, bgColor: UIColor = .white) {
        let width = cell.frame.height-14
        let rect = CGRect(x: 15.0, y: 7.0, width: width, height: width)
        let view = UIView(frame: rect)
        view.backgroundColor = bgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 3.0
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        cell.addSubview(view)
    }
}

//MARK: - UITableViewDelegate

extension FilterDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            filterVC.containerView.clearAllBtn.isHidden = false
            selectedColor = colors[indexPath.row]
            cell.accessoryType = .checkmark
            delegate?.popVCColor(selectedColor, vc: self)
            
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            filterVC.containerView.clearAllBtn.isHidden = false
            selectedRating = ratings[indexPath.row]
            cell.accessoryType = .checkmark
            
            let rating: Int
            switch indexPath.row {
            case 0: rating = 5
            case 1: rating = 4
            case 2: rating = 3
            case 3: rating = 2
            default: rating = 1
            }
            
            delegate?.popVCRating(selectedRating, rating: rating, vc: self)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
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

//MARK: - DarkMode

extension FilterDetailVC {
    
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
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
    }
}
