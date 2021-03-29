//
//  CategoriesColorSizeTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesColorSizeTVCellDelegate: class {
    func handleDidSelect(_ cell: CategoriesColorSizeTVCell)
}

class CategoriesColorSizeTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesColorSizeTVCell"
    
    weak var delegate: CategoriesColorSizeTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var widthConsColl: NSLayoutConstraint!
    let sizeLbl = UILabel()
    
    lazy var imageLinks: [String] = []
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
        let count: CGFloat
        if imageLinks.count != 0 {
            count = imageLinks.count <= 4 ? CGFloat(imageLinks.count) : 4
            
        } else {
            count = images.count <= 4 ? CGFloat(images.count) : 4
        }
        
        let height = collectionView.frame.height
        let cellCount: CGFloat = height*count
        let spacing: CGFloat = 5*(count+1)
        widthConsColl.constant = cellCount + spacing
    }
}

//MARK: - Configures

extension CategoriesColorSizeTVCell {
    
    func configureCell() {
        accessoryType = .disclosureIndicator
        
        //TODO: - Size
        sizeLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: "X", fontN: fontNamed)
        contentView.addSubview(sizeLbl)
        sizeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CollectionView
        collectionView.configureCVAddSub(ds: self, dl: self, view: contentView)
        collectionView.register(CategoriesColorSizeCVCell.self, forCellWithReuseIdentifier: CategoriesColorSizeCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        collectionView.isScrollEnabled = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        widthConsColl = collectionView.widthAnchor.constraint(equalToConstant: 45.0)
        NSLayoutConstraint.activate([
            sizeLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            sizeLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            widthConsColl,
            collectionView.heightAnchor.constraint(equalToConstant: 39.0),
            collectionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
        ])
        
        setupDarkMode()
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesColorSizeTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageLinks.count != 0 {
            if imageLinks.count >= 4 { return 4 }
            return imageLinks.count
            
        } else {
            if images.count >= 4 { return 4 }
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesColorSizeCVCell.identifier, for: indexPath) as! CategoriesColorSizeCVCell
        if imageLinks.count != 0 {
            cell.link = imageLinks[indexPath.item]
            
        } else {
            cell.imgView.image = images[indexPath.item]
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesColorSizeTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.handleDidSelect(self)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesColorSizeTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = collectionView.frame.height
        return CGSize(width: cellSize, height: cellSize)
    }
}

//MARK: - DarkMode

extension CategoriesColorSizeTVCell {
    
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
        let lightC = UIColor(hex: 0xE5E5E5, alpha: 0.7)
        let darkC = UIColor(hex: 0x3A3A3A, alpha: 0.5)
        let selectC: UIColor = isDarkMode ? darkC : lightC
        setupSelectedCell(selectC: selectC) { (selectedView) in
            self.selectedBackgroundView = selectedView
        }
        
        sizeLbl.textColor = isDarkMode ? .white : .black
    }
}
