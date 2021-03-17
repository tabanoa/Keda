//
//  CategoriesImageCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesImageCVCellDelegate: class {
    func handleDeleteDidTap(_ cell: CategoriesImageCVCell)
}

class CategoriesImageCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesImageCVCell"
    
    weak var delegate: CategoriesImageCVCellDelegate?
    let imgView = UIImageView()
    let deleteBtn = ShowMoreBtn()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension CategoriesImageCVCell {
    
    func configureCell() {
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5.0
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteW: CGFloat = 15.0
        deleteBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteBtn.tintColor = .white
        deleteBtn.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        deleteBtn.clipsToBounds = true
        deleteBtn.layer.cornerRadius = deleteW/2
        deleteBtn.backgroundColor = .black
        deleteBtn.addTarget(self, action: #selector(deleteDidTap), for: .touchUpInside)
        contentView.addSubview(deleteBtn)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteBtn.widthAnchor.constraint(equalToConstant: deleteW),
            deleteBtn.heightAnchor.constraint(equalToConstant: deleteW),
            deleteBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 3.0),
            deleteBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -5.0)
        ])
    }
    
    @objc func deleteDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleDeleteDidTap(self)
        }
    }
}
