//
//  CheckoutBottomView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.


import UIKit

protocol CheckoutBottomViewDelegate: class {
    func handleAddPayDidTap()
}

class CheckoutBottomView: UIView {
    
    //MARK: - Properties
    weak var delegate: CheckoutBottomViewDelegate?
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Congigures

extension CheckoutBottomView {
    
    func setupBottomView(_ view: UIView, addPayBtn: UIButton, dl: CheckoutBottomViewDelegate) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Btn
        let txt = NSLocalizedString("Select Payment Method", comment: "CheckoutBottomView.swift: Select Payment Method")
        let attributed = setupTitleAttri(txt, size: 17.0)
        addPayBtn.setAttributedTitle(attributed, for: .normal)
        addPayBtn.backgroundColor = .black
        addPayBtn.clipsToBounds = true
        addPayBtn.layer.cornerRadius = 5.0
        addPayBtn.layer.masksToBounds = false
        addPayBtn.layer.shadowColor = UIColor.black.cgColor
        addPayBtn.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        addPayBtn.layer.shadowRadius = 3.0
        addPayBtn.layer.shadowOpacity = 0.3
        addPayBtn.layer.shouldRasterize = true
        addPayBtn.layer.rasterizationScale = UIScreen.main.scale
        addPayBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        addPayBtn.addTarget(self, action: #selector(paymentDidTap), for: .touchUpInside)
        addSubview(addPayBtn)
        addPayBtn.translatesAutoresizingMaskIntoConstraints = false
        delegate = dl
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60.0),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addPayBtn.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            addPayBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
            addPayBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
            addPayBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
        ])
    }
    
    @objc func paymentDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleAddPayDidTap()
        }
    }
}
