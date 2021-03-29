//
//  FacebookButton.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import FBSDKLoginKit

class FacebookButton: FBLoginButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 50.0)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let logoSize: CGFloat = 24.0
        let centerY = contentRect.midY
        let y = centerY - (logoSize/2)
        return CGRect(x: y, y: y, width: logoSize, height: logoSize)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if isHidden || bounds.isEmpty { return .zero }
        let titleX = imageRect(forContentRect: contentRect).maxX
        let width = contentRect.width - (titleX*2)
        let height = contentRect.height
        let titleRect = CGRect(x: titleX, y: 3.0, width: width, height: height)
        return titleRect
    }
}
