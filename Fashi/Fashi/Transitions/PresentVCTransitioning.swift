//
//  PresentVCTransition.swift
//  Fashi
//
//  Created by Jack Ily on 30/03/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class PresentVCTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: TimeInterval = 0.33
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screenBounds = UIScreen.main.bounds
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
//        let toVCFrame = CGRect(x: screenBounds.width, y: 0.0,
//                               width: screenBounds.width,
//                               height: screenBounds.height)
        let toVCFrame = CGRect(x: 0.0, y: screenBounds.height,
                               width: screenBounds.width,
                               height: screenBounds.height)
        toVC.view.frame = toVCFrame
        fromVC.view.alpha = 1.0
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
//        let origin = CGPoint(x: -screenBounds.width/3.0, y: 0.0)
        let origin = CGPoint(x: 0.0, y: -screenBounds.height/3.33)
        let fromVCFrame = CGRect(origin: origin, size: screenBounds.size)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        fromVC.view.frame = fromVCFrame
                        fromVC.view.alpha = 0.5
                        toVC.view.frame = CGRect(origin: .zero, size: screenBounds.size)
        },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
