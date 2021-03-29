//
//  ShippingToTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ShippingToTVCellDelegate: class {
    func handleEditDidTap(_ cell: ShippingToTVCell)
}

class ShippingToTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ShippingToTVCell"
    
    weak var delegate: ShippingToTVCellDelegate?
    let nameLbl = UILabel()
    let streetLine1Lbl = UILabel()
    let streetLine2Lbl = UILabel()
    let countryLbl = UILabel()
    let stateLbl = UILabel()
    let cityLbl = UILabel()
    let zipcodeLbl = UILabel()
    let editBtn = ShowMoreBtn()
    let editImgView = UIImageView()
    let circleOutside = UIView()
    let circleInside = UIView()
    let outsideLayer = CAShapeLayer()
    
    private let txt = NSLocalizedString("Edit", comment: "ShippingToTVCell.swift: Edit")
    
    private let didSelectColor = UIColor(hex: 0x2AB5EC)
    private let deselectColor = UIColor(hex: 0xDEDEDE)
    
    var isSelect: Bool = false {
        didSet {
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified: setupLight()
                case .dark: setupDark()
                default: break
                }
            } else {
                setupLight()
            }
        }
    }
    
    var addr: Address! {
        didSet {
            countryLbl.text = addr.country
            nameLbl.text = addr.country == "Canada" ?
                addr.lastName + " " + addr.firstName :
                addr.firstName + " " + addr.lastName
            streetLine1Lbl.text = addr.addrLine1
            stateLbl.text = addr.state
            cityLbl.text = addr.city + ", "
            zipcodeLbl.text = addr.zipcode
            streetLine2Lbl.text = addr.addrLine2
            streetLine2Lbl.isHidden = addr.addrLine2 == nil || addr.addrLine2 == ""
            isSelect = addr.defaults
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension ShippingToTVCell {
    
    func configureCell() {
        //TODO: - OutsideView
        let outsideH: CGFloat = 25.0
        circleOutside.backgroundColor = .clear
        circleOutside.clipsToBounds = true
        circleOutside.layer.cornerRadius = outsideH/2
        contentView.addSubview(circleOutside)
        circleOutside.translatesAutoresizingMaskIntoConstraints = false
        
        let insideH: CGFloat = 11.0
        circleInside.backgroundColor = .clear
        circleInside.clipsToBounds = true
        circleInside.layer.cornerRadius = insideH/2
        contentView.addSubview(circleInside)
        circleInside.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Lbl
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "Jack ", fontN: fontNamedBold)
        streetLine1Lbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "123 street", fontN: fontNamed)
        streetLine2Lbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamed)
        cityLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "An Khe town, ", fontN: fontNamed)
        stateLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "Gia Lai province", fontN: fontNamed)
        countryLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "Vietnam", fontN: fontNamed)
        zipcodeLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "600000", fontN: fontNamed)
        
        let views1 = [cityLbl, stateLbl]
        let sv1 = createdStackView(views1, spacing: 0.0, axis: .horizontal, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [nameLbl, streetLine1Lbl, streetLine2Lbl, sv1, countryLbl, zipcodeLbl]
        let sv2 = createdStackView(views2, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .leading)
        contentView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Btn
        let attributes = [NSAttributedString.Key.font: UIFont(name: fontNamedBold, size: 13.0)!,
                          NSAttributedString.Key.foregroundColor : didSelectColor]
        let attributed = NSMutableAttributedString(string: txt, attributes: attributes)
        editBtn.setAttributedTitle(attributed, for: .normal)
        editBtn.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        editBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        editBtn.contentMode = .right
        
        let iconH: CGFloat = 15.0
        editImgView.image = UIImage(named: "icon-pencil")?.withRenderingMode(.alwaysTemplate)
        editImgView.tintColor = didSelectColor
        editImgView.clipsToBounds = true
        editImgView.contentMode = .scaleAspectFit
        editImgView.translatesAutoresizingMaskIntoConstraints = false
        editImgView.widthAnchor.constraint(equalToConstant: iconH).isActive = true
        editImgView.heightAnchor.constraint(equalToConstant: iconH).isActive = true
        
        let views3 = [editImgView, editBtn]
        let sv3 = createdStackView(views3, spacing: 2.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv3)
        sv3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleOutside.widthAnchor.constraint(equalToConstant: outsideH),
            circleOutside.heightAnchor.constraint(equalToConstant: outsideH),
            circleOutside.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            circleOutside.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            
            sv2.leadingAnchor.constraint(equalTo: circleOutside.trailingAnchor, constant: 8.0),
            sv2.topAnchor.constraint(equalTo: circleOutside.topAnchor),
            sv2.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -30.0),
            
            sv3.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0),
            sv3.bottomAnchor.constraint(equalTo: sv2.bottomAnchor),
            
            circleInside.widthAnchor.constraint(equalToConstant: insideH),
            circleInside.heightAnchor.constraint(equalToConstant: insideH),
            circleInside.centerXAnchor.constraint(equalTo: circleOutside.centerXAnchor),
            circleInside.centerYAnchor.constraint(equalTo: circleOutside.centerYAnchor),
        ])
        
        //TODO: - Outside - Inside View
        let outsideR = CGRect(origin: .zero, size: CGSize(width: outsideH, height: outsideH))
        outsideLayer.path = UIBezierPath(ovalIn: outsideR).cgPath
        outsideLayer.strokeColor = deselectColor.cgColor
        outsideLayer.fillColor = UIColor.clear.cgColor
        outsideLayer.lineWidth = 6.5
        circleOutside.layer.addSublayer(outsideLayer)
        
        setupDarkMode()
    }
    
    @objc func editDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleEditDidTap(self)
        }
    }
}

//MARK: - DarkMode

extension ShippingToTVCell {
    
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
        let attC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : didSelectColor
        let attributes = [NSAttributedString.Key.font: UIFont(name: fontNamedBold, size: 13.0)!,
                          NSAttributedString.Key.foregroundColor : attC]
        let attributed = NSMutableAttributedString(string: txt, attributes: attributes)
        editBtn.setAttributedTitle(attributed, for: .normal)
        editImgView.tintColor = attC
        nameLbl.textColor = isDarkMode ? .white : .black
        streetLine1Lbl.textColor = isDarkMode ? .white : .black
        streetLine2Lbl.textColor = isDarkMode ? .white : .black
        countryLbl.textColor = isDarkMode ? .white : .black
        zipcodeLbl.textColor = isDarkMode ? .white : .black
        stateLbl.textColor = isDarkMode ? .white : .black
        cityLbl.textColor = isDarkMode ? .white : .black
        
        if isDarkMode {
            setupDark()
            
        } else {
            setupLight()
        }
    }
    
    private func setupLight() {
        outsideLayer.strokeColor = isSelect ? didSelectColor.cgColor : deselectColor.cgColor
        circleInside.backgroundColor = isSelect ? didSelectColor : .clear
    }
    
    private func setupDark() {
        outsideLayer.strokeColor = isSelect ? UIColor(hex: 0x2687FB).cgColor : deselectColor.cgColor
        circleInside.backgroundColor = isSelect ? UIColor(hex: 0x2687FB) : .clear
    }
}
