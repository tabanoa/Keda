//
//  WheelView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class WheelView: UIView, ColorPicker {
    
    //MARK: - Properties
    let colorView = ColorTopView()
    let pannelImgView = UIImageView()
    let cursorImgView = UIImageView()
    
    let brightnessView = BrightnessView()
    let opacityView = OpacityView()
    weak var delegate: ColorPickerDelegate?
    
    var selectedColor: UIColor = .white {
        didSet {
            colorView.backgroundColor = selectedColor
            
            let point = calculatePoint(selectedColor)
            cursorImgView.center = point
            
            var hue: CGFloat = 0.0
            var saturation: CGFloat = 0.0
            var brightness: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            selectedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            brightness = brightness*100
            brightnessView.percentLbl.text = "\(NSString(format: "%.0f", brightness))"
            brightnessView.slider.value = Float(brightness)
            
            alpha = alpha*100
            opacityView.percentLbl.text = "\(NSString(format: "%.0f", alpha))"
            opacityView.slider.value = Float(alpha)
            
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
    
    override func draw(_ rect: CGRect) {
        let point = calculatePoint(selectedColor)
        cursorImgView.center = point
    }
}

//MARK: - Configures

extension WheelView {
    
    func setupWheelView(_ view: UIView, topView: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ColorView
        colorView.setupColorView(self)
        
        //TODO: - Pannel
        pannelImgView.clipsToBounds = true
        pannelImgView.image = UIImage(named: "color-wheel")
        pannelImgView.contentMode = .scaleAspectFit
        pannelImgView.isUserInteractionEnabled = true
        addSubview(pannelImgView)
        pannelImgView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        pannelImgView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        pannelImgView.addGestureRecognizer(pan)
        
        //TODO: - Cursor
        let point = CGPoint(x: screenWidth/2-15, y: screenHeight/2-100)
        let cursorSize = CGSize(width: 30.0, height: 30.0)
        cursorImgView.frame = CGRect(origin: point, size: cursorSize)
        cursorImgView.image = UIImage(named: "icon-cursor")
        cursorImgView.clipsToBounds = true
        cursorImgView.contentMode = .scaleAspectFit
        insertSubview(cursorImgView, aboveSubview: pannelImgView)
        
        //TODO: - Opacity
        opacityView.setupOpacityView(self, txt: "Opacity")
        opacityView.slider.addTarget(self, action: #selector(opacityChanged), for: .valueChanged)
        
        let oTap = UITapGestureRecognizer(target: self, action: #selector(opacityDidTap))
        opacityView.slider.addGestureRecognizer(oTap)
        
        //TODO: - Brightness
        brightnessView.setupBrightnessView(self, btAnchor: opacityView.topAnchor, txt: "Brightness")
        brightnessView.slider.addTarget(self, action: #selector(brightnessChanged), for: .valueChanged)
        
        let bTap = UITapGestureRecognizer(target: self, action: #selector(brightnessDidTap))
        brightnessView.slider.addGestureRecognizer(bTap)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topView.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            
            pannelImgView.widthAnchor.constraint(equalToConstant: screenWidth*0.8),
            pannelImgView.heightAnchor.constraint(equalToConstant: screenWidth*0.8),
            pannelImgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pannelImgView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40.0),
        ])
    }
    
    @objc func opacityChanged(_ sender: UISlider) {
        opacityView.percentLbl.text = "\(Int(sender.value))"
        didSelect(calculateColor(cursorImgView.center))
    }
    
    @objc func brightnessChanged(_ sender: UISlider) {
        brightnessView.percentLbl.text = "\(Int(sender.value))"
        didSelect(calculateColor(cursorImgView.center))
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
        didSelect(calculateColor(cursorImgView.center))
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: pannelImgView.superview)
        let path = UIBezierPath(ovalIn: pannelImgView.frame)
        if path.contains(point) {
            cursorImgView.center = point
            didSelect(calculateColor(point))
        }
    }
    
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: pannelImgView.superview)
        let path = UIBezierPath(ovalIn: pannelImgView.frame)
        if path.contains(point) {
            cursorImgView.center = point
            didSelect(calculateColor(point))
        }
    }
    
    @objc func brightnessDidTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let slider = brightnessView.slider
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        brightnessView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        didSelect(calculateColor(cursorImgView.center))
    }
    
    private func setSliderColor(_ color: UIColor) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: nil, alpha: nil)
        
        let endBrightnessColor = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
        brightnessView.slider.setGradient(startC: .black, endC: endBrightnessColor)
    }
    
    private func didSelect(_ color: UIColor) {
        setSliderColor(color)
        colorView.backgroundColor = color
        delegate?.colorPicker(self, didSelect: color)
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        brightnessView.nameLbl.textColor = isDarkMode ? .white : .black
        brightnessView.percentLbl.textColor = isDarkMode ? .white : .black
        
        opacityView.nameLbl.textColor = isDarkMode ? .white : .black
        opacityView.percentLbl.textColor = isDarkMode ? .white : .black
    }
}

extension WheelView {
    
    private func calculatePoint(_ color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        let center = pannelImgView.center
        let radius = pannelImgView.frame.width/2
        let angle = Float(hue) * Float(twoπ)
        let smallRadius = saturation*radius
        let x = center.x + smallRadius * CGFloat(cosf(angle))
        let y = center.y + smallRadius * CGFloat(sinf(angle)*(-1))
        let point = CGPoint(x: x, y: y)
        return point
    }
    
    private func calculateColor(_ point: CGPoint) -> UIColor {
        let center = pannelImgView.center
        let radius = pannelImgView.frame.width/2
        let x = point.x - center.x
        let y = -(point.y - center.y)
        
        var radian = atan2(Float(y), Float(x))
        if radian < 0.0 { radian += Float(twoπ) }
        
        let distance = CGFloat(sqrt(Float(pow(Double(x), 2) + pow(Double(y), 2))))
        let saturation = distance > radius ? 1.0 : distance/radius
        let brightness = CGFloat(brightnessView.slider.value)/100
        let alpha = CGFloat(opacityView.slider.value)/100
        let hue = CGFloat(radian/Float(twoπ))
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
