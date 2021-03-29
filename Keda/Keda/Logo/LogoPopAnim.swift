////
////  LogoPopAnim.swift
////  Keda
////
////  Created by Matthew Mukherjee on 03/03/2021.
//
//import UIKit
//
//class LogoPopAnim: NSObject {
//
//    var context: UIViewControllerContextTransitioning?
//    var operation: UINavigationController.Operation = .push
//}
//
//extension LogoPopAnim: UIViewControllerAnimatedTransitioning {
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 1.0
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        context = transitionContext
//
//        guard operation == .push else { return }
//        if let toVC = !appDl.isFirstTime ?
//            transitionContext.viewController(forKey: .to) as? TabBarController :
//            transitionContext.viewController(forKey: .to) as? NewUserOnboardingVC,
//            let fromVC = transitionContext.viewController(forKey: .from) as? LogoVC {
//            let containerView = transitionContext.containerView
//            let duration = transitionDuration(using: transitionContext)
//
//            containerView.addSubview(toVC.view)
//            toVC.view.frame = transitionContext.finalFrame(for: toVC)
//
//            let concat = CATransform3DConcat(CATransform3DMakeTranslation(20.0, -50.0, 0.0),
//                                             CATransform3DMakeScale(50.0, 50.0, 1.0))
//            let scaleAnim = CABasicAnimation(keyPath: "transform")
//            scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
//            scaleAnim.toValue = NSValue(caTransform3D: concat)
//
//            let opaAnim = CABasicAnimation(keyPath: "opacity")
//            opaAnim.fromValue = 1.0
//            opaAnim.toValue = 0.0
//
//            let groupAnim = CAAnimationGroup()
//            groupAnim.duration = duration
//            groupAnim.isRemovedOnCompletion = false
//            groupAnim.fillMode = .forwards
//            groupAnim.timingFunction = CAMediaTimingFunction(name: .easeIn)
//            groupAnim.delegate = self
//            groupAnim.animations = [scaleAnim, opaAnim]
//
//            let maskLayer = FLogo.drawLogo()
//            maskLayer.position = fromVC.logo.position
//            toVC.view.layer.mask = maskLayer
//            maskLayer.add(groupAnim, forKey: nil)
//            fromVC.view.layer.add(groupAnim, forKey: nil)
//
//            let fadeAnim = CABasicAnimation(keyPath: "opacity")
//            fadeAnim.duration = duration
//            fadeAnim.fromValue = 0.0
//            fadeAnim.toValue = 1.0
//            toVC.view.layer.add(fadeAnim, forKey: nil)
//        }
//    }
//}
//
//extension LogoPopAnim: CAAnimationDelegate {
//
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        guard let context = context else { self.context = nil; return }
//        context.completeTransition(!context.transitionWasCancelled)
//
//        let fromVC = context.viewController(forKey: .from) as! LogoVC
//        fromVC.view.layer.removeAllAnimations()
//
//        let toVC = !appDl.isFirstTime ?
//            context.viewController(forKey: .to) as! TabBarController :
//            context.viewController(forKey: .to) as! NewUserOnboardingVC
//        toVC.view.layer.mask = nil
//        print("*** Done")
//    }
//}
