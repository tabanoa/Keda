//
//  CategoriesColorsCVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class CategoriesColorsCVC: UICollectionViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let addBtn = UIButton()
    private let nextBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    
    private let nextTxt = NSLocalizedString("Next", comment: "CategoriesColorsCVC.swift: Next")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    lazy var colors: [UIColor] = {
        return [
            .black, .white, .red, .orange, .yellow, .green, .blue, .cyan, .purple, .brown
        ]
    }()
    
    var selectedColors: [UIColor] = []
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
        
        let t1 = Int.random(9)
        let t2 = Int.random(9)
        let t3 = Int.random(9)
        let t = "\(t1)\(t2)\(t3)"
        
        let r1 = Int.random(9)
        let r2 = Int.random(9)
        let r3 = Int.random(9)
        let r = "\(r1)\(r2)\(r3)"
        
        let index = categories.firstIndex(of: category)!
        type = kCategories[index]
        prUID = "123\(t)-\(type.uppercased())-\(r)"
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
        let titleTxt = NSLocalizedString("Colors", comment: "CategoriesColorsCVC.swift: Colors")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: titleTxt)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addDidTap() {
        let editColorVC = EditColorVC()
        editColorVC.kDelegate = self
        editColorVC.modalPresentationStyle = .fullScreen
        present(editColorVC, animated: true, completion: nil)
    }
    
    @objc func nextDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            guard self.selectedColors.count != 0 else {
                let txt = NSLocalizedString("Select Color", comment: "CategoriesColorsCVC.swift: Select Color")
                handleInternet(txt, imgName: "icon-error")
                return
            }
            
            let categoriesSizesCVC = CategoriesSizesCVC(collectionViewLayout: UICollectionViewFlowLayout())
            categoriesSizesCVC.selectedColors = self.selectedColors
            categoriesSizesCVC.category = self.category
            categoriesSizesCVC.prUID = self.prUID
            categoriesSizesCVC.type = self.type
            
            let size: [String] = ["S", "M", "L", "XL"]
            switch true {
            case categories[0] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[1] == self.category:
                categoriesSizesCVC.sizes = ["NOSIZE"]
            case categories[2] == self.category:
                categoriesSizesCVC.sizes = ["EU 35.5", "EU 36", "EU 36.5", "EU 37.5"]
            case categories[3] == self.category:
                categoriesSizesCVC.sizes = ["38MM", "40MM", "44MM"]
            case categories[4] == self.category:
                let str = """
L:9.8" * W:5.7" * H:9.8"
"""
                categoriesSizesCVC.sizes = [str]
            case categories[5] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[6] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[7] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[8] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[9] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[10] == self.category:
                categoriesSizesCVC.sizes = size
            case categories[11] == self.category:
                categoriesSizesCVC.sizes = size
            default: break
            }
            
            self.navigationController?.pushViewController(categoriesSizesCVC, animated: true)
        }
    }
    
    func updateUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoriesColorsCVCell.self, forCellWithReuseIdentifier: CategoriesColorsCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionView.reloadData()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
    }
}

//MARK: - UICollectionViewDataSource

extension CategoriesColorsCVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesColorsCVCell.identifier, for: indexPath) as! CategoriesColorsCVCell
        let color = colors[indexPath.item]
        cell.color = color
        setupCell(color, cell: cell)
        return cell
    }
    
    func setupCell(_ color: UIColor, cell: CategoriesColorsCVCell) {
        cell.isSelect = selectedColors.contains(color)
    }
}

//MARK: - UICollectionViewDelegate

extension CategoriesColorsCVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesColorsCVCell else { return }
        let color = colors[indexPath.item]
        
        touchAnim(cell, frValue: 0.8) {
            self.handleSelectedColor(color)
            self.collectionView.reloadData()
        }
    }
    
    func handleSelectedColor(_ color: UIColor) {
        if !selectedColors.contains(color) {
            selectedColors.append(color)
            
        } else if selectedColors.contains(color) {
            guard let index = selectedColors.firstIndex(of: color) else { return }
            selectedColors.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesColorsCVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (screenWidth-(5*9))/8
        return CGSize(width: cellSize, height: cellSize)
    }
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

//MARK: - EditColorVCDelegate

extension CategoriesColorsCVC: EditColorVCDelegate {
    
    func fetchColor(_ color: UIColor, vc: EditColorVC) {
        if !colors.contains(color) {
            colors.append(color)
            collectionView.reloadData()
        }

        vc.dismiss(animated: true, completion: nil)
    }
}

//MARK: - DarkMode

extension CategoriesColorsCVC {
    
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
