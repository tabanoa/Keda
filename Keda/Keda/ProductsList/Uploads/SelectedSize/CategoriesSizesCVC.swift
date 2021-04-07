//
//  CategoriesSizesCVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesSizesCVC: UICollectionViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let addBtn = UIButton()
    private let nextBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    
    private let nextTxt = NSLocalizedString("Next", comment: "CategoriesSizesCVC.swift: Next")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var sizes: [String] = []
    var selectedColors: [UIColor] = []
    var selectedSizes: [String] = []
    
    var category: String = ""
    var prUID: String = ""
    var type: String = ""
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        setupDarkMode()
        
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
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Add
        addBtn.frame = CGRect(x: naContainerV.frame.width-80.0, y: 0.0, width: 40.0, height: 40.0)
        addBtn.setImage(UIImage(named: "icon-add"), for: .normal)
        addBtn.addTarget(self, action: #selector(addDidTap), for: .touchUpInside)
        naContainerV.addSubview(addBtn)
        
        //TODO: - Next
        let attributed = setupTitleAttri(nextTxt, size: 17.0)
        nextBtn.setAttributedTitle(attributed, for: .normal)
        nextBtn.frame = CGRect(x: naContainerV.frame.width-35.0, y: 0.0, width: 50.0, height: 40.0)
        nextBtn.contentMode = .right
        nextBtn.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        nextBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 10.0)
        naContainerV.addSubview(nextBtn)
        
        //TODO: - Title
        let titleTxt = NSLocalizedString("Sizes", comment: "CategoriesSizesCVC.swift: Sizes")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            guard self.selectedSizes.count != 0 else {
                let txt = NSLocalizedString("Select Sizes", comment: "CategoriesSizesCVC.swift: Select Sizes")
                handleInternet(txt, imgName: "icon-error")
                return
            }
            
            let categoriesColorSizeTVC = CategoriesColorSizeTVC(style: .grouped)
            categoriesColorSizeTVC.selectedSizes = self.selectedSizes
            categoriesColorSizeTVC.selectedColors = self.selectedColors
            categoriesColorSizeTVC.category = self.category
            categoriesColorSizeTVC.prUID = self.prUID
            categoriesColorSizeTVC.type = self.type
            self.navigationController?.pushViewController(categoriesColorSizeTVC, animated: true)
        }
    }
    
    @objc func addDidTap() {
        let txt = NSLocalizedString("Add Size", comment: "CategoriesSizesCVC.swift: Add Size")
        let saveTxt = NSLocalizedString("Save", comment: "CategoriesSizesCVC.swift: Save")
        let cancelTxt = NSLocalizedString("Cancel", comment: "CategoriesSizesCVC.swift: Cancel")
        let alert = UIAlertController(title: txt, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "S"
            textField.font = UIFont(name: fontNamed, size: 17.0)
            textField.autocapitalizationType = .allCharacters
            
            if #available(iOS 12.0, *) {
                switch self.traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    textField.textColor = .black
                    appDl.window?.tintColor = .black
                case .dark:
                    textField.textColor = .white
                    appDl.window?.tintColor = .white
                default: break
                }
            } else {
                textField.textColor = .black
                appDl.window?.tintColor = .black
            }
        }
        
        let saveAct = UIAlertAction(title: saveTxt, style: .default) { (_) in
            guard let textField = alert.textFields?.first else { return }
            if let text = textField.text,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let txt = text.replacingOccurrences(of: ".", with: ",")
                if !self.sizes.contains(txt.uppercased()) {
                    self.sizes.append(txt.uppercased())
                    self.collectionView.reloadData()
                }
            }
        }
        
        let cancelAct = UIAlertAction(title: cancelTxt, style: .cancel, handler: nil)
        alert.addAction(saveAct)
        alert.addAction(cancelAct)
        present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoriesSizesCVCell.self, forCellWithReuseIdentifier: CategoriesSizesCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionView.reloadData()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesSizesCVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesSizesCVCell.identifier, for: indexPath) as! CategoriesSizesCVCell
        let size = sizes[indexPath.item]
        cell.sizeLbl.text = size
        setupCell(size, cell: cell)
        return cell
    }
    
    func setupCell(_ size: String, cell: CategoriesSizesCVCell) {
        cell.isSelect = selectedSizes.contains(size)
        
        let cellW = cell.frame.width
        let textW = estimatedText(size, fontS: 17.0).width
        cell.sizeLbl.font = UIFont(name: fontNamedBold, size: cellW < textW ? 12.0 : 15.0)
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesSizesCVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesSizesCVCell else { return }
        let size = sizes[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.handleSelectedColor(size)
            self.collectionView.reloadData()
        }
    }
    
    func handleSelectedColor(_ size: String) {
        if !selectedSizes.contains(size) {
            selectedSizes.append(size)
            
        } else if selectedSizes.contains(size) {
            guard let index = selectedSizes.firstIndex(of: size) else { return }
            selectedSizes.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesSizesCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 35.0
        let width = (collectionView.bounds.width - 5*5)/4
        return CGSize(width: width, height: height)
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

//MARK: - DarkMode

extension CategoriesSizesCVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        view.backgroundColor = isDarkMode ? .black : .white
        collectionView.backgroundColor = isDarkMode ? .black : .white
    }
}
