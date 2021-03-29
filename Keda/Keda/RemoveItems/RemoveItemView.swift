//
//  RemoveItemView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

protocol RemoveItemViewDelegate: class {
    func handleCancel()
    func handleRemove()
}

class RemoveItemView: UIView {
    
    //MARK: - Properties
    weak var delegate: RemoveItemViewDelegate?
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x000000, alpha: 0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension RemoveItemView {
    
    func setupView(_ notifView: UIView,
                   _ cancelBtn: ShowMoreBtn,
                   _ imgView: UIImageView,
                   _ titleLbl: UILabel,
                   _ removeBtn: ShowMoreBtn,
                   _ titleLblTxt: String,
                   _ titleBtnTxt: String,
                   _ image: UIImage?) {
        //TODO: - NotificationView
        notifView.backgroundColor = .white
        notifView.clipsToBounds = true
        notifView.layer.cornerRadius = 5.0
        notifView.alpha = 0.0
        addSubview(notifView)
        notifView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - CancelBtn
        cancelBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelBtn.alpha = 0.0
        cancelBtn.tintColor = .black
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ImageView
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        imgView.alpha = 0.0
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        titleLbl.configureNameForCell(false, txtColor: .black, fontSize: 16.0, isTxt: titleLblTxt, fontN: fontNamedBold)
        titleLbl.alpha = 0.0
        addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - RemoveBtn
        let attributed = setupTitleAttri(titleBtnTxt)
        removeBtn.setAttributedTitle(attributed, for: .normal)
        removeBtn.backgroundColor = .black
        removeBtn.clipsToBounds = true
        removeBtn.layer.cornerRadius = 5.0
        removeBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        removeBtn.addTarget(self, action: #selector(removeDidTap), for: .touchUpInside)
        removeBtn.alpha = 0.0
        addSubview(removeBtn)
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notifView.widthAnchor.constraint(equalToConstant: screenWidth - 40.0),
            notifView.heightAnchor.constraint(equalToConstant: 250.0),
            notifView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notifView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50.0),
            
            cancelBtn.widthAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.trailingAnchor.constraint(equalTo: notifView.trailingAnchor, constant: -5.0),
            cancelBtn.topAnchor.constraint(equalTo: notifView.topAnchor, constant: 2.0),

            imgView.widthAnchor.constraint(equalToConstant: 110.0),
            imgView.heightAnchor.constraint(equalToConstant: 110.0),
            imgView.topAnchor.constraint(equalTo: notifView.topAnchor, constant: 10.0),
            imgView.centerXAnchor.constraint(equalTo: notifView.centerXAnchor),

            titleLbl.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20.0),
            titleLbl.centerXAnchor.constraint(equalTo: notifView.centerXAnchor),

            removeBtn.heightAnchor.constraint(equalToConstant: 50.0),
            removeBtn.leadingAnchor.constraint(equalTo: notifView.leadingAnchor, constant: 5.0),
            removeBtn.trailingAnchor.constraint(equalTo: notifView.trailingAnchor, constant: -5.0),
            removeBtn.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20.0),
            removeBtn.centerXAnchor.constraint(equalTo: notifView.centerXAnchor),
        ])
        
        notifView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.33, animations: {
            notifView.transform = .identity
            notifView.alpha = 1.0
            
        }) { _ in
            cancelBtn.alpha = 1.0
            imgView.alpha = 1.0
            titleLbl.alpha = 1.0
            removeBtn.alpha = 1.0
        }
    }
    
    @objc func cancelDidTap() {
        delegate?.handleCancel()
    }
    
    @objc func removeDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleRemove()
        }
    }
}
