//
//  LogoVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class LogoVC: UIViewController {
    
    //MARK: - Properties
    let logo = FLogo.drawLogo()
    let transition = LogoPopAnim()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        delay(duration: 1.0) {
            guard !appDl.isFirstTime else {
                let vc = NewUserOnboardingVC()
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            let id = "TabBarController"
            let vc = self.storyboard!.instantiateViewController(withIdentifier: id) as! TabBarController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        print(logo.frame.size)
    }
}

//MARK: - Configures

extension LogoVC {
    
    func updateUI() {
        view.backgroundColor = UIColor(hex: 0x282b32)
        navigationController?.delegate = self
        
        let size = view.layer.bounds.size
        logo.position = CGPoint(x: size.width/2, y: size.height/2)
        logo.fillColor = UIColor.white.cgColor
        view.layer.addSublayer(logo)
    }
}

//MARK: - UINavigationControllerDelegate

extension LogoVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        return transition
    }
}
