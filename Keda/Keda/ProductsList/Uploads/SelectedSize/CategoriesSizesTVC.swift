//
//  CategoriesSizesCVC.swift
//  Fashi
//
//  Created by Jack Ily on 13/04/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

class CategoriesSizesCVC: UITableViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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

extension CategoriesSizesCVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        let backBtn = UIButton()
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Edit
        let editBtn = ShowMoreBtn()
        let editTxt = "Tiếp" //ABC
//        let editTxt = "Next" //ABC
        let attributed = setupTitleAttri(editTxt, size: 17.0)
        editBtn.setAttributedTitle(attributed, for: .normal)
        editBtn.frame = CGRect(x: naContainerV.frame.width-35.0, y: 0.0, width: 50.0, height: 40.0)
        editBtn.contentMode = .right
        editBtn.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        editBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 10.0)
        naContainerV.addSubview(editBtn)
        
        //TODO: - Title
        let titleTxt = "Kích Thước"
//        let titleTxt = "Sizes" //ABC
        let width: CGFloat = estimatedText(titleTxt).width + 20.0
        let titleLbl = UILabel()
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt, width: width)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            let categoriesSizesTVC = CategoriesSizesCVC()
            self.navigationController?.pushViewController(categoriesSizesTVC, animated: true)
        }
    }
    
    func updateUI() {
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.separatorStyle = .none
        tableView.register(CategoriesTVCell.self, forCellReuseIdentifier: CategoriesTVCell.identifier)
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension CategoriesSizesCVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.productColorTVCell, for: indexPath) as! ProductColorTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.classifyProductTVC = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.productSizeTVCell, for: indexPath) as! ProductSizeTVCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.classifyProductTVC = self
            return cell
        }
    }
}

//MARK: - UITableViewDelegate

extension CategoriesSizesCVC {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - UINavigationControllerDelegate

extension CategoriesSizesCVC: UINavigationControllerDelegate {
    
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
