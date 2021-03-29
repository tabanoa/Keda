//
//  NotificationTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class NotificationTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "NotificationTVCell"
    
    let imgView = UIImageView()
    let titleLbl = UILabel()
    let bodyLbl = UILabel()
    let createTimeLbl = UILabel()
    let redCircleView = UIView()
    
    var type = ""
    var product: Product?
    var history: History?
    
    var modelU: NotificationUserModel! {
        didSet {
            redCircleView.isHidden = modelU.value == 0
            
            NotificationFB.fetchNotiFB(uid: modelU.notifUID) { (notifFB) in
                self.titleLbl.text = notifFB.title
                self.bodyLbl.text = notifFB.body
                
                let txt = NSLocalizedString("Just now", comment: "NotificationTVCell.swift: Just now")
                setupOnlineFor(time: notifFB.uid, txt: txt) { (txt) in
                    self.createTimeLbl.text = txt
                }
                
                self.type = notifFB.type
                
                switch true {
                case notifFB.type == newArrivalKey:
                    Product.fetchProductFromPrUID(prUID: notifFB.prUID) { (pr) in
                        self.product = pr
                    }
                case notifFB.type == saleOffKey:
                    guard let color = notifFB.colorKey, let size = notifFB.sizeKey else { return }
                    Product.fetchPrFromUIDColorSize(prUID: notifFB.prUID, color: color, size: size) { (pr) in
                        self.product = pr
                    }
                case notifFB.type == updatingOrdersKey:
                    History.fetchHistory(uid: notifFB.prUID) { (his) in
                        self.history = his
                    }
                case notifFB.type == promotionKey: break
                default: break
                }
            }
        }
    }
    
    //MARK: - Intitialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension NotificationTVCell {
    
    func configureCell() {
        //TODO: - ImageView
        let imgW: CGFloat = 40.0
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "icon-notif")
        imgView.layer.cornerRadius = imgW/2
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Lbl
        titleLbl.configureNameForCell(false, line: 2, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamedBold)
        bodyLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: 15.0, isTxt: "", fontN: fontNamed)
        createTimeLbl.configureNameForCell(false, line: 2, txtColor: .darkGray, fontSize: 15.0, isTxt: "", fontN: fontNamed)
        
        let views = [titleLbl, bodyLbl, createTimeLbl]
        let sv = createdStackView(views, spacing: 8.0, axis: .vertical, distribution: .fill, alignment: .leading)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let redW: CGFloat = 8.0
        redCircleView.isHidden = true
        redCircleView.clipsToBounds = true
        redCircleView.backgroundColor = UIColor(hex: 0xF33D30)
        redCircleView.layer.cornerRadius = redW/2
        contentView.addSubview(redCircleView)
        redCircleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.widthAnchor.constraint(equalToConstant: imgW),
            imgView.heightAnchor.constraint(equalToConstant: imgW),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            sv.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10.0),
            sv.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30.0),
            sv.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5.0),
            
            redCircleView.widthAnchor.constraint(equalToConstant: redW),
            redCircleView.heightAnchor.constraint(equalToConstant: redW),
            redCircleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            redCircleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0)
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension NotificationTVCell {
    
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
        titleLbl.textColor = isDarkMode ? .white : .black
        bodyLbl.textColor = isDarkMode ? .lightGray : .darkGray
        createTimeLbl.textColor = isDarkMode ? .lightGray : .darkGray
        
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
    }
}
