//
//  CategoriesColorsCVC.swift
//  Fashi
//
//  Created by Jack Ily on 05/04/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class CategoriesColorsCVC: UICollectionViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var colors: [UIColor] = []
    var selectedColor = UIColor.clear
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.delegate = self
            navigationController?.popViewController(animated: true)
        case .changed:
            if let interractiveTransition = interactiveTransition {
                interractiveTransition.update(progress)
            }
            
            shouldFinish = progress > percentThreshold
        case .cancelled, .failed:
            interactiveTransition.cancel()
        case .ended:
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
}

//MARK: - Configures

extension CategoriesColorsCVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        let backBtn = UIButton()
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let titleTxt = "Màu Sắc"
//        let titleTxt = "Colors" //ABC
        let width: CGFloat = estimatedText(titleTxt).width + 20.0
        let titleLbl = UILabel()
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt, width: width)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension CategoriesColorsCVC {
    
    
}

//MARK: - UITableViewDelegate

extension CategoriesColorsCVC {
    
    
}

//MARK: - UINavigationControllerDelegate

extension CategoriesColorsCVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition.completionCurve = .easeOut
            
        } else {
            interactiveTransition = nil
        }
        
        return interactiveTransition
    }
}
