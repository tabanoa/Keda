//
//  CategoriesDelTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesDelTVCellDelegate: class {
    func handleDelete()
}

class CategoriesDelTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesDelTVCell"
    weak var delegate: CategoriesDelTVCellDelegate?
    
    let deleteBtn = ShowMoreBtn()
    let txt = NSLocalizedString("DELETE", comment: "CategoriesDelTVCell.swift: DELETE")
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CategoriesDelTVCell {
    
    func configureCell() {
        backgroundColor = groupColor
        
        let attributed = setupTitleAttri(txt, size: 17.0)
        deleteBtn.setAttributedTitle(attributed, for: .normal)
        deleteBtn.backgroundColor = UIColor(hex: 0xF33D30)
        deleteBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        deleteBtn.addTarget(self, action: #selector(deleteDidTap), for: .touchUpInside)
        contentView.addSubview(deleteBtn)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            deleteBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            deleteBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0),
            deleteBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
        
        setupDarkMode()
    }
    
    @objc func deleteDidTap(_ sender: UIButton) {
        touchAnim(sender, frValue: 0.80) {
            self.delegate?.handleDelete()
        }
    }
}

//MARK: - DarkMode

extension CategoriesDelTVCell {
    
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
        backgroundColor = isDarkMode ? .black : groupColor
    }
}
