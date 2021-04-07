//
//  RatingSmallSV.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class RatingSmallSV: UIStackView {
    
    var height: CGFloat = 15.0
    var arrayBtn: [UIButton] = []
    var rating: Int = 0 {
        didSet {
            updateBtn()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBtn()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension RatingSmallSV {
    
    func setupBtn() {
        for btn in arrayBtn {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        arrayBtn.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let normalImg = UIImage(named: "icon-star-small", in: bundle, compatibleWith: traitCollection)
        let highlightImg = UIImage(named: "icon-star-small-highlighted", in: bundle, compatibleWith: traitCollection)
        let selectedImg = UIImage(named: "icon-star-small-filled", in: bundle, compatibleWith: traitCollection)
        
        for _ in 0..<5 {
            let btn = UIButton()
            btn.setImage(normalImg, for: .normal)
            btn.setImage(highlightImg, for: .highlighted)
            btn.setImage(selectedImg, for: .selected)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: height).isActive = true
            btn.heightAnchor.constraint(equalToConstant: height).isActive = true
            addArrangedSubview(btn)
            arrayBtn.append(btn)
        }
        
        updateBtn()
    }
    
    func updateBtn() {
        for (index, btn) in arrayBtn.enumerated() {
            btn.isSelected = index < rating
        }
    }
}
