//
//  FLogo.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class FLogo {

    class func drawLogo() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 65.19, y: 79.29))
        bezierPath.addLine(to: CGPoint(x: 65.16, y: 80.26))
        bezierPath.addLine(to: CGPoint(x: 65.16, y: 148))
        bezierPath.addLine(to: CGPoint(x: 81.14, y: 148))
        bezierPath.addCurve(to: CGPoint(x: 103.35, y: 138.74), controlPoint1: CGPoint(x: 90.79, y: 148), controlPoint2: CGPoint(x: 98.19, y: 144.92))
        bezierPath.addCurve(to: CGPoint(x: 111.08, y: 111.72), controlPoint1: CGPoint(x: 108.5, y: 132.57), controlPoint2: CGPoint(x: 111.08, y: 123.56))
        bezierPath.addLine(to: CGPoint(x: 120.22, y: 111.72))
        bezierPath.addLine(to: CGPoint(x: 120.22, y: 196.46))
        bezierPath.addLine(to: CGPoint(x: 111.08, y: 196.46))
        bezierPath.addCurve(to: CGPoint(x: 81.14, y: 157.39), controlPoint1: CGPoint(x: 111.08, y: 170.42), controlPoint2: CGPoint(x: 101.11, y: 157.39))
        bezierPath.addLine(to: CGPoint(x: 65.16, y: 157.39))
        bezierPath.addLine(to: CGPoint(x: 65.16, y: 228.94))
        bezierPath.addCurve(to: CGPoint(x: 68.21, y: 237.82), controlPoint1: CGPoint(x: 65.16, y: 233.17), controlPoint2: CGPoint(x: 66.18, y: 236.13))
        bezierPath.addCurve(to: CGPoint(x: 78.61, y: 240.36), controlPoint1: CGPoint(x: 70.23, y: 239.51), controlPoint2: CGPoint(x: 73.7, y: 240.36))
        bezierPath.addLine(to: CGPoint(x: 98.14, y: 240.36))
        bezierPath.addLine(to: CGPoint(x: 98.14, y: 250))
        bezierPath.addLine(to: CGPoint(x: 7.82, y: 250))
        bezierPath.addLine(to: CGPoint(x: 7.82, y: 240.36))
        bezierPath.addLine(to: CGPoint(x: 27.1, y: 240.36))
        bezierPath.addCurve(to: CGPoint(x: 38.27, y: 230.46), controlPoint1: CGPoint(x: 34.54, y: 240.36), controlPoint2: CGPoint(x: 38.27, y: 237.06))
        bezierPath.addLine(to: CGPoint(x: 38.27, y: 81.02))
        bezierPath.addCurve(to: CGPoint(x: 38.13, y: 79.29), controlPoint1: CGPoint(x: 38.27, y: 80.41), controlPoint2: CGPoint(x: 38.22, y: 79.84))
        bezierPath.addLine(to: CGPoint(x: 65.19, y: 79.29))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 77.84, y: 33.94))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 58.38), controlPoint1: CGPoint(x: 52.99, y: 27.25), controlPoint2: CGPoint(x: 0.4, y: 11.42))
        bezierPath.addCurve(to: CGPoint(x: 36.63, y: 144.24), controlPoint1: CGPoint(x: -0.35, y: 99.29), controlPoint2: CGPoint(x: 36.63, y: 144.24))
        bezierPath.addCurve(to: CGPoint(x: 31.65, y: 51.6), controlPoint1: CGPoint(x: 36.63, y: 144.24), controlPoint2: CGPoint(x: 4.73, y: 60.26))
        bezierPath.addCurve(to: CGPoint(x: 107.1, y: 70.47), controlPoint1: CGPoint(x: 49.8, y: 45.76), controlPoint2: CGPoint(x: 57.27, y: 60.56))
        bezierPath.addCurve(to: CGPoint(x: 204.65, y: 0), controlPoint1: CGPoint(x: 162.08, y: 81.41), controlPoint2: CGPoint(x: 204.65, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 77.84, y: 33.94), controlPoint1: CGPoint(x: 204.65, y: 0), controlPoint2: CGPoint(x: 146.6, y: 52.45))
        bezierPath.close()

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.bounds = shapeLayer.path!.boundingBox

        return shapeLayer
    }
}
