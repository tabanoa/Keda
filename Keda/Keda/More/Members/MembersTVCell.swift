//
//  MembersTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class MembersTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "MembersTVCell"
    
    let avatarView = UIView()
    let avatarImgView = UIImageView()
    let nameLbl = UILabel()
    let onlineLbl = UILabel()
    let prefixLbl = UILabel()
    let subnameLbl = UILabel()
    let badgeLbl = UILabel()
    let onlineView = UIView()
    
    var badgeWidthCons = NSLayoutConstraint()
    var badgeHeightCons = NSLayoutConstraint()
    
    var numberBadge = 0
    let badgeW: CGFloat = 18.0
    let fontSize: CGFloat = 13.0
    
    var user: User! {
        didSet {
            nameLbl.text = user.fullName
            if user.email == "Facebook" {
                subnameLbl.backgroundColor = UIColor(hex: 0x3b5998)
                subnameLbl.layer.borderColor = UIColor(hex: 0x3b5998).cgColor
                subnameLbl.isHidden = false
                subnameLbl.text = "F"
                
            } else if user.email.contains("appleid.com") {
                subnameLbl.backgroundColor = .black
                subnameLbl.layer.borderColor = UIColor.black.cgColor
                subnameLbl.isHidden = false
                subnameLbl.text = "A"
                
            } else {
                subnameLbl.isHidden = true
            }
            
            user.fetchOnlineTime { (txt, bgColor) in
                self.onlineLbl.text = txt
                self.onlineView.backgroundColor = bgColor
            }
            
            guard let link = user.avatarLink else {
                prefixLbl.isHidden = false
                avatarImgView.image = nil
                user.fullName.fetchFirstLastName { (fn, ln) in
                    self.prefixLbl.text = "\(fn.prefix(1) + ln.prefix(1))".uppercased()
                }
                
                return
            }
            
            user.downloadAvatar(link: link) { (image) in
                DispatchQueue.main.async {
                    self.prefixLbl.isHidden = true
                    self.avatarImgView.image = image
                }
            }
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

extension MembersTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - AvatarView
        let avatarW: CGFloat = 50.0
        avatarView.backgroundColor = .white
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = avatarW/2
        contentView.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.widthAnchor.constraint(equalToConstant: avatarW).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: avatarW).isActive = true
        
        //TODO: - StrokePath
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: avatarW, height: avatarW)).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 5.0
        
        let gradientLayer = createGradientLayer(width: avatarW, height: avatarW, startC: defaultColor, endC: UIColor(hex: 0xFF7B14))
        gradientLayer.mask = circleLayer
        
        avatarView.layer.addSublayer(gradientLayer)
        
        //TODO: - Label
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "", fontN: fontNamedBold)
        onlineLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 13.0, isTxt: "", fontN: fontNamedBold)
        
        let views1: [UIView] = [nameLbl, onlineLbl]
        let sv1 = createdStackView(views1, spacing: 10.0, axis: .vertical, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [avatarView, sv1]
        let sv2 = createdStackView(views2, spacing: 10.0, axis: .horizontal, distribution: .fill, alignment: .top)
        contentView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - AvatarIMGView
        let imgViewW: CGFloat = avatarW*0.8
        avatarImgView.image = nil
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = imgViewW/2.0
        contentView.insertSubview(avatarImgView, aboveSubview: avatarView)
        avatarImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Prefix
        prefixLbl.configureNameForCell(true, txtColor: .black, fontSize: 16.0, isTxt: "")
        contentView.insertSubview(prefixLbl, aboveSubview: avatarImgView)
        prefixLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let subnameW: CGFloat = 18.0
        subnameLbl.configureNameForCell(true, txtColor: .white, fontSize: 10.0, isTxt: "", fontN: fontNamedBold)
        subnameLbl.clipsToBounds = true
        subnameLbl.layer.cornerRadius = subnameW/2
        subnameLbl.layer.borderWidth = 1.0
        subnameLbl.textAlignment = .center
        addSubview(subnameLbl)
        subnameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Badge
        badgeLbl.font = UIFont.systemFont(ofSize: fontSize)
        badgeLbl.textAlignment = .center
        badgeLbl.backgroundColor = UIColor(hex: 0xF33D30)
        badgeLbl.textColor = .white
        badgeLbl.sizeToFit()
        contentView.addSubview(badgeLbl)
        badgeLbl.translatesAutoresizingMaskIntoConstraints = false
        badgeWidthCons = badgeLbl.widthAnchor.constraint(equalToConstant: badgeW)
        badgeHeightCons = badgeLbl.heightAnchor.constraint(equalToConstant: badgeW)
        setupBadge(0)
        
        //TODO: - OnlineView
        let onlineW: CGFloat = 10.0
        onlineView.clipsToBounds = true
        onlineView.layer.cornerRadius = onlineW/2
        onlineView.backgroundColor = .red
        contentView.insertSubview(onlineView, aboveSubview: avatarImgView)
        onlineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            sv2.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv2.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -35.0),
            
            avatarImgView.widthAnchor.constraint(equalToConstant: imgViewW),
            avatarImgView.heightAnchor.constraint(equalToConstant: imgViewW),
            avatarImgView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarImgView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            prefixLbl.centerXAnchor.constraint(equalTo: avatarImgView.centerXAnchor),
            prefixLbl.centerYAnchor.constraint(equalTo: avatarImgView.centerYAnchor),
            
            subnameLbl.widthAnchor.constraint(equalToConstant: subnameW),
            subnameLbl.heightAnchor.constraint(equalToConstant: subnameW),
            subnameLbl.leadingAnchor.constraint(equalTo: nameLbl.trailingAnchor, constant: 2.0),
            subnameLbl.bottomAnchor.constraint(equalTo: nameLbl.topAnchor, constant: 17.0),
            
            badgeWidthCons,
            badgeHeightCons,
            badgeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            
            onlineView.widthAnchor.constraint(equalToConstant: onlineW),
            onlineView.heightAnchor.constraint(equalToConstant: onlineW),
            onlineView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: -10.0),
            onlineView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -8.0),
        ])
        
        setupDarkMode()
    }
    
    func setupBadge(_ numberBadge: Int) {
        var kHeight: CGFloat = badgeW
        kHeight += fontSize * 0.4
        
        let kWidth = (numberBadge <= 9) ? kHeight : badgeW + fontSize
        badgeLbl.text = "\(numberBadge)"
        badgeLbl.clipsToBounds = true
        badgeLbl.layer.cornerRadius = kHeight/2.0
        badgeLbl.isHidden = numberBadge == 0
        
        badgeWidthCons.constant = kWidth
        badgeHeightCons.constant = kHeight
    }
}

//MARK: - DarkMode

extension MembersTVCell {
    
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
        nameLbl.textColor = isDarkMode ? .white : .black
        onlineLbl.textColor = isDarkMode ? .lightGray : .darkGray
        prefixLbl.textColor = isDarkMode ? .white : .black
        avatarView.backgroundColor = isDarkMode ? .black : .white
    }
}
