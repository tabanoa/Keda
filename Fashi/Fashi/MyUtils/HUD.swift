//
//  HUD.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class HUD: UIView {
    
    var isRefresh = false
    
    class func hud(_ view: UIView, effect: Bool) -> HUD {
        let hud = HUD(frame: view.bounds)
        
        view.insertSubview(hud, at: 10)
        hud.isUserInteractionEnabled = true
        hud.isOpaque = false
        hud.backgroundColor = UIColor(hex: 0x000000, alpha: 0.1)
        animate(hud: hud, effect: effect)
        
        return hud
    }
    
    override func draw(_ rect: CGRect) {
        let boxHeight: CGFloat = 90.0

        let rect = CGRect(x: (bounds.size.width - boxHeight)/2.0,
                          y: (bounds.size.height - boxHeight)/2.0,
                          width: boxHeight,
                          height: boxHeight)
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        UIColor(white: 0.3, alpha: 0.7).setFill()
        bezierPath.fill()
        
        if isRefresh == false {
            let dotView = DotView()
            addSubview(dotView)
            dotView.center = center
            
        } else {
            let height: CGFloat = 20.0
            let indicator = UIActivityIndicatorView()
            indicator.frame = CGRect(x: (bounds.size.width - height)/2.0,
                                     y: (bounds.size.height - height)/2.0,
                                     width: height,
                                     height: height)
            indicator.style = .whiteLarge
            indicator.startAnimating()
            addSubview(indicator)
        }
    }
    
    class func animate(hud: HUD, effect: Bool) {
        if effect == true {
            hud.alpha = 0.0
            UIView.animate(withDuration: 0.33) { hud.alpha = 1.0 }
        }
    }
}
