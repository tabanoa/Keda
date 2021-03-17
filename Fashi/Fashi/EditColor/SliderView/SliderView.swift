//
//  SliderView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SliderView: UIView, ColorPicker {
    
    //MARK: - Properties
    let colorView = ColorTopView()
    let opacityView = OpacityView()
    
    let redView = RGBView()
    let greenView = RGBView()
    let blueView = RGBView()
    
    let hexColorLbl = UILabel()
    let hexTF = UITextField()
    
    weak var delegate: ColorPickerDelegate?
    private var previousTxt = ""
    
    var selectedColor: UIColor = .white {
        didSet {
            colorView.backgroundColor = selectedColor
            
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            selectedColor.getRed(&r, green: &g, blue: &b, alpha: &alpha)
            
            r = r*255.0
            redView.percentLbl.text = "\(NSString(format: "%.0f", r))"
            redView.slider.value = Float(r)
            
            g = g*255.0
            greenView.percentLbl.text = "\(NSString(format: "%.0f", g))"
            greenView.slider.value = Float(r)
            
            b = b*255.0
            blueView.percentLbl.text = "\(NSString(format: "%.0f", b))"
            blueView.slider.value = Float(r)
            
            alpha = alpha*100.0
            opacityView.percentLbl.text = "\(NSString(format: "%.0f", alpha))"
            opacityView.slider.value = Float(alpha)
            
            hexTF.text = getHexStr(selectedColor).uppercased()
            setSliderColor(selectedColor)
        }
    }
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension SliderView {
    
    func setupSliderView(_ view: UIView, topView: UIView) {
        isHidden = true
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ColorView
        colorView.setupColorView(self)
        
        //TODO: - Opacity
        opacityView.setupOpacityView(self, txt: "Opacity", wTxt: "Opacity")
        opacityView.slider.addTarget(self, action: #selector(opacityChanged), for: .valueChanged)
        
        let oTap = UITapGestureRecognizer(target: self, action: #selector(opacityDidTap))
        opacityView.slider.addGestureRecognizer(oTap)
        
        //TODO: - Red
        redView.setupRGBView(self, txt: "Red")
        redView.slider.addTarget(self, action: #selector(redChanged), for: .valueChanged)
        
        let rTap = UITapGestureRecognizer(target: self, action: #selector(redDidTap))
        redView.slider.addGestureRecognizer(rTap)
        
        //TODO: - Green
        greenView.setupRGBView(self, txt: "Green")
        greenView.slider.addTarget(self, action: #selector(greenChanged), for: .valueChanged)
        greenView.translatesAutoresizingMaskIntoConstraints = false
        
        let gTap = UITapGestureRecognizer(target: self, action: #selector(greenDidTap))
        greenView.slider.addGestureRecognizer(gTap)
        
        //TODO: - Blue
        blueView.setupRGBView(self, txt: "Blue")
        blueView.slider.addTarget(self, action: #selector(blueChanged), for: .valueChanged)
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        let bTap = UITapGestureRecognizer(target: self, action: #selector(blueDidTap))
        blueView.slider.addGestureRecognizer(bTap)
        
        //TODO: StackView
        let views1 = [redView, greenView, blueView]
        let sv1 = createdStackView(views1, spacing: 25.0, axis: .vertical, distribution: .fillEqually, alignment: .center)
        addSubview(sv1)
        sv1.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - HexColor
        hexTF.font = UIFont(name: fontNamedBold, size: 15.0)
        hexTF.textAlignment = .center
        hexTF.clipsToBounds = true
        hexTF.layer.cornerRadius = 3.0
        hexTF.layer.borderColor = UIColor.gray.cgColor
        hexTF.layer.borderWidth = 0.5
        hexTF.translatesAutoresizingMaskIntoConstraints = false
        hexTF.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        hexTF.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        
        hexColorLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: "Hex Color #:", fontN: fontNamedBold)
        
        let views2 = [hexColorLbl, hexTF]
        let sv2 = createdStackView(views2, spacing: 8.0, axis: .horizontal, distribution: .fill, alignment: .center)
        addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        hexTF.addTarget(self, action: #selector(hexColorDidChange), for: .editingChanged)
        hexTF.delegate = self
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topView.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            
            sv1.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv1.centerYAnchor.constraint(equalTo: centerYAnchor),
            sv1.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv1.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            sv2.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10.0),
            sv2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0)
        ])
    }
    
    @objc func opacityChanged(_ sender: UISlider) {
        opacityView.percentLbl.text = "\(Int(sender.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func opacityDidTap(_ sender: UITapGestureRecognizer) {
        let slider = opacityView.slider
        let location = sender.location(in: self)
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        opacityView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func redChanged(_ sender: UISlider) {
        redView.percentLbl.text = "\(Int(sender.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func redDidTap(_ sender: UITapGestureRecognizer) {
        let slider = redView.slider
        let location = sender.location(in: self)
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        redView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func greenChanged(_ sender: UISlider) {
        greenView.percentLbl.text = "\(Int(sender.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func greenDidTap(_ sender: UITapGestureRecognizer) {
        let slider = greenView.slider
        let location = sender.location(in: self)
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        greenView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func blueChanged(_ sender: UISlider) {
        blueView.percentLbl.text = "\(Int(sender.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func blueDidTap(_ sender: UITapGestureRecognizer) {
        let slider = blueView.slider
        let location = sender.location(in: self)
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        blueView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        hexTF.text = getHexStr(getColor()).uppercased()
        didSelect(getColor())
    }
    
    @objc func hexColorDidChange(_ tf: UITextField) {
        guard let txt = tf.text else { return }
        
        let characterSet = CharacterSet(charactersIn: "0123456789abcdefABCDEF")
        let strCharacterSet = CharacterSet(charactersIn: txt)
        
        if !characterSet.isSuperset(of: strCharacterSet) {
            tf.text = previousTxt
            return
        }
        
        if txt.count != 6 { return }
        
        let alpha = NSString(string: opacityView.percentLbl.text!).floatValue/100
        let color = getHexColor(hexStr: txt, alpha: CGFloat(alpha))
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        r = r*255
        redView.percentLbl.text = "\(NSString(format: "%.0f", r))"
        redView.slider.value = Float(r)
        
        g = b*255
        greenView.percentLbl.text = "\(NSString(format: "%.0f", g))"
        greenView.slider.value = Float(g)
        
        b = b*255
        blueView.percentLbl.text = "\(NSString(format: "%.0f", b))"
        blueView.slider.value = Float(b)
        didSelect(color)
    }
    
    func getColor() -> UIColor {
        let r = CGFloat(NSString(string: redView.percentLbl.text!).floatValue/255)
        let g = CGFloat(NSString(string: greenView.percentLbl.text!).floatValue/255)
        let b = CGFloat(NSString(string: blueView.percentLbl.text!).floatValue/255)
        let alpha = CGFloat(NSString(string: opacityView.percentLbl.text!).floatValue/100)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    func getHexStr(_ color: UIColor) -> String {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &alpha)
        
        let rgb: Int = Int(r*255)<<16 | Int(g*255)<<8 | Int(b*255)<<0
        return "\(NSString(format: "%06x", rgb))"
    }
    
    func getHexColor(hexStr: String, alpha: CGFloat) -> UIColor {
        let hexString = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexString)
        var color: UInt64 = 0
        
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000)>>16)/255.0
            let g = CGFloat((color & 0xFF00)>>8)/255.0
            let b = CGFloat(color & 0xFF)/255.0
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
            
        } else {
            return .white
        }
    }
    
    func didSelect(_ color: UIColor) {
        colorView.backgroundColor = color
        setSliderColor(color)
        delegate?.colorPicker(self, didSelect: color)
    }
    
    func setSliderColor(_ color: UIColor) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        let startR = UIColor(red: 0.0, green: g, blue: b, alpha: 1.0)
        let endR = UIColor(red: 1.0, green: g, blue: b, alpha: 1.0)
        redView.slider.setGradient(startC: startR, endC: endR)
        
        let startG = UIColor(red: r, green: 0.0, blue: b, alpha: 1.0)
        let endG = UIColor(red: r, green: 1.0, blue: b, alpha: 1.0)
        greenView.slider.setGradient(startC: startG, endC: endG)
        
        let startB = UIColor(red: r, green: g, blue: 0.0, alpha: 1.0)
        let endB = UIColor(red: r, green: g, blue: 1.0, alpha: 1.0)
        blueView.slider.setGradient(startC: startB, endC: endB)
    }
    
    func closeKeyboard() {
        hexTF.resignFirstResponder()
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        redView.nameLbl.textColor = isDarkMode ? .white : .black
        redView.percentLbl.textColor = isDarkMode ? .white : .black
        
        greenView.nameLbl.textColor = isDarkMode ? .white : .black
        greenView.percentLbl.textColor = isDarkMode ? .white : .black
        
        blueView.nameLbl.textColor = isDarkMode ? .white : .black
        blueView.percentLbl.textColor = isDarkMode ? .white : .black
        
        opacityView.nameLbl.textColor = isDarkMode ? .white : .black
        opacityView.percentLbl.textColor = isDarkMode ? .white : .black
        
        hexColorLbl.textColor = isDarkMode ? .white : .black
    }
}

//MARK: - UITextFieldDelegate

extension SliderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text!.uppercased()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentTxt = textField.text ?? ""
        let prospectiveTxt = NSString(string: currentTxt).replacingCharacters(in: range, with: string)
        let maxInpuLength = 6
        if prospectiveTxt.count > maxInpuLength { return false }
        
        previousTxt = currentTxt
        return true
    }
}
