//
//  RGBView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class RGBView: UIView {
    
    //MARK: - Properties
    let nameLbl = UILabel()
    let percentLbl = UILabel()
    let slider = ColorPickerGradientSlider()
    
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

extension RGBView {
    
    func setupRGBView(_ view: UIView, txt: String) {
        let height: CGFloat = screenHeight*0.07
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Percent
        let fontS: CGFloat
        if appDl.iPhone5 {
            fontS = 12.0
            
        } else {
            fontS = 14.0
        }
        
        percentLbl.configureNameForCell(false, txtColor: .black, fontSize: fontS, isTxt: "100", fontN: fontNamedBold)
        addSubview(percentLbl)
        percentLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Name
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: fontS, isTxt: txt, fontN: fontNamed)
        addSubview(nameLbl)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Slider
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 100
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        let cons1 = estimatedText("100").width+20
        let cons2 = estimatedText("Green").width+20
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: screenWidth),
            heightAnchor.constraint(equalToConstant: height),
            
            percentLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            percentLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            nameLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -cons1),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: cons2)
        ])
    }
}
