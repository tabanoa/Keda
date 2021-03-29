//
//  ProductRatingBottomView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductRatingBottomViewDelegate: class {
    func handleSend(_ txt: String)
    func handlePhoto()
}

class ProductRatingBottomView: UIView {
    
    //MARK: - Properties
    weak var delegate: ProductRatingBottomViewDelegate?
    private let textView = UITextView()
    private let sendBtn = UIButton()
    private let photoBtn = UIButton()
    
    private var commentTxt = ""
    private let tvTxt = NSLocalizedString("Enter comment", comment: "ProductRatingBottomView.swift: Enter comment")
    
    var bottomConsBV = NSLayoutConstraint()
    private var heightConsBV = NSLayoutConstraint()
    private var heightConsTV = NSLayoutConstraint()
    private var bottomConsTV = NSLayoutConstraint()
    private var newSize = CGSize.zero
    
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

extension ProductRatingBottomView {
    
    func setupBottomView(_ view: UIView, tv: UITableView, dl: ProductRatingBottomViewDelegate) {
        let bottomVHeight: CGFloat
        let bottomTVConst: CGFloat
        if appDl.isX {
            bottomVHeight = 84.0
            bottomTVConst = -45.0
            
        } else {
            bottomVHeight = 44.0
            bottomTVConst = -5.0
        }
        
        //TODO: - BottomView
        view.insertSubview(self, aboveSubview: tv)
        translatesAutoresizingMaskIntoConstraints = false
        heightConsBV = heightAnchor.constraint(greaterThanOrEqualToConstant: bottomVHeight)
        bottomConsBV = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        //TODO: - TextView
        textView.font = UIFont(name: fontNamed, size: 15.0)
        textView.delegate = self
        textView.text = tvTxt
        textView.backgroundColor = UIColor(hex: 0xEFEFF4)
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 15.0
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 5.0)
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        heightConsTV = textView.heightAnchor.constraint(lessThanOrEqualToConstant: 34.0)
        bottomConsTV = textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomTVConst)
        
        //TODO: - SendBtn
        sendBtn.setImage(UIImage(named: "icon-send"), for: .normal)
        sendBtn.addTarget(self, action: #selector(sentDidTap), for: .touchUpInside)
        addSubview(sendBtn)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - PhotoBtn
        photoBtn.setImage(UIImage(named: "icon-photo"), for: .normal)
        photoBtn.addTarget(self, action: #selector(photoDidTap), for: .touchUpInside)
        addSubview(photoBtn)
        photoBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightConsBV,
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConsBV,
            
            heightConsTV,
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.0),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -44.0),
            bottomConsTV,
            
            sendBtn.widthAnchor.constraint(equalToConstant: 34.0),
            sendBtn.heightAnchor.constraint(equalToConstant: 34.0),
            sendBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
            sendBtn.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            
            photoBtn.widthAnchor.constraint(equalToConstant: 34.0),
            photoBtn.heightAnchor.constraint(equalToConstant: 34.0),
            photoBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
            photoBtn.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
        ])
        
        delegate = dl
    }
    
    @objc func sentDidTap(_ sender: UIButton) {
        delegate?.handleSend(commentTxt)
        textView.text = nil
        newSize = .zero
        animTV()
        commentTxt = ""
    }
    
    @objc func photoDidTap(_ sender: UIButton) {
        delegate?.handlePhoto()
    }
    
    func setupDarkModeView(_ isDarkMode: Bool) {
        backgroundColor = isDarkMode ? .black : .white
    }
}

//MARK: - UITextViewDelegate

extension ProductRatingBottomView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            commentTxt = text
            
        } else {
            commentTxt = ""
        }
        
        guard heightConsTV.constant <= 120 else { textView.isScrollEnabled = true; return }
        
        if textView.contentSize.height > heightConsTV.constant {
            let height = CGFloat.greatestFiniteMagnitude
            let width = textView.frame.size.width
            let size = CGSize(width: width, height: height)
            textView.sizeThatFits(size)
            
            var newFrame = textView.frame
            newSize = textView.sizeThatFits(size)
            newFrame.size = CGSize(width: max(newSize.width, width), height: newSize.height + 2.0)
            textView.frame = newFrame
            textView.isScrollEnabled = false
            setupSizeTextView(newSize)

        } else {
            textView.isScrollEnabled = true
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == tvTxt {
            textView.text = ""
            textView.textColor = .black
        }

        textView.becomeFirstResponder()
        
        guard commentTxt != "" else { return }
        let newPos = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: newPos, to: newPos)
        setupSizeTextView(newSize)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = tvTxt
            textView.textColor = .lightGray
        }

        animTV()
        textView.resignFirstResponder()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let oldText = textView.text,
            let textRange = Range(range, in: oldText) else { return true }
        let newText = NSString(string: oldText.replacingCharacters(in: textRange, with: text))
        if newText.length > 0 {}

        return true
    }
    
    func setupSizeTextView(_ size: CGSize) {
        heightConsTV.constant = size.height + 2.0
        heightConsBV.constant = heightConsTV.constant + (appDl.isX ? 50:10)
        textView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func animTV() {
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConsTV.constant = 34.0
            self.heightConsBV.constant = appDl.isX ? 84:44
            self.textView.layoutIfNeeded()
            
        }) { (_) in
            guard self.commentTxt != "" else { return }
            self.textView.isScrollEnabled = false
            self.textView.scrollRectToVisible(.zero, animated: false)
            self.textView.layoutIfNeeded()
        }
    }
}
