//
//  CategoriesPriceTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesPriceTVCellDelegate: class {
    func fetchPrice(_ txt: String)
}

class CategoriesPriceTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesPriceTVCell"
    
    weak var delegate: CategoriesPriceTVCellDelegate?
    var priceTF = UITextField()
    var currencyLbl = UILabel()
    var price: String = ""
    
    private var widthConsPrice: NSLayoutConstraint!
    private var leadingConsPrice: NSLayoutConstraint!
    
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
}

//MARK: - Configures

extension CategoriesPriceTVCell {
    
    func configureCell() {
        //TODO: - Price
        let edgeInset = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 0.0, right: 8.0)
        let rect = CGRect().inset(by: edgeInset)
        priceTF.font = UIFont(name: fontNamed, size: 17.0)
        priceTF.textColor = .black
        priceTF.keyboardType = .decimalPad
        priceTF.placeholder = NSLocalizedString("Enter Price", comment: "CategoriesPriceTVCell.swift: Enter Price")
        priceTF.delegate = self
        priceTF.placeholderRect(forBounds: rect)
        priceTF.textRect(forBounds: rect)
        priceTF.editingRect(forBounds: rect)
        priceTF.addTarget(self, action: #selector(priceChange), for: .editingChanged)
        contentView.addSubview(priceTF)
        priceTF.translatesAutoresizingMaskIntoConstraints = false
        priceTF.heightAnchor.constraint(equalToConstant: 39.0).isActive = true
        widthConsPrice = priceTF.widthAnchor.constraint(equalToConstant: screenWidth*0.3)
        leadingConsPrice = priceTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0)
        
        currencyLbl.font = UIFont(name: fontNamed, size: 17.0)
        currencyLbl.text = "$"
        currencyLbl.isHidden = priceTF.text != nil
        contentView.addSubview(currencyLbl)
        currencyLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthConsPrice,
            leadingConsPrice,
            priceTF.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            currencyLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            currencyLbl.centerYAnchor.constraint(equalTo: priceTF.centerYAnchor),
        ])
        
        setupDarkMode()
    }
    
    @objc func priceChange(_ tf: UITextField) {
        if let text = tf.text {
            //tf.text = text.currencyInputFormatting()
            widthConsPrice.constant = estimatedText(text, fontS: 17.0).width+20
            leadingConsPrice.constant = 15.0*2
            currencyLbl.isHidden = false
            
        } else {
            widthConsPrice.constant = screenWidth*0.3
            leadingConsPrice.constant = 15.0
            currencyLbl.isHidden = true
        }
    }
}

//MARK: - UITextFieldDelegate

extension CategoriesPriceTVCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isNumber,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            widthConsPrice.constant = estimatedText(text, fontS: 17.0).width+20
            leadingConsPrice.constant = 15.0*2
            currencyLbl.isHidden = false
            price = text
            
        } else {
            price = ""
            widthConsPrice.constant = screenWidth*0.3
            leadingConsPrice.constant = 15.0
            currencyLbl.isHidden = true
        }
        
        delegate?.fetchPrice(price)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else { return true }
        let newText = oldText.replacingCharacters(in: range, with: string)
        let isNumeric = newText.isEmpty || newText.toDouble() != 0
        let numberOfDots = newText.components(separatedBy: ".").count-1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex)
            
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 3
    }
}

//MARK: - DarkMode

extension CategoriesPriceTVCell {
    
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
        
        priceTF.textColor = isDarkMode ? .white : .black
    }
}
