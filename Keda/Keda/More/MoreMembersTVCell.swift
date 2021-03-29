//
//  MoreMembersTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class MoreMembersTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "MoreMembersTVCell"
    let iconImgView = UIImageView()
    let titleLbl = UILabel()
    let badgeLbl = UILabel()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension MoreMembersTVCell {
    
    func configureCell() {
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        
        let height: CGFloat = 25.0
        iconImgView.configureIMGViewForCell(contentView, imgName: "icon-acc")
        iconImgView.widthAnchor.constraint(equalToConstant: height).isActive = true
        iconImgView.heightAnchor.constraint(equalToConstant: height).isActive = true
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "Title", fontN: fontNamedBold)
        
        let views = [iconImgView, titleLbl]
        let sv = createdStackView(views, spacing: 15.0, axis: .horizontal, distribution: .fill, alignment: .center)
        contentView.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSize: CGFloat = 13.0
        badgeLbl.font = UIFont.boldSystemFont(ofSize: fontSize)
        badgeLbl.textAlignment = .center
        badgeLbl.backgroundColor = UIColor(hex: 0xFF2D55)
        badgeLbl.textColor = .white
        badgeLbl.sizeToFit()
        contentView.addSubview(badgeLbl)
        badgeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        var kHeight: CGFloat = 18.0
        kHeight += fontSize * 0.4
        
        badgeLbl.text = "N"
        badgeLbl.clipsToBounds = true
        badgeLbl.layer.cornerRadius = kHeight/2.0
        badgeLbl.isHidden = true
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            badgeLbl.widthAnchor.constraint(equalToConstant: kHeight),
            badgeLbl.heightAnchor.constraint(equalToConstant: kHeight),
            badgeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - DarkMode

extension MoreMembersTVCell {
    
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
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
        
        titleLbl.textColor = isDarkMode ? .white : .black
    }
}
