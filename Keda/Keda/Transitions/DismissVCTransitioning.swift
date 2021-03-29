//
//  DismissVCTransition.swift
//  Fashi
//
//  Created by Jack Ily on 30/03/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class DismissVCTransition: UIPercentDrivenInteractiveTransition, UIViewControllerTransitioningDelegate {
    
    var kDuration: TimeInterval = 0.33
    var hasStated = false
    var shouldFinish = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let screenBounds = UIScreen.main.bounds
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        let fromVCFrame = CGRect(origin: .zero, size: screenBounds.size)
        let origin = CGPoint(x: -screenBounds.width/3.0, y: 0.0)
        let toVCFrame = CGRect(origin: origin, size: screenBounds.size)
        
        fromVC.view.frame = fromVCFrame
        toVC.view.frame = toVCFrame
        toVC.view.alpha = 0.8
        containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        
        let finalFrame = CGRect(origin: CGPoint(x: screenBounds.width, y: 0.0), size: screenBounds.size)
        
        UIView.animate(withDuration: kDuration,
                       animations: {
                        fromVC.view.frame = finalFrame
                        toVC.view.alpha = 1.0
                        toVC.view.frame = CGRect(origin: .zero, size: screenBounds.size)
        },
                       completion: { _ in
                        if self.shouldFinish == true {
                            fromVC.view.removeFromSuperview()
                        }
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func initializePanGesture(_ vc: UIViewController, selector: Selector) {
        let edgePan = UIPanGestureRecognizer(target: vc, action: selector)
        vc.view.addGestureRecognizer(edgePan)
    }
    
    func dismissVCWithPanGesture(_ vc: UIViewController, _ sender: UIPanGestureRecognizer, edit: Bool) {
        let precentThreshold: CGFloat = 0.4
        let translation = sender.translation(in: vc.view)
        let percent = translation.x / vc.view.bounds.width
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
            shouldFinish = progress > precentThreshold
            update(progress)
        case .cancelled:
            hasStated = false
            cancel()
        case .ended:
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}
