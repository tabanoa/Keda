//
//  ColorPickerOpacitySlider.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ColorPickerOpacitySlider: UISlider {
    
    //MARK: - Properties
    private let sliderLayer = CAGradientLayer()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var bounds: CGRect {
        didSet {
            drawSlider()
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawSlider()
    }
}

//MARK: - Configures

extension ColorPickerOpacitySlider {
    
    private func drawSlider() {
        sliderLayer.removeFromSuperlayer()
        
        sliderLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        sliderLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        sliderLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        sliderLayer.cornerRadius = sliderLayer.frame.height/2.0
        sliderLayer.borderWidth = 0.5
        sliderLayer.borderColor = UIColor.gray.cgColor
        sliderLayer.backgroundColor = UIColor(patternImage: UIImage(named: "img-transparent.jpg")!).cgColor
        layer.insertSublayer(sliderLayer, at: 0)
    }
    
    private func initializeView() {
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear
        
        let bundle = Bundle(for: ColorPickerOpacitySlider.self)
        if let path = bundle.path(forResource: "icon-slider-thumb@2x.png", ofType: nil) {
            setThumbImage(UIImage(contentsOfFile: path), for: .normal)
        }
    }
    
    func setGradient(startC: UIColor, endC: UIColor) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        sliderLayer.colors = [startC.cgColor, endC.cgColor]
        CATransaction.commit()
    }
}
