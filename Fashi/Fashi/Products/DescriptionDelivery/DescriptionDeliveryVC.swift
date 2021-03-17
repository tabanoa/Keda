//
//  DescriptionDeliveryVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol DescriptionDeliveryVCDelegate: class {
    func handleAddBagDidTap(vc: DescriptionDeliveryVC)
}

class DescriptionDeliveryVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: DescriptionDeliveryVCDelegate?
    
    private let containerView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    private var kView = UIView()
    private let desLbl = UILabel()
    private let deliveredLbl = UILabel()
    
    private let sepatatorTopV = UIView()
    private let sepatatorBottomV = UIView()
    
    private let titleLbl = UILabel()
    private let cancelBtn = UIButton(type: .custom)
    private let bagBtn = UIButton()
    
    private let bagTitle = NSLocalizedString("ADD TO BAG", comment: "DescriptionDeliveryVC.swift: ADD TO BAG")
    
    var titleTxt = ""
    var desTxt = ""
    var deliveryTxt = ""
    var contentTxt = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Congfigure

extension DescriptionDeliveryVC {
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.6)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelDidTap))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        //TODO: - ContainerView
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        topView.backgroundColor = UIColor(hex: 0xEBEBEB, alpha: 0.6)
        containerView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SepatatorView
        sepatatorTopV.backgroundColor = UIColor(hex: 0xEBEBEB)
        topView.addSubview(sepatatorTopV)
        sepatatorTopV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BottomView
        bottomView.backgroundColor = .white
        containerView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SepatatorBottomView
        sepatatorBottomV.backgroundColor = UIColor(hex: 0xEBEBEB)
        bottomView.addSubview(sepatatorBottomV)
        sepatatorBottomV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleTopView
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: titleTxt, fontN: fontNamedBold)
        topView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CancelBtn
        cancelBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelBtn.tintColor = .black
        cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        topView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.sizeToFit()
        
        //TODO: - LeftBtn
        let attributed = setupTitleAttri(bagTitle)
        bagBtn.setAttributedTitle(attributed, for: .normal)
        bagBtn.backgroundColor = .black
        bagBtn.clipsToBounds = true
        bagBtn.layer.cornerRadius = 5.0
        bagBtn.addTarget(self, action: #selector(bagDidTap), for: .touchUpInside)
        bottomView.addSubview(bagBtn)
        bagBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: screenHeight*0.5),
            
            topView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50.0),
            
            sepatatorTopV.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            sepatatorTopV.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            sepatatorTopV.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            sepatatorTopV.heightAnchor.constraint(equalToConstant: 1.0),
            
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50.0),
            
            sepatatorBottomV.topAnchor.constraint(equalTo: bottomView.topAnchor),
            sepatatorBottomV.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            sepatatorBottomV.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            sepatatorBottomV.heightAnchor.constraint(equalToConstant: 1.0),
            
            titleLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            cancelBtn.widthAnchor.constraint(equalToConstant: 25.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 25.0),
            cancelBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            cancelBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            bagBtn.widthAnchor.constraint(equalToConstant: screenWidth - 40.0),
            bagBtn.heightAnchor.constraint(equalToConstant: 40.0),
            bagBtn.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            bagBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
        ])
        
        containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        UIView.animate(withDuration: 0.5) {
            self.containerView.transform = .identity
            self.containerView.alpha = 1.0
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelDidTap), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func setupTableView() {
        tableView.configureTVNonSepar(ds: self, dl: self, view: containerView)
        tableView.register(DescriptionTVCell.self, forCellReuseIdentifier: DescriptionTVCell.identifier)
        tableView.register(DeliveryOptionsTVCell.self, forCellReuseIdentifier: DeliveryOptionsTVCell.identifier)
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
    }
    
    @objc func cancelDidTap() {
        containerView.transform = .identity
        UIView.animate(withDuration: 0.5, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        }) { (_) in
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    @objc func bagDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleAddBagDidTap(vc: self)
        }
    }
}

//MARK: - UIGestureRecognizerDelegate

extension DescriptionDeliveryVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === view
    }
}

//MARK: - UITableViewDataSource

extension DescriptionDeliveryVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTVCell.identifier, for: indexPath) as! DescriptionTVCell
            cell.selectionStyle = .none
            cell.contentLbl.text = contentTxt
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryOptionsTVCell.identifier, for: indexPath) as! DeliveryOptionsTVCell
            cell.selectionStyle = .none
            
            let titleTxt = NSLocalizedString("Standard Saver", comment: "DescriptionDeliveryVC.swift: Standard Saver")
            cell.titleLbl.text = titleTxt
            cell.contentLbl.text = getDate()
            return cell
        }
    }
    
    private func getDate() -> String {
        let cDate = Date()
        let fDate = Date(timeIntervalSinceNow: TimeInterval((5*24*60*60)))
        let f = DateFormatter()
        f.dateFormat = "dd/MM"
        
        let currentDay = f.string(from: cDate)
        let futureDay = f.string(from: fDate)
        let str = currentDay + " - " + "\(futureDay)"
        return str
    }
}

//MARK: - UITableViewDelegate

extension DescriptionDeliveryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if section == 0 {
            desLbl.configureNameForCell(false, txtColor: .black, fontSize: 14.0, isTxt: desTxt)
            desLbl.configureHeaderTitle(kView)
            
        } else {
            deliveredLbl.configureNameForCell(false, txtColor: .black, fontSize: 14.0, isTxt: deliveryTxt)
            deliveredLbl.configureHeaderTitle(kView)
        }
        
        setupTraitCollection()
        return kView
    }
    
    private func setupTraitCollection() {
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
    
    private func setupDMView(_ isDarkMode: Bool = false) {
        kView.backgroundColor = isDarkMode ? .black : groupColor
        desLbl.textColor = isDarkMode ? .white : .black
        deliveredLbl.textColor = isDarkMode ? .white : .black
    }
}

//MARK: - DarkMode

extension DescriptionDeliveryVC {
    
    func setupDarkMode(_ isDarkMode: Bool = false) {
        containerView.backgroundColor = isDarkMode ? .black : .white
        topView.backgroundColor = isDarkMode ? .black : .white
        bottomView.backgroundColor = isDarkMode ? .black : .white
        tableView.backgroundColor = isDarkMode ? .black : .white
        titleLbl.textColor = isDarkMode ? .white : .black
        cancelBtn.tintColor = isDarkMode ? .white : .black
        
        let bagTxtC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(bagTitle, txtColor: bagTxtC)
        bagBtn.setAttributedTitle(attributed, for: .normal)
        bagBtn.backgroundColor = isDarkMode ? .white : .black
        
        let separC: UIColor = isDarkMode ? darkSeparatorColor : UIColor(hex: 0xEBEBEB)
        sepatatorTopV.backgroundColor = separC
        sepatatorBottomV.backgroundColor = separC
    }
}
