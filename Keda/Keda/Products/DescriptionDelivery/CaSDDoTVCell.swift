//
//  CaSDDoTVCellS0.swift
//  Fashi
//
//  Created by Jack Ily on 12/03/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class DescriptionTVCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "DescriptionTVCell"
    let contentLbl = UILabel()
    
    //MARK: - Systems
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure

extension DescriptionTVCell {
    
    func configureCell() {
        //Name
        contentLbl.configureNameForCell(false, line: 0, txtColor: .gray, fontSize: 15.0, fontN: fontNamed)
        contentView.addSubview(contentLbl)
        contentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            contentLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            contentLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            contentLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
        ])
    }
}
