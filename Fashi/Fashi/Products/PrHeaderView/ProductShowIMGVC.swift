//
//  ProductShowIMGVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductShowIMGVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollCenterLayout = ScrollCenterLayout()
    var imageLinks: [String] = []
    
    var dismissVCTrans: DismissVCTransition!
    var currentPage = 0
    
    //MARK: - Initialize
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dismissVCTrans = DismissVCTransition()
        
        transitioningDelegate = self
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        dismissVCTrans.initializePanGesture(self, selector: #selector(handlePanDismiss))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            self.collectionView.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard dismissVCTrans != nil else { return }
        dismissVCTrans.hasStated = false
        dismissVCTrans = nil
    }
    
    @objc func handlePanDismiss(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismissVCTrans.dismissVCWithPanGesture(self, sender, edit: true)
    }
}

//MARK: - Configures

extension ProductShowIMGVC {
    
    func updateUI() {
        //TODO: - UICollectionView
        view.backgroundColor = .black
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.register(ShowIMGViewCVCell.self, forCellWithReuseIdentifier: ShowIMGViewCVCell.identifier)
        collectionView.isPagingEnabled = true
        
        collectionView.collectionViewLayout = scrollCenterLayout
        scrollCenterLayout.scrollDirection = .horizontal
        scrollCenterLayout.minimumLineSpacing = 0
        scrollCenterLayout.itemSize = CGSize(width: screenWidth, height: screenHeight)
        
        //TODO: - CancelBtn
        let cancelBtn = UIButton()
        cancelBtn.setImage(UIImage(named: "icon-cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        view.insertSubview(cancelBtn, aboveSubview: collectionView)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelBtn.widthAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            cancelBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) { self.handleDismissVC() }
    }
}

//MARK: - UICollectionViewDataSource

extension ProductShowIMGVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowIMGViewCVCell.identifier, for: indexPath) as! ShowIMGViewCVCell
        cell.link = imageLinks[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProductShowIMGVC: UICollectionViewDelegate {}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductShowIMGVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
}

//MARK: - UIScrollView

extension ProductShowIMGVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -80.0 {
            handleDismissVC()
            
        } else if scrollView.contentOffset.x > screenWidth*CGFloat(imageLinks.count-1) + 80 {
            handleDismissVC()
        }
    }
    
    func handleDismissVC() {
        guard dismissVCTrans != nil else { return }
        dismissVCTrans.hasStated = false
        dismissVCTrans = nil
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension ProductShowIMGVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissVCTrans
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissVCTrans.hasStated ? dismissVCTrans : nil
    }
}
