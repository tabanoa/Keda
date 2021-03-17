//
//  UpdateView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class UpdateView: UIView {
    
    var text: NSString = ""
    var imgName = ""
    var isCircle = true
    
    class func updateView(_ view: UIView, _ animate: Bool) -> UpdateView {
        let updateView = UpdateView(frame: view.bounds)
        
        updateView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        updateView.isOpaque = false
        updateView.isUserInteractionEnabled = true
        view.addSubview(updateView)
        updateView.showAnimate(animate)
        
        return updateView
    }
    
    override func draw(_ rect: CGRect) {
        let circleH: CGFloat = 96
        if isCircle {
            let circleL = CAShapeLayer()
            let circleR = CGRect(x: bounds.midX - circleH/2,
                                 y: bounds.midY - circleH/2,
                                 width: circleH, height: circleH)
            circleL.path = UIBezierPath(ovalIn: circleR).cgPath
            circleL.lineWidth = 5.0
            circleL.strokeColor = UIColor.white.cgColor
            circleL.fillColor = UIColor.clear.cgColor
            layer.addSublayer(circleL)
        }
        
        if let checkmarkIMG = UIImage(named: imgName) {
            let width = checkmarkIMG.size.width
            let height = checkmarkIMG.size.height
            let x = center.x - (width/2)
            let y = center.y - (height/2)
            let point = CGPoint(x: x, y: y)
            checkmarkIMG.draw(at: point)
        }
        
        let attributes = setupAttri(fontNamedBold, size: 17.0, txtColor: .white)
        let textSize = text.size(withAttributes: attributes)
        let textRect = CGRect(x: center.x - round(textSize.width/2),
                              y: center.y - round(textSize.height/2) + circleH/2 + 20,
                              width: textSize.width, height: textSize.height)
        text.draw(in: textRect, withAttributes: attributes)
    }
    
    func showAnimate(_ animate: Bool) {
        alpha = 0.0
        transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.33) {
            self.alpha = 1.0
            self.transform = .identity
        }
    }
}
