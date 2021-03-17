//
//  RecentSearchesTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol RecentSearchesTVCellDelegate: class {
    func handleDidSelect(_ tag: String)
    func handleRemoveTag(tvCell: RecentSearchesTVCell, cvCell: RecentSearchesCVCell)
}

class RecentSearchesTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "RecentSearchesTVCell"
    weak var delegate: RecentSearchesTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let recentlyViewedLayout = RecentlyViewedLayout()
    var searchCV: SearchContainerView!
    
    //MARK: - Intialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.frame = CGRect(x: 0.0, y: 0.0,
                                      width: targetSize.width,
                                      height: CGFloat.greatestFiniteMagnitude)
        DispatchQueue.main.async {
            self.collectionView.layoutIfNeeded()
        }
        
        let size = collectionView.collectionViewLayout.collectionViewContentSize
        return size
    }
}

//MARK: - Configures

extension RecentSearchesTVCell {
    
    func configureCell() {
        collectionView.configureCVAddSub(.white, ds: self, dl: self, view: self)
        collectionView.register(RecentSearchesCVCell.self, forCellWithReuseIdentifier: RecentSearchesCVCell.identifier)
        
        collectionView.collectionViewLayout = recentlyViewedLayout
        recentlyViewedLayout.contentPadding = SpacingMode(horizontal: 5.0, vertical: 20.0)
        recentlyViewedLayout.contentAlign = .left
        recentlyViewedLayout.cellPadding = 5.0
        recentlyViewedLayout.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        setupDarkMode()
    }
}

//MARK: - UICollectionViewDataSource

extension RecentSearchesTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchCV.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchesCVCell.identifier, for: indexPath) as! RecentSearchesCVCell
        cell.tagLbl.text = searchCV.tags[indexPath.item].lowercased()
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension RecentSearchesTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RecentSearchesCVCell
        let tag = searchCV.tags[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.delegate?.handleDidSelect(tag)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RecentSearchesTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.bounds.size.width - 15)/2.0
        return CGSize(width: cellSize, height: cellSize)
    }
}

//MARK: - RecentlyViewedLayoutDelegate

extension RecentSearchesTVCell: RecentlyViewedLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath) -> CGSize {
        let estimated = estimatedText(searchCV.tags[indexPath.item])
        let height = estimated.height + 20.0
        let width = estimated.width + 40.0
        return CGSize(width: width, height: height)
    }
}

//MARK: - RecentSearchesCVCellDelegate

extension RecentSearchesTVCell: RecentSearchesCVCellDelegate {
    
    func handleRemoveTag(_ cell: RecentSearchesCVCell) {
        self.delegate?.handleRemoveTag(tvCell: self, cvCell: cell)
    }
}

//MARK: - DarkMode

extension RecentSearchesTVCell {
    
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
        collectionView.backgroundColor = isDarkMode ? darkColor : .white
    }
}
