//
//  ProductsListDetailVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ProductsListDetailVCDelegate: class {
    func handleDeleteProduct(indexPath: IndexPath, vc: ProductsListDetailVC, pr: Product)
}

class ProductsListDetailVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: ProductsListDetailVCDelegate?
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let naContainerV = UIView()
    private let backBtn = UIButton()
    private let deleteBtn = ShowMoreBtn()
    private let titleLbl = UILabel()
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var product: Product!
    var indexPath = IndexPath()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupTableView()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

//MARK: - Configures

extension ProductsListDetailVC {
    
    func setupNavi() {
        view.backgroundColor = groupColor
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        titleLbl.configureTitleForNavi(naContainerV, isTxt: product.type)
        
        //TODO: - Delete
        let deleteTxt = NSLocalizedString("Delete", comment: "ProductsListDetailVC.swift: Delete")
        let isDel = deleteTxt == "Delete" ? true : false
        let attriDel = setupTitleAttri(deleteTxt, size: 17.0)
        deleteBtn.setAttributedTitle(attriDel, for: .normal)
        deleteBtn.frame = CGRect(x: naContainerV.frame.width-(isDel ? 45 : 35), y: 0.0, width: 70.0, height: 40.0)
        deleteBtn.contentMode = .right
        deleteBtn.addTarget(self, action: #selector(deleteDidTap), for: .touchUpInside)
        deleteBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 10.0)
        naContainerV.addSubview(deleteBtn)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteDidTap() {
        let txt = NSLocalizedString("Are you sure want to delete?", comment: "ProductsListDetailVC.swift: Are you sure want to delete?")
        handleMessageAlert(vc: self, txt: txt, traitCollection: traitCollection) {
            self.product.deletePr {}
            self.delegate?.handleDeleteProduct(indexPath: self.indexPath, vc: self, pr: self.product)
        }
    }
    
    func setupTableView() {
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.separatorColor = lightSeparatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15.0)
        tableView.register(ProductsListDetailTVCell.self, forCellReuseIdentifier: ProductsListDetailTVCell.identifier)
        tableView.rowHeight = 44.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

//MARK: - UITableViewDataSource

extension ProductsListDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return product.prColors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.prColors[section].prSizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsListDetailTVCell.identifier, for: indexPath) as! ProductsListDetailTVCell
        let model = product.prColors[indexPath.section].prSizes[indexPath.item]
        cell.sizeLbl.text = model.size
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProductsListDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let prColor = product.prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        let infoModel = prSize.prInfoModel
        let categoriesInfoTVC = CategoriesInfoTVC(style: .grouped)
        categoriesInfoTVC.kImageLinks = infoModel.imageLinks
        categoriesInfoTVC.kName = infoModel.name
        categoriesInfoTVC.kPrice = infoModel.price
        categoriesInfoTVC.kDescription = infoModel.description
        categoriesInfoTVC.kSaleOff = infoModel.saleOff
        categoriesInfoTVC.kTags = product.tags
        categoriesInfoTVC.isEdit = true
        categoriesInfoTVC.category = prSize.size
        categoriesInfoTVC.prUID = product.uid
        categoriesInfoTVC.kColor = prColor.color
        categoriesInfoTVC.kSize = prSize.size
        categoriesInfoTVC.createdTime = product.createdTime
        categoriesInfoTVC.type = product.type
        categoriesInfoTVC.active = product.active
        categoriesInfoTVC.kDelegate = self
        categoriesInfoTVC.indexPath = indexPath
        navigationController?.pushViewController(categoriesInfoTVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        let rect = CGRect(x: 15.0, y: 2.5, width: 35.0, height: 35.0)
        let colorView = UIView(frame: rect)
        colorView.clipsToBounds = true
        colorView.layer.cornerRadius = 3.0
        colorView.layer.borderColor = UIColor.gray.cgColor
        colorView.layer.borderWidth = 0.5
        colorView.backgroundColor = product.prColors[section].color.getHexColor()
        kView.addSubview(colorView)
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                kView.backgroundColor = groupColor
            case .dark:
                kView.backgroundColor = .black
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        
        return kView
    }
}

//MARK: - CategoriesInfoTVCKDelegate

extension ProductsListDetailVC: CategoriesInfoTVCKDelegate {
    
    func fetchColorSizeFromPr(indexPath: IndexPath, vc: CategoriesInfoTVC) {
        vc.navigationController?.popViewController(animated: true)
        
        let prColor = product.prColors[indexPath.section]
        let prSize = prColor.prSizes[indexPath.item]
        product.deleteSizeFromPr(color: prColor.color, size: prSize.size) {}
        
        product.prColors[indexPath.section].prSizes.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
        if product.prColors[indexPath.section].prSizes.count <= 0 {
            product.proModel.prColors.remove(at: indexPath.section)
            
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .automatic)
        }
        
        if product.prColors.count <= 0 {
            product.deletePr {}
            delegate?.handleDeleteProduct(indexPath: self.indexPath, vc: self, pr: product)
        }
    }
}

//MARK: - UINavigationControllerDelegate

extension ProductsListDetailVC: UINavigationControllerDelegate {
    
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

extension ProductsListDetailVC {
    
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
        view.backgroundColor = isDarkMode ? .black : groupColor
        tableView.backgroundColor = isDarkMode ? .black : groupColor
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        tableView.reloadData()
    }
}
