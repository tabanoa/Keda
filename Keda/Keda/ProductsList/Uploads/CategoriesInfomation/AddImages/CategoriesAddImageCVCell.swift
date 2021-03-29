//
//  CategoriesAddImageCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesAddImageCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesAddImageCVCell"
    let label = UILabel()
    let shapeLayer = CAShapeLayer()
    
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

extension CategoriesAddImageCVCell {
    
    private func configureCell() {
        let color = UIColor(hex: 0xF33D30)
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let rect = bounds//CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        shapeLayer.path = UIBezierPath(rect: rect).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.lineDashPattern = [4, 3]
        containerView.layer.addSublayer(shapeLayer)
        
        let addViTxt = """
Thêm
Hình Ảnh
/Video
"""
        let addEnTxt = """
Add
Image
/Video
"""
        let txt = NSLocalizedString("AddImage", comment: "CategoriesAddImageCVCell.swift: AddImage")
        let isAdd = txt == "AddImage" ? true : false
        let lblTxt = isAdd ? addEnTxt : addViTxt
        label.configureNameForCell(false, line: 0, txtColor: color, fontSize: 9.0, isTxt: lblTxt, fontN: fontNamed)
        label.textAlignment = .center
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0)
        ])
    }
}
