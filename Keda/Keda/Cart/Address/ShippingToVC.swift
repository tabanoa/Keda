//
//  ShippingToVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ShippingToVCDelegate: class {
    func handleUseThisAddr(vc: ShippingToVC)
}

class ShippingToVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: ShippingToVCDelegate?
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let bottomView = ShippingBottomView()
    
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let addrTxt = NSLocalizedString("＋  Add New Address", comment: "ShippingToVC.swift: ＋  Add New Address")
    
    private var addresses: [Address] = []
    private var selectedAddr: Address? = nil
    private var isSelect = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupBottomView()
        setupTV()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAddress()
    }
}

//MARK: - Configures

extension ShippingToVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Address Book", comment: "ShippingToVC.swift: Address Book")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVSepar(groupColor, ds: self, dl: self, view: view)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.register(ShippingToTVCell.self, forCellReuseIdentifier: ShippingToTVCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddNewAddCell")
        tableView.rowHeight = 50.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    func setupBottomView() {
        bottomView.setupBottomView(view, dl: self)
    }
}

//MARK: - Functions

extension ShippingToVC {
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
            navigationController?.popViewController(animated: true)
        case .changed:
            if let interractiveTransition = interactiveTransition {
                interractiveTransition.update(progress)
            }
            
            shouldFinish = progress > percentThreshold
        case .cancelled, .failed:
            interactiveTransition.cancel()
        case .ended:
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
    
    func fetchAddress() {
        Address.fetchAddress { (addresses) in
            self.addresses = addresses.sorted(by: { $0.defaults && !$1.defaults })
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension ShippingToVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return addresses.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShippingToTVCell.identifier, for: indexPath) as! ShippingToTVCell
            let addr = addresses[indexPath.row]
            cell.delegate = self
            cell.selectionStyle = .none
            cell.addr = addr
            setupSelectedCell(addr, cell: cell)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewAddCell", for: indexPath)
            setupNewAddressBtn(cell)
            return cell
        }
    }
    
    func setupSelectedCell(_ addr: Address, cell: ShippingToTVCell) {
        selectedAddr = addr
        isSelect = addr.model.defaults
        cell.isSelect = isSelect
    }
    
    func setupNewAddressBtn(_ cell: UITableViewCell) {
        let newAddressBtn = ShowMoreBtn()
        let txtColor = addresses.count < 2 ? UIColor(hex: 0x2AB5EC) : .gray
        let attributed = setupTitleAttri(addrTxt, txtColor: txtColor, size: 17.0)
        newAddressBtn.setAttributedTitle(attributed, for: .normal)
        newAddressBtn.addTarget(self, action: #selector(newAddressDidTap), for: .touchUpInside)
        newAddressBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 15.0, bottom: 2.0, right: 15.0)
        newAddressBtn.contentHorizontalAlignment = .left
        newAddressBtn.contentVerticalAlignment = .center
        cell.contentView.addSubview(newAddressBtn)
        newAddressBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newAddressBtn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            newAddressBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            newAddressBtn.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            newAddressBtn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
        ])
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeBtn(newAddressBtn, false)
            case .dark: setupDarkModeBtn(newAddressBtn, true)
            default: break
            }
        } else {
            setupDarkModeBtn(newAddressBtn, false)
        }
    }
    
    func setupDarkModeBtn(_ btn: UIButton, _ isDarkMode: Bool) {
        let txtColorLight = addresses.count < 2 ? UIColor(hex: 0x2AB5EC) : .gray
        let txtColorDark = addresses.count < 2 ? UIColor(hex: 0x2687FB) : .lightGray
        let attC: UIColor = isDarkMode ? txtColorDark : txtColorLight
        let attributed = setupTitleAttri(addrTxt, txtColor: attC, size: 17.0)
        btn.setAttributedTitle(attributed, for: .normal)
    }
    
    @objc func newAddressDidTap(_ sender: UIButton) {
        guard addresses.count < 2 else { return }
        touchAnim(sender) {
            let addressVC = AddressVC()
            let titleNavi = NSLocalizedString("Add New Address", comment: "ShippingToVC.swift: Add New Address")
            let popUpTxt = NSLocalizedString("New address has been added", comment: "ShippingToVC.swift: New address has been added")
            
            addressVC.addresses = self.addresses
            addressVC.titleNavi = titleNavi
            addressVC.addNewAddrTxt = titleNavi
            addressVC.popUpTxt = popUpTxt
            addressVC.delegate = self
            addressVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate

extension ShippingToVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! ShippingToTVCell
            for addr in addresses { addr.model.defaults = false }
            let addr = addresses[indexPath.row]
            touchAnim(cell, frValue: 0.8) {
                self.selectedAddr = nil
                addr.model.defaults = true
                self.selectedAddr = addr
                self.isSelect = addr.model.defaults
                cell.isSelect = self.isSelect
                self.tableView.reloadData()
            }
            
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 170.0 }
        return tableView.rowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if section == 0 {
            let addressLbl = UILabel()
            let txt = NSLocalizedString("ADDRESSES ON FILE", comment: "ShippingToVC.swift: ADDRESSES ON FILE")
            addressLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
            addressLbl.configureHeaderTitle(kView)
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

//MARK: - ShippingBottomViewDelegate

extension ShippingToVC: ShippingBottomViewDelegate {
    
    func handleUseThisAddressDidTap() {
        guard isInternetAvailable() else { internetNotAvailable(); return }
        view.isUserInteractionEnabled = false
        
        let txt = NSLocalizedString("Success", comment: "ShippingToVC.swift: Success")
        handleInternet(txt, imgName: "icon-checkmark") {
            self.delegate?.handleUseThisAddr(vc: self)
        }
        
        for addr in addresses {
            addr.updateDefaults(addr: addr) { return }
        }
    }
}

//MARK: - ShippingToTVCellDelegate

extension ShippingToVC: ShippingToTVCellDelegate {
    
    func handleEditDidTap(_ cell: ShippingToTVCell) {
        let addressVC = AddressVC()
        let titleTxt = NSLocalizedString("Edit Address", comment: "ShippingToVC.swift: Edit Address")
        let addNewTxt = NSLocalizedString("Update", comment: "ShippingToVC.swift: Update")
        let popUpTxt = NSLocalizedString("Has Updated", comment: "ShippingToVC.swift: Has Updated")
        
        addressVC.titleNavi = titleTxt
        addressVC.addNewAddrTxt = addNewTxt
        addressVC.popUpTxt = popUpTxt
        addressVC.address = cell.addr
        addressVC.isEdit = true
        addressVC.cell = cell
        addressVC.delegate = self
        addressVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addressVC, animated: true)
    }
}

//MARK: - UINavigationControllerDelegate

extension ShippingToVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionCurve = .easeOut
            
        } else {
            interactiveTransition = nil
        }
        
        return interactiveTransition
    }
}

//MARK: - AddressVCDelegate

extension ShippingToVC: AddressVCDelegate {
    
    func handlePopVC(vc: AddressVC) {
        vc.navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

//MARK: - DarkMode

extension ShippingToVC {
    
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
