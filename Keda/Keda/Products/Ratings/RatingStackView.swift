//
//  RatingStackView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol RatingStackViewDelegate: class {
    func fetchRating(_ rating: Int)
}

class RatingStackView: UIStackView {
    
    weak var delegate: RatingStackViewDelegate?
    
    var height: CGFloat = 35.0
    var isTap = true
    
    private var arrayBtn: [UIButton] = []
    var rating = 0 { didSet { updateBtn() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBtn()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBtn() {
        for btn in arrayBtn {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        arrayBtn.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let normalImg = UIImage(named: "icon-star-large", in: bundle, compatibleWith: traitCollection)
        let highlightImg = UIImage(named: "icon-star-large-highlighted", in: bundle, compatibleWith: traitCollection)
        let selectedImg = UIImage(named: "icon-star-large-filled", in: bundle, compatibleWith: traitCollection)
        
        for _ in 0..<5 {
            let btn = UIButton()
            btn.setImage(normalImg, for: .normal)
            btn.setImage(highlightImg, for: .highlighted)
            btn.setImage(selectedImg, for: .selected)
            btn.contentEdgeInsets = .zero
            btn.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.heightAnchor.constraint(equalToConstant: height).isActive = true
            btn.widthAnchor.constraint(equalToConstant: height).isActive = true
            spacing = 3.0
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
    
    @objc func btnDidTap(_ sender: UIButton) {
        guard isTap else { return }
        let index = arrayBtn.firstIndex(of: sender)!
        let selected = index + 1
        
        if selected == rating {
            rating = 0
            
        } else {
            rating = selected
        }
        
        isTap = false
        delegate?.fetchRating(rating)
    }
}
