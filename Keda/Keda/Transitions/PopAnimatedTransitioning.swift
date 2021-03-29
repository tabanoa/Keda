//
//  PopAnimatedTransitioning.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class PopAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) {
            let containerView = transitionContext.containerView
            let width = containerView.frame.width
            
            var offsetLeft = fromView.frame
            offsetLeft.origin.x = width
            
            var offscreenRight = toView.frame
            offscreenRight.origin.x = -width/3.33
            
            toView.frame = offscreenRight
            fromView.layer.shadowRadius = 5.0
            fromView.layer.shadowOpacity = 1.0
            toView.layer.opacity = 0.9
            containerView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                            toView.frame = fromView.frame
                            fromView.frame = offsetLeft
                            
                            toView.layer.opacity = 1.0
                            fromView.layer.shadowOpacity = 0.1
            }) { (finish) in
                toView.layer.opacity = 1.0
                toView.layer.shadowOpacity = 0.0
                fromView.layer.opacity = 1.0
                fromView.layer.shadowOpacity = 0.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
