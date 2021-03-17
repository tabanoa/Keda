//
//  CategoriesTagTVCell.swift
//  Fashi
//
//  Created by Jack Ily on 13/04/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class CategoriesTagTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesTagTVCell"
    let tagLbl = UILabel()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        setupSelectedCell { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
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

extension CategoriesTagTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Tag
        let txt = "bags woment, bags, accessories, salvatore ferragamo"
        tagLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 17.0, isTxt: txt, fontN: fontNamed)
        contentView.addSubview(tagLbl)
        tagLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            tagLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            tagLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            tagLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ])
    }
}
