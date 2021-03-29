//
//  CustomizedTabBar.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class CustomizedTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private var middleBtn = UIButton()
    let shape = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: addShape()
            case .dark: addShape(true)
            default: break
            }
            
        } else {
            addShape()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }

        return nil
    }
    
    private func addShape(_ isDarkMode: Bool = false) {
        let strokeC: UIColor = isDarkMode ? .black : .lightGray
        let fillC: UIColor = isDarkMode ? darkColor : .white
        //shape.path = createBezierPath()
        shape.path = createCirclePath()
        shape.strokeColor = strokeC.cgColor
        shape.fillColor = fillC.cgColor
        shape.lineWidth = 1.0
        shape.shadowOffset = CGSize.zero
        shape.shadowRadius = 10.0
        shape.shadowColor = UIColor.gray.cgColor
        shape.shadowOpacity = 0.3
        
        if let oldShape = shapeLayer {
            layer.replaceSublayer(oldShape, with: shape)
            
        } else {
            layer.insertSublayer(shape, at: 0)
        }
        
        shapeLayer = shape
    }
    
    private func createBezierPath() -> CGPath {
        let path = UIBezierPath()
        let height: CGFloat = 47.0
        let centerW = frame.width/2.0
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: centerW - height*2, y: 0.0))
        
        let value1: CGFloat = 30.0
        let value2: CGFloat = 38.0
        let pt1_1 = CGPoint(x: centerW - value1, y: 0.0)
        let pt2_1 = CGPoint(x: centerW - value2, y: height)
        path.addCurve(to: CGPoint(x: centerW, y: height), controlPoint1: pt1_1, controlPoint2: pt2_1)
        
        let pt1_2 = CGPoint(x: centerW + value2, y: height)
        let pt2_2 = CGPoint(x: centerW + value1, y: 0.0)
        path.addCurve(to: CGPoint(x: centerW + height*2, y: 0.0), controlPoint1: pt1_2, controlPoint2: pt2_2)
        
        path.addLine(to: CGPoint(x: frame.width, y: 0.0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0.0, y: frame.height))
        path.close()
        
        return path.cgPath
    }
    
    private func createCirclePath() -> CGPath {
        let path = UIBezierPath()
        
        let centerW = frame.width/2.0
        let circleW: CGFloat = 69.0
        let value: CGFloat = 24.0
        let value1: CGFloat = 29.0
        let value2: CGFloat = 10.0
        let value3: CGFloat = 16.0
        
        path.move(to: .zero)
        path.move(to: CGPoint(x: centerW-circleW/2, y: 0.0))
        path.addCurve(to: CGPoint(x: centerW, y: -value), controlPoint1: CGPoint(x: centerW-value1, y: -(value-value2)), controlPoint2: CGPoint(x: centerW-value3, y: -value))
        path.addCurve(to: CGPoint(x: centerW+circleW/2, y: 0.0), controlPoint1: CGPoint(x: centerW+value3, y: -value), controlPoint2: CGPoint(x: centerW+value1, y: -(value-value2)))
        
        path.addLine(to: CGPoint(x: frame.width, y: 0.0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: 0.0))
        path.addLine(to: CGPoint(x: centerW-circleW/2, y: 0.0))
        path.close()
        
        return path.cgPath
    }
}
