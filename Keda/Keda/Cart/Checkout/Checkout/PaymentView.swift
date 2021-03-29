//
//  PaymentView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.


import UIKit

class PaymentView: UIView {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let shape = CAShapeLayer()
    var checkoutVC: CheckoutVC!
    var horLeadingAnchor: NSLayoutConstraint!
    
    var imgs: [UIImage] = [UIImage(named: "icon-visa")!, UIImage(named: "icon-paypal")!]
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCV()
        setupHorizontalBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension PaymentView {
    
    func setupCV() {
        backgroundColor = .white
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(PaymentViewCVCell.self, forCellWithReuseIdentifier: PaymentViewCVCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
    }
    
    func setupHorizontalBar() {
        let horizontalV = UIView()
        horizontalV.backgroundColor = .clear
        addSubview(horizontalV)
        horizontalV.translatesAutoresizingMaskIntoConstraints = false
        
        horLeadingAnchor = horizontalV.leadingAnchor.constraint(equalTo: leadingAnchor)
        NSLayoutConstraint.activate([
            horizontalV.bottomAnchor.constraint(equalTo: bottomAnchor),
            horLeadingAnchor,
            horizontalV.heightAnchor.constraint(equalToConstant: 5.0),
            horizontalV.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        ])
        
        let frameW = screenWidth/2
        let frameH = horizontalV.frame.height
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.addLine(to: CGPoint(x: frameW, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: frameW, y: frameH))
        bezierPath.addLine(to: CGPoint(x: frameW/2+22, y: frameH))
        bezierPath.addLine(to: CGPoint(x: frameW/2, y: frameH+20))
        bezierPath.addLine(to: CGPoint(x: frameW/2-22, y: frameH))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: frameH))
        bezierPath.addLine(to: .zero)
        bezierPath.close()
        
        shape.path = bezierPath.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.lineWidth = 1.0
        shape.strokeColor = UIColor.clear.cgColor
        horizontalV.layer.addSublayer(shape)
        
        setupDarkMode()
    }
}

//MARK: - UICollectionViewDataSource

extension PaymentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentViewCVCell.identifier, for: indexPath) as! PaymentViewCVCell
        cell.imgView.image = imgs[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension PaymentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkoutVC.scrollToPaymentIndex(indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PaymentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = collectionView.bounds.size
        return CGSize(width: cellSize.width/2, height: cellSize.height)
    }
}

//MARK: - UIScrollViewDelegate

extension PaymentView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0.0 {
            collectionView.contentOffset.x = 0.0
            
        } else if scrollView.contentOffset.x >= screenWidth {
            collectionView.contentOffset.x = screenWidth
        }
    }
}

//MARK: - DarkMode

extension PaymentView {
    
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
        backgroundColor = isDarkMode ? .black : .white
        shape.fillColor = isDarkMode ? UIColor.black.cgColor : UIColor.white.cgColor
    }
}
