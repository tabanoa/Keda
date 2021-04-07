//
//  TagCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol TagCVCellDelegate: class {
    func handleRemove(cell: TagCVCell)
}

class TagCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "TagCVCell"
    weak var delegate: TagCVCellDelegate?
    let containerView = UIView()
    let tagLbl = UILabel()
    let removeBtn = UIButton(type: .custom)
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension TagCVCell {
    
    func configureCell() {
        //TODO: - ContainerView
        containerView.backgroundColor = lightSeparatorColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = bounds.size.height/2.0
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TagLbl
        tagLbl.configureNameForCell(false, txtColor: .black, fontSize: 16.0, isTxt: "", fontN: fontNamed)
        tagLbl.textAlignment = .center
        tagLbl.frame.size.width = tagLbl.intrinsicContentSize.width + 20.0
        containerView.addSubview(tagLbl)
        tagLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let btnW: CGFloat = 15.0
        removeBtn.backgroundColor = .black
        removeBtn.clipsToBounds = true
        removeBtn.layer.cornerRadius = btnW/2.0
        removeBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        removeBtn.tintColor = .white
        removeBtn.addTarget(self, action: #selector(removeDidTap), for: .touchUpInside)
        removeBtn.contentEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
        contentView.insertSubview(removeBtn, aboveSubview: containerView)
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            tagLbl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            tagLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            removeBtn.widthAnchor.constraint(equalToConstant: btnW),
            removeBtn.heightAnchor.constraint(equalToConstant: btnW),
            removeBtn.trailingAnchor.constraint(equalTo: trailingAnchor),
            removeBtn.topAnchor.constraint(equalTo: topAnchor, constant: -3.0)
        ])
        
        setupDarkMode()
    }
    
    @objc func removeDidTap() {
        delegate?.handleRemove(cell: self)
    }
}

//MARK: - DarkMode

extension TagCVCell {
    
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
        containerView.backgroundColor = isDarkMode ? .darkGray : lightSeparatorColor
        tagLbl.textColor = isDarkMode ? .white : .black
        removeBtn.backgroundColor = isDarkMode ? .white : .black
        removeBtn.tintColor = isDarkMode ? .black : .white
    }
}
