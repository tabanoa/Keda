//
//  FilterContainerView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol FilterContainerViewDelegate: class {
    func handleDoneDidTap()
    func handleClearAllDidTap()
    func handleBackDidTap()
}

class FilterContainerView: UIView {
    
    //MARK: - Properties
    weak var delegate: FilterContainerViewDelegate?
    private let topView = UIView()
    let centerView = UIView()
    private let bottomView = UIView()
    
    let backBtn = UIButton()
    let clearAllBtn = UIButton()
    
    private let titleLbl = UILabel()
    private let doneBtn = UIButton()
    private let sepatatorTopV = UIView()
    private let sepatatorBottomV = UIView()
    
    private let clearAll = NSLocalizedString("Clear All", comment: "FilterContainerView.swift: Clear All")
    private let doneTitle = NSLocalizedString("Done", comment: "FilterContainerView.swift: Done")
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension FilterContainerView {
    
    func setupContView(_ view: UIView, dl: FilterContainerViewDelegate) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        topView.backgroundColor = UIColor(hex: 0xEBEBEB, alpha: 0.6)
        addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SepatatorView
        sepatatorTopV.backgroundColor = UIColor(hex: 0xEBEBEB)
        topView.addSubview(sepatatorTopV)
        sepatatorTopV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BottomView
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SepatatorBottomView
        sepatatorBottomV.backgroundColor = UIColor(hex: 0xEBEBEB)
        bottomView.addSubview(sepatatorBottomV)
        sepatatorBottomV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        centerView.backgroundColor = .white
        addSubview(centerView)
        centerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleTopView
        let titleTop = NSLocalizedString("Filter", comment: "FilterContainerView.swift: Filter")
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 17.0, isTxt: titleTop, fontN: fontNamedBold)
        topView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ClearAll
        let attribClearAll = setupTitleAttri(clearAll, txtColor: UIColor(hex: 0x2AB5EC), size: 17.0)
        clearAllBtn.setAttributedTitle(attribClearAll, for: .normal)
        clearAllBtn.addTarget(self, action: #selector(clearAllDidTap), for: .touchUpInside)
        clearAllBtn.isHidden = true
        topView.addSubview(clearAllBtn)
        clearAllBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - LeftBtn
        let attributed = setupTitleAttri(doneTitle, size: 17.0)
        doneBtn.setAttributedTitle(attributed, for: .normal)
        doneBtn.backgroundColor = .black
        doneBtn.clipsToBounds = true
        doneBtn.layer.cornerRadius = 5.0
        doneBtn.layer.borderColor = UIColor.black.cgColor
        doneBtn.layer.borderWidth = 1.0
        doneBtn.addTarget(self, action: #selector(doneDidTap), for: .touchUpInside)
        bottomView.addSubview(doneBtn)
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        
        backBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backBtn.tintColor = UIColor(hex: 0x2AB5EC)
        backBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        backBtn.addTarget(self, action: #selector(backDidTap), for: .touchUpInside)
        backBtn.isHidden = true
        topView.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let heightCons = UIApplication.shared.statusBarFrame
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            widthAnchor.constraint(equalToConstant: screenWidth*0.8),
            
            topView.topAnchor.constraint(equalTo: topAnchor, constant: heightCons.height),
            topView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 44.0),
            
            sepatatorTopV.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            sepatatorTopV.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            sepatatorTopV.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            sepatatorTopV.heightAnchor.constraint(equalToConstant: 1.0),
            
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50.0),
            
            sepatatorBottomV.topAnchor.constraint(equalTo: bottomView.topAnchor),
            sepatatorBottomV.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            sepatatorBottomV.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            sepatatorBottomV.heightAnchor.constraint(equalToConstant: 1.0),
            
            centerView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            centerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            centerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            centerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            titleLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            
            doneBtn.widthAnchor.constraint(equalToConstant: screenWidth*0.8 - 40.0),
            doneBtn.heightAnchor.constraint(equalToConstant: 40.0),
            doneBtn.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            doneBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            clearAllBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            clearAllBtn.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10.0),
            
            backBtn.widthAnchor.constraint(equalToConstant: 25.0),
            backBtn.heightAnchor.constraint(equalToConstant: 25.0),
            backBtn.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 10.0),
            backBtn.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
        ])
        
        transform = CGAffineTransform(translationX: screenWidth, y: 0.0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 10.0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.transform = .identity
        }, completion: nil)
        
        delegate = dl
    }
    
    @objc func doneDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleDoneDidTap()
        }
    }
    
    @objc func clearAllDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleClearAllDidTap()
        }
    }
    
    @objc func backDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleBackDidTap()
        }
    }
    
    func setupDarkMode(_ isDarkMode: Bool = false) {
        let wbC: UIColor = isDarkMode ? .white : .black
        let bgC: UIColor = isDarkMode ? darkColor : .white
        backgroundColor = bgC
        centerView.backgroundColor = bgC
        bottomView.backgroundColor = bgC
        
        let topC: UIColor = isDarkMode ? .black : UIColor(hex: 0xEBEBEB, alpha: 0.6)
        topView.backgroundColor = topC
        
        let txtC: UIColor = isDarkMode ? UIColor(hex: 0x2687FB) : UIColor(hex: 0x2AB5EC)
        backBtn.tintColor = txtC
        titleLbl.textColor = wbC
        
        let attribClearAll = setupTitleAttri(clearAll, txtColor: txtC, size: 17.0)
        clearAllBtn.setAttributedTitle(attribClearAll, for: .normal)
        
        let doneC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(doneTitle, txtColor: doneC, size: 17.0)
        doneBtn.setAttributedTitle(attributed, for: .normal)
        doneBtn.backgroundColor = wbC
        doneBtn.layer.borderColor = wbC.cgColor
        
        let sepaC: UIColor = isDarkMode ? darkSeparatorColor : UIColor(hex: 0xEBEBEB)
        sepatatorTopV.backgroundColor = sepaC
        sepatatorBottomV.backgroundColor = sepaC
    }
}
