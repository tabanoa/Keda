//
//  CategoriesSaleOffTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol CategoriesSaleOffTVCellDelegate: class {
    func fetchSaleOff(_ txt: String)
}

class CategoriesSaleOffTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CategoriesSaleOffTVCell"
    
    weak var delegate: CategoriesSaleOffTVCellDelegate?
    var saleOffTF = UITextField()
    var percentLbl = UILabel()
    var saleOff = ""
    
    private var widthConsSaleOff: NSLayoutConstraint!
    
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

extension CategoriesSaleOffTVCell {
    
    func configureCell() {
        //TODO: - SaleOff
        let edgeInset = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 0.0, right: 8.0)
        let rect = CGRect().inset(by: edgeInset)
        saleOffTF.font = UIFont(name: fontNamed, size: 17.0)
        saleOffTF.textColor = .black
        saleOffTF.keyboardType = .decimalPad
        saleOffTF.placeholder = NSLocalizedString("Enter SaleOFF", comment: "CategoriesSaleOffTVCell.swift: Enter SaleOFF")
        saleOffTF.delegate = self
        saleOffTF.placeholderRect(forBounds: rect)
        saleOffTF.textRect(forBounds: rect)
        saleOffTF.editingRect(forBounds: rect)
        saleOffTF.addTarget(self, action: #selector(saleOffChange), for: .editingChanged)
        saleOffTF.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saleOffTF)
        saleOffTF.heightAnchor.constraint(equalToConstant: 39.0).isActive = true
        widthConsSaleOff = saleOffTF.widthAnchor.constraint(equalToConstant: screenWidth*0.3)
        
        percentLbl.font = UIFont(name: fontNamed, size: 17.0)
        percentLbl.text = "%"
        percentLbl.textAlignment = .right
        percentLbl.isHidden = saleOffTF.text != nil
        contentView.addSubview(percentLbl)
        percentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthConsSaleOff,
            saleOffTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            saleOffTF.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            percentLbl.centerYAnchor.constraint(equalTo: saleOffTF.centerYAnchor),
            percentLbl.leadingAnchor.constraint(equalTo: saleOffTF.trailingAnchor)
        ])
        
        setupDarkMode()
    }
    
    @objc func saleOffChange(_ tf: UITextField) {
        if let text = tf.text {
            widthConsSaleOff.constant = estimatedText(text, fontS: 17.0).width+20
            percentLbl.isHidden = false
            
        } else {
            widthConsSaleOff.constant = screenWidth*0.3
            percentLbl.isHidden = true
        }
    }
}

//MARK: - UITextFieldDelegate

extension CategoriesSaleOffTVCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isNumber,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
            text.toDouble() != 0 {
            widthConsSaleOff.constant = estimatedText(text, fontS: 17.0).width+20
            percentLbl.isHidden = false
            saleOff = text
            
        } else {
            saleOff = ""
            widthConsSaleOff.constant = screenWidth*0.3
            percentLbl.isHidden = true
        }
        
        delegate?.fetchSaleOff(saleOff)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else { return false }
        let newText = oldText.replacingCharacters(in: range, with: string)
        let numberOfDots = newText.components(separatedBy: ".").count-1
        let isNumeric = newText.isEmpty || newText.toDouble() != 0
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex)
            
        } else {
            numberOfDecimalDigits = 0
        }
        
        if NSString(string: newText).length > 5 { saleOffTF.resignFirstResponder(); return false }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}

//MARK: - DarkMode

extension CategoriesSaleOffTVCell {
    
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
        
        saleOffTF.textColor = isDarkMode ? .white : .black
    }
}
