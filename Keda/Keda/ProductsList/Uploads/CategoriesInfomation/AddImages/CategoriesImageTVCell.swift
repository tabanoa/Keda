//
//  CategoriesImageTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesImageTVCellDelegate: class {
    func editImage(_ tvCell: CategoriesImageTVCell, index: Int)
    func addImage(_ cell: CategoriesImageTVCell)
    func handleDeleteDidTap(_ cvCell: CategoriesImageCVCell, _ tvCell: CategoriesImageTVCell)
}

class CategoriesImageTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesImageTVCell"
    
    weak var delegate: CategoriesImageTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var images: [UIImage] = []
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let frame = CGRect(x: 0.0, y: 0.0, width: targetSize.width, height: collectionView.frame.height)
        collectionView.frame = frame
        collectionView.layoutIfNeeded()
        
        let size = collectionView.collectionViewLayout.collectionViewContentSize
        return size
    }
}

//MARK: - Configures

extension CategoriesImageTVCell {
    
    func configureCell() {
        //TODO: - CollectionView
        collectionView.configureCVAddSub(ds: self, dl: self, view: contentView)
        collectionView.register(CategoriesImageCVCell.self, forCellWithReuseIdentifier: CategoriesImageCVCell.identifier)
        collectionView.register(CategoriesAddImageCVCell.self, forCellWithReuseIdentifier: CategoriesAddImageCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0)
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesImageTVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 1 else { return images.count }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesImageCVCell.identifier, for: indexPath) as! CategoriesImageCVCell
            cell.imgView.image = images[indexPath.item]
            cell.delegate = self
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesAddImageCVCell.identifier, for: indexPath) as! CategoriesAddImageCVCell
            if images.count == 7 {
                cell.shapeLayer.strokeColor = UIColor.gray.cgColor
                cell.label.textColor = UIColor.gray
            }
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesImageTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let index = indexPath.item
            delegate?.editImage(self, index: index)

        } else {
            guard images.count < 7 else { return }
            delegate?.addImage(self)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesImageTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = collectionView.frame.height-10
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
            
        } else {
            return CGSize(width: 5.0, height: collectionView.bounds.size.height)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesImageTVCell: CategoriesImageCVCellDelegate {
    
    func handleDeleteDidTap(_ cell: CategoriesImageCVCell) {
        delegate?.handleDeleteDidTap(cell, self)
    }
}
