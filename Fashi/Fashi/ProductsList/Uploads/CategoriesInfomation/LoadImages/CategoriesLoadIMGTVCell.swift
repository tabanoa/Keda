//
//  CategoriesLoadIMGTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesLoadIMGTVCellDelegate: class {
    func handleDeleteDidTap(_ cvCell: CategoriesLoadIMGCVCell, _ tvCell: CategoriesLoadIMGTVCell)
}

class CategoriesLoadIMGTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesLoadIMGTVCell"
    
    weak var delegate: CategoriesLoadIMGTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var imageLinks: [String] = []
    
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

extension CategoriesLoadIMGTVCell {
    
    func configureCell() {
        //TODO: - CollectionView
        collectionView.configureCVAddSub(ds: self, dl: self, view: contentView)
        collectionView.register(CategoriesLoadIMGCVCell.self, forCellWithReuseIdentifier: CategoriesLoadIMGCVCell.identifier)
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

extension CategoriesLoadIMGTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesLoadIMGCVCell.identifier, for: indexPath) as! CategoriesLoadIMGCVCell
        cell.link = imageLinks[indexPath.item]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesLoadIMGTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesLoadIMGTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = collectionView.frame.height-10
        return CGSize(width: cellSize, height: cellSize)
    }
}

//MARK: - CategoriesLoadIMGCVCellDelegate

extension CategoriesLoadIMGTVCell: CategoriesLoadIMGCVCellDelegate {
    
    func handleDeleteDidTap(_ cell: CategoriesLoadIMGCVCell) {
        delegate?.handleDeleteDidTap(cell, self)
    }
}
