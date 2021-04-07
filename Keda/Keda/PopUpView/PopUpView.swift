//
//  PopUpView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

@objc protocol PopUpViewDelegate: class {
    @objc optional func fetchQuantity(_ index: Int, view: PopUpView, cell: CartItemTVCell)
    @objc optional func fetchCountry(_ country: String, view: PopUpView)
    @objc optional func fetchState(_ state: String, view: PopUpView)
    @objc optional func fetchCity(_ city: String, view: PopUpView)
    func handleCancelDidTap(_ view: PopUpView)
}

class PopUpView: UIView {
    
    //MARK: - Properties
    weak var delegate: PopUpViewDelegate?
    private let cancelBtn = ShowMoreBtn()
    private let topView = UIView()
    private let titleLbl = UILabel()
    
    var quantities: [Int] = []
    var quantity: Int = 0
    
    var countries: [String] = []
    var country = ""
    
    var states: [String] = []
    var state = ""
    
    var cities: [String] = []
    var city = ""
    
    var naviTitle = ""
    var index: Int = 0
    
    var cell: CartItemTVCell!
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x000000, alpha: 0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension PopUpView {
    
    func setupUI(_ containerView: UIView) {
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        containerView.alpha = 0.0
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            containerView.heightAnchor.constraint(equalToConstant: screenWidth + 50.0),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
        ])
    }
    
    func setupTV(_ containerView: UIView, _ tableView: UITableView) {
        topView.backgroundColor = .white
        containerView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CancelBtn
        cancelBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelBtn.tintColor = .black
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        topView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: naviTitle, fontN: fontNamedBold)
        topView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.2)
        topView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.configureTVNonSepar(ds: self, dl: self, view: containerView)
        tableView.register(PopUpTVCell.self, forCellReuseIdentifier: PopUpTVCell.identifier)
        tableView.rowHeight = 44.0
        
        NSLayoutConstraint.activate([
            topView.heightAnchor.constraint(equalToConstant: 50.0),
            topView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            cancelBtn.widthAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -5.0),
            cancelBtn.topAnchor.constraint(equalTo: topView.topAnchor, constant: 5.0),
            
            titleLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        tableView.alpha = 0.0
        containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        UIView.animate(withDuration: 0.5, animations: {
            containerView.transform = .identity
            containerView.alpha = 1.0
            tableView.alpha = 1.0
        }) { _ in
            self.handleDispatchQueue(tableView)
        }
    }
    
    func handleDispatchQueue(_ tableView: UITableView) {
        DispatchQueue.main.async {
            if self.quantity != 0 {
                self.handleScroll(tableView, self.quantity)
            }
            
            if self.country != "" {
                for (k, _) in self.countries.enumerated() {
                    if self.countries[k] == self.country {
                        self.handleScroll(tableView, k)
                    }
                }
            }
            
            if self.state != "" {
                for (k, _) in self.states.enumerated() {
                    if self.states[k] == self.state {
                        self.handleScroll(tableView, k)
                    }
                }
            }
            
            if self.city != "" {
                for (k, _) in self.cities.enumerated() {
                    if self.cities[k] == self.city {
                        self.handleScroll(tableView, k)
                    }
                }
            }
        }
    }
    
    func handleScroll(_ tableView: UITableView, _ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func handleCancel(_ containerView: UIView, _ tableView: UITableView) {
        containerView.transform = .identity
        UIView.animate(withDuration: 0.33, animations: {
            containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            containerView.alpha = 0.0
            tableView.alpha = 0.0
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleCancelDidTap(self)
        }
    }
}

//MARK: - UITableViewDataSource

extension PopUpView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if quantities.count != 0 { return quantities.count }
        if countries.count != 0 { return countries.count }
        if states.count != 0 { return states.count }
        if cities.count != 0 { return cities.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopUpTVCell.identifier, for: indexPath) as! PopUpTVCell
        if quantities.count != 0 {
            cell.label.text = "\(quantities[indexPath.row])"
        }
        
        if countries.count != 0 {
            cell.label.text = "\(countries[indexPath.row])".capitalized
        }
        
        if states.count != 0 {
            cell.label.text = "\(states[indexPath.row])".capitalized
        }
        
        if cities.count != 0 {
            cell.label.text = "\(cities[indexPath.row])".capitalized
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension PopUpView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if quantities.count != 0 {
            var index = indexPath.row
            if index == 0 { index = 1 }
            delegate?.fetchQuantity?(quantities[index], view: self, cell: cell)
        }
        
        if countries.count != 0 {
            delegate?.fetchCountry?(countries[indexPath.row], view: self)
        }
        
        if states.count != 0 {
            delegate?.fetchState?(states[indexPath.row], view: self)
        }
        
        if cities.count != 0 {
            delegate?.fetchCity?(cities[indexPath.row], view: self)
        }
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

//MARK: - DarkMode

extension PopUpView {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    func setupDarkMode() {
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
        cancelBtn.tintColor = isDarkMode ? .white : .black
        topView.backgroundColor = isDarkMode ? .black : .white
        titleLbl.textColor = isDarkMode ? .white : .black
    }
}
