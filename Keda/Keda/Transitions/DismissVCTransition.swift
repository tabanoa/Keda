//
//  DismissVCTransition.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class DismissVCTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    var kDuration: TimeInterval = 0.3
    var hasStated = false
    var shouldFinish = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) {
            let containerView = transitionContext.containerView
            let height = containerView.frame.height
            
            var offsetBottom = fromView.frame
            offsetBottom.origin.y = height
            
            var offscreenTop = toView.frame
            offscreenTop.origin.y = -height/3.33
            
            toView.frame = offscreenTop
            fromView.layer.shadowRadius = 5.0
            fromView.layer.shadowOpacity = 1.0
            toView.layer.opacity = 0.9
            containerView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: .curveLinear,
                           animations: {
                            toView.frame = fromView.frame
                            fromView.frame = offsetBottom
                            
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
    
    func initializePanGesture(_ vc: UIViewController, selector: Selector) {
        let edgePan = UIPanGestureRecognizer(target: vc, action: selector)
        vc.view.addGestureRecognizer(edgePan)
    }
    
    func dismissVCWithPanGesture(_ vc: UIViewController, _ sender: UIPanGestureRecognizer, edit: Bool) {
        let precentThreshold: CGFloat = 0.2
        let translation = sender.translation(in: vc.view)
        let percent = translation.y/vc.view.bounds.height
        let progress = CGFloat(fmin(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            if edit == true {
                hasStated = true
                vc.dismiss(animated: true, completion: nil)
                
            } else {
                hasStated = true
                vc.view.window!.rootViewController!.dismiss(animated: true, completion: nil)
            }
        case .changed:
            update(progress)
            shouldFinish = progress > precentThreshold
        case .cancelled: hasStated = false; cancel()
        case .ended: shouldFinish ? finish() : cancel()
        default: break
        }
    }
}
