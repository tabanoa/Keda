//
//  RecentSearchesCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol RecentSearchesCVCellDelegate: class {
    func handleRemoveTag(_ cell: RecentSearchesCVCell)
}

class RecentSearchesCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "RecentSearchesCVCell"
    
    weak var delegate: RecentSearchesCVCellDelegate?
    var containerView = UIView()
    var tagLbl = UILabel()
    var removeView = UIView()
    let cancelBtn = UIButton(type: .custom)
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContentForCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
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

extension RecentSearchesCVCell {
    
    func addContentForCell() {
        //ContainerView
        containerView.backgroundColor = lightSeparatorColor
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = bounds.size.height/2.0
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TagLbl
        tagLbl.configureNameForCell(false, txtColor: .black, fontSize: 14.0, isTxt: "Tag", fontN: fontNamed)
        tagLbl.textAlignment = .center
        tagLbl.frame.size.width = tagLbl.intrinsicContentSize.width + 20.0
        containerView.addSubview(tagLbl)
        tagLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CancelBtn
        cancelBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelBtn.tintColor = .black
        cancelBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        containerView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.sizeToFit()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tagLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            tagLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            cancelBtn.widthAnchor.constraint(equalToConstant: 20.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 20.0),
            cancelBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
            cancelBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        setupDarkMode()
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleRemoveTag(self)
        }
    }
}

//MARK: - DarkMode

extension RecentSearchesCVCell {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
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
        containerView.backgroundColor = isDarkMode ? .darkGray : lightSeparatorColor
        tagLbl.textColor = isDarkMode ? .white : .black
        cancelBtn.tintColor = isDarkMode ? .white : .black
    }
}
