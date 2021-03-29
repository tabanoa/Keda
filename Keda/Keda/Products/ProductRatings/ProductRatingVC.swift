//
//  ProductRatingVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import BSImagePicker
import Photos

class ProductRatingVC: UIViewController {
    
    //MARK: - Properties
    private let internetView = InternetView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let headerView = ProductRatingHeaderView()
    private let bottomView = ProductRatingBottomView()
    private let naContainerV = UIView()
    private var hud = HUD()
    
    private let bagBtn = UIButton()
    private let backBtn = UIButton()
    private let titleLbl = UILabel()
    private let quantityLbl = UILabel()
    
    private let imagePicker = BSImagePickerViewController()
    private var assets: [PHAsset] = []
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var prUID: String = ""
    var images: [UIImage] = []
    var isPurchased = false
    
    var rating1: Int = 0
    var rating2: Int = 0
    var rating3: Int = 0
    var rating4: Int = 0
    var rating5: Int = 0
    
    lazy var reviews: [Review] = []
    var average: Double = 0.0
    var rating: String = ""
    var total: Int = 0
    
    lazy var usersUID: [String] = []
    var prRating: Rating?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        
        setupNavi()
        setupBottomView()
        setupTV()
        setupCV()
        setupHeaderView()
        setupDarkMode()
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        handleNotificationCenter()
        
        guard isInternetAvailable() else {
            naContainerV.isHidden = true
            tableView.isHidden = true
            bottomView.isHidden = true
            headerView.isHidden = true
            internetView.setupInternetView(view, dl: self)
            return
        }
        
        fetchReviews()
        
        if appDl.isProductRatingVC {
            naContainerV.isHidden = true
            tableView.isHidden = true
            bottomView.isHidden = true
            headerView.isHidden = true
            collectionView.isHidden = true
            hud = createdHUD()
        }
        
        fetchData(hud)
        
        guard let prRating = prRating else { return }
        guard isLogIn() else { headerView.ratingSV.isTap = false; return }
        let contains = prRating.ratings.contains(currentUID)
        headerView.ratingSV.isTap = isPurchased ? !contains : contains
        headerView.ratingSV.rating = prRating.containerUserUID()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard isLogIn() else { return }
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Configures

extension ProductRatingVC {
    
    func setupNavi() {
        naContainerV.configureContainerView(navigationItem)
        
        //TODO - Bag
        bagBtn.configureFilterBtn(naContainerV, imgNamed: "icon-bag", selector: #selector(bagDidTap), controller: self)

        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Title
        let title = NSLocalizedString("Product Ratings", comment: "ProductRatingVC.swift: Product Ratings")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: title)
        
        //TODO: - Quantity
        naContainerV.insertSubview(quantityLbl, belowSubview: bagBtn)
        setupBagLbl(0, label: quantityLbl)
        
        let x = naContainerV.frame.width-23.0
        quantityLbl.frame = CGRect(x: x, y: 0.0, width: 30.0, height: 30.0)
    }
    
    @objc func bagDidTap() {
        if isLogIn() {
            handleBackToTabCart()
            
            for vc in navigationController!.viewControllers {
                if vc.isKind(of: HomeVC.self) {
                    navigationController?.popToViewController(vc, animated: true)
                    
                } else if vc.isKind(of: WishlistVC.self) {
                    navigationController?.popToViewController(vc, animated: true)
                }
            }
            
        } else {
            presentWelcomeVC(self, isPresent: true)
        }
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupTV() {
        tableView.configureTVSepar(ds: self, dl: self, view: view)
        tableView.register(ProductRatingTVCell.self, forCellReuseIdentifier: ProductRatingTVCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 50.0, right: 20.0)
        tableView.separatorColor = lightSeparatorColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.keyboardDismissMode = .onDrag
        tableView.tableHeaderView?.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: isPurchased ? bottomView.topAnchor : view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupCV() {
        imagePicker.maxNumberOfSelections = 5
        
        collectionView.configureCV(.white, ds: self, dl: self)
        collectionView.register(CategoriesImageCVCell.self, forCellWithReuseIdentifier: CategoriesImageCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionView.isScrollEnabled = false
        collectionView.isHidden = images.count == 0
        view.insertSubview(collectionView, aboveSubview: tableView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: 44.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
    }
    
    func setupHeaderView() {
        headerView.setupHeaderView(tableView: tableView, dl: self)
        headerView.ratingSV.isTap = isPurchased
    }
    
    func setupBottomView() {
        bottomView.setupBottomView(view, tv: tableView, dl: self)
    }
}

//MARK: - Functions

extension ProductRatingVC {
    
    func handleNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSelectedIndex),
                                               name: Notification.Name("DismissHomeVC"),
                                               object: nil)
    }
    
    @objc func handleSelectedIndex() {
        handleBackToTabHome()
    }
    
    @objc func showKeyboard(_ notif: Notification) {
        if let heightRect = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration,
                           animations: {
                            self.bottomView.bottomConsBV.constant = -heightRect.height
                            self.view.layoutIfNeeded()
            },
                           completion: { _ in
                            self.scrollTableView()
            })
        }
    }
    
    func scrollTableView() {
        DispatchQueue.main.async {
            guard self.reviews.count != 0 else { return }
            let indexPath = IndexPath(item: self.reviews.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.tableView.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard(_ notif: Notification) {
        if let duration = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
            UIView.animate(withDuration: duration) {
                self.bottomView.bottomConsBV.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let percent = translation.x / view.bounds.width
        let progress = CGFloat(fminf(fmax(Float(percent), 0.0), 1.0))
        
        switch sender.state {
        case .began:
            navigationController?.setNavigationBarHidden(!(percent<0.0), animated: true)
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
            navigationController?.setNavigationBarHidden(shouldFinish, animated: true)
            shouldFinish ? interactiveTransition.finish() : interactiveTransition.cancel()
        default: break
        }
    }
    
    func reloadDataAndScroll() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            let contentH = self.tableView.contentSize.height
            let tvHeight = self.tableView.bounds.height
            
            if contentH > tvHeight {
                let point = CGPoint(x: 0.0, y: contentH-tvHeight+10)
                self.tableView.contentOffset = point
            }
        }
    }
    
    func fetchData(_ hud: HUD) {
        handleRemoveHUD(hud)
        setupHeaderContent()
        
        guard isLogIn() else { return }
        ShoppingCart.fetchShoppingCart(completion: { (shoppingCart) in
            if let shoppingCart = shoppingCart {
                self.quantityLbl.text = "\(shoppingCart.productCarts.count)"
                
            } else {
                self.quantityLbl.text = "\(0)"
            }
        })
    }
    
    func handleRemoveHUD(_ hud: HUD) {
        removeHUD(hud, duration: 0.5) {
            self.naContainerV.isHidden = false
            self.tableView.isHidden = false
            self.bottomView.isHidden = !self.isPurchased
            self.headerView.isHidden = false
            self.collectionView.isHidden = self.images.count == 0
        }
    }
    
    func setupHeaderContent() {
        headerView.averageLbl.text = "\((round(average*10))/10)"
        
        let ratingTxt = NSLocalizedString("Ratings", comment: "ProductRatingVC.swift: Ratings")
        handleText(Double(total)) { (rating) in
            self.headerView.ratingCountLbl.text = "\(rating) \(ratingTxt)"
        }
        
        headerView.ratingLargeSV.rating = Int(average)
        headerView.setupProgressViewUnit(rating5, rating4, rating3, rating2, rating1)
    }
    
    func fetchReviews() {
        Review.fetchReviews(prUID: prUID) { (reviews) in
            self.reviews = reviews.sorted(by: { $0.createdTime < $1.createdTime })
            self.reloadDataAndScroll()
        }
    }
}

//MARK: - UINavigationControllerDelegate

extension ProductRatingVC: UINavigationControllerDelegate {
    
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

//MARK: - UITableViewDataSource

extension ProductRatingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductRatingTVCell.identifier, for: indexPath) as! ProductRatingTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        guard reviews.count != 0 else { return cell }
        cell.prRating = prRating
        cell.review = reviews[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProductRatingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: kView.backgroundColor = groupColor
            case .dark: kView.backgroundColor = darkSeparatorColor
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        return kView
    }
}

//MARK: - RatingStackViewDelegate

extension ProductRatingVC: RatingStackViewDelegate {
    
    func fetchRating(_ rating: Int) {
        let txt = NSLocalizedString("Thanks for your feedback", comment: "ProductRatingVC.swift: Thanks for your feedback")
        handleInternet(txt, imgName: "icon-rating", isCircle: false) {
            self.total += 1
            if rating == 1 { self.rating1 += 1 }
            if rating == 2 { self.rating2 += 1 }
            if rating == 3 { self.rating3 += 1 }
            if rating == 4 { self.rating4 += 1 }
            if rating == 5 { self.rating5 += 1 }
            self.setupHeaderContent()
        }
        
        let r = Rating()
        r.saveRating(prUID, rating)
    }
}

//MARK: - ProductRatingTVCellDelegate

extension ProductRatingVC: ProductRatingTVCellDelegate {
    
    func viewImage(_ cell: ProductRatingTVCell, indexPath: IndexPath) {
        let showIMGViewVC = ShowIMGViewVC()
        showIMGViewVC.imageLinks = cell.imageLinks
        showIMGViewVC.indexPath = indexPath
        
        if let indexP = tableView.indexPath(for: cell) {
            showIMGViewVC.review = reviews[indexP.row]
        }
        
        showIMGViewVC.prRating = prRating
        showIMGViewVC.modalPresentationStyle = .fullScreen
        present(showIMGViewVC, animated: true, completion: nil)
    }
    
    func viewAllImage(_ cell: ProductRatingTVCell, indexPath: IndexPath) {
        let quantityIMGViewVC = QuantityIMGViewVC()
        quantityIMGViewVC.imageLinks = cell.imageLinks
        
        if let indexP = tableView.indexPath(for: cell) {
            quantityIMGViewVC.review = reviews[indexP.row]
        }
        
        quantityIMGViewVC.prRating = prRating
        navigationController?.pushViewController(quantityIMGViewVC, animated: true)
    }
}

//MARK: - ProductRatingBottomViewDelegate

extension ProductRatingVC: ProductRatingBottomViewDelegate {
    
    func handleSend(_ txt: String) {
        if txt != "", images.count == 0 {
            let model = ReviewModel(userUID: currentUID, description: txt, imageLinks: [], type: reviewTxt)
            let review = Review(model: model)
            review.saveReview(prUID: prUID) { self.fetchReviews() }
            
        } else if txt == "", images.count != 0 {
            collectionView.isHidden = true
            
            let model = ReviewModel(userUID: currentUID, description: nil, imageLinks: [], type: reviewIMG, show: false)
            let review = Review(model: model)
            review.saveReview(prUID: prUID) {
                self.uploadImageToImgur { (imageLinks) in
                    Review.saveImageLinks(prUID: self.prUID, rUID: review.uid, imageLinks: imageLinks) {
                        self.fetchReviews()
                    }
                }
            }
            
        } else if txt != "", images.count != 0 {
            collectionView.isHidden = true
            
            let model = ReviewModel(userUID: currentUID, description: txt, imageLinks: [], type: reviewTxtAndIMG, show: false)
            let review = Review(model: model)
            review.saveReview(prUID: prUID) {
                self.uploadImageToImgur { (imageLinks) in
                    Review.saveImageLinks(prUID: self.prUID, rUID: review.uid, imageLinks: imageLinks) {
                        self.fetchReviews()
                    }
                }
            }
            
        } else {
            return
        }
    }
    
    func uploadImageToImgur(_ completion: @escaping ([String]) -> Void) {
        var imageLinks: [String] = []
        for image in images {
            Imgur.sharedInstance.uploadImageToImgur(image) { (link) in
                if !imageLinks.contains(link) {
                    imageLinks.append(link)
                    DispatchQueue.main.async {
                        self.removeImgs()
                        completion(imageLinks)
                    }
                }
            }
        }
    }
    
    func removeImgs() {
        images.removeAll()
        collectionView.isHidden = images.count == 0
        collectionView.reloadData()
    }
    
    func handlePhoto() {
        guard images.count < 5 else { return }
        imagePicker.modalPresentationStyle = .fullScreen
        bs_presentImagePickerController(
            imagePicker,
            animated: true,
            select: { (asset) in
                print("*** Select")
        },
            deselect: { (asset) in
                print("*** Deselect")
        },
            cancel: { (assets) in
                print("*** Cancel")
        },
            finish: { (assets) in
                self.assets = []
                for i in 0..<assets.count { self.assets.append(assets[i]) }
                self.convertAssetToImage()
                
        }, completion: nil)
    }
    
    func convertAssetToImage() {
        images = []
        guard assets.count != 0 else { return }
        defer {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.isHidden = self.images.count == 0
            }
        }
        
        let size = CGSize(width: screenWidth, height: screenWidth)//PHImageManagerMaximumSize
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        for i in 0..<assets.count {
            manager.requestImage(for: assets[i],
                                 targetSize: size,
                                 contentMode: .aspectFit,
                                 options: options) { (image, info) in
                                    guard let image = image else { return }
                                    let data = image.jpegData(compressionQuality: 1.0)!
                                    let img = UIImage(data: data)!
                                    self.images.append(img)
            }
        }
    }
    
    func handleReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ProductRatingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count >= 5 { return 5 }
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesImageCVCell.identifier, for: indexPath) as! CategoriesImageCVCell
        cell.imgView.image = images.count != 0 ? images[indexPath.item] : nil
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProductRatingVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductRatingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = collectionView.frame.height-10
        return CGSize(width: cellSize, height: cellSize)
    }
}

//MARK: - CategoriesImageCVCellDelegate

extension ProductRatingVC: CategoriesImageCVCellDelegate {
    
    func handleDeleteDidTap(_ cell: CategoriesImageCVCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        images.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
    }
}

//MARK: - InternetViewDelegate

extension ProductRatingVC: InternetViewDelegate {
    
    func handleReload() {
        for vc in navigationController!.viewControllers {
            if vc.isKind(of: HomeVC.self) {
                if let vc = vc as? HomeVC {
                    if vc.isHomeVC {
                        handleBackToTabHome()
                        
                    } else {
                        return
                    }
                }
                
            } else if vc.isKind(of: WishlistVC.self) {
                if let vc = vc as? WishlistVC {
                    if vc.isWishlistVC {
                        handleBackToTabWishlish()
                        
                    } else {
                        return
                    }
                }
                
            } else if vc.isKind(of: ShopVC.self) {
                if let vc = vc as? ShopVC {
                    if vc.isShopVC {
                        handleBackToTabShop()
                        
                    } else {
                        return
                    }
                }
                
            } else if vc.isKind(of: CartVC.self) {
                if let vc = vc as? CartVC {
                    if vc.isCartVC {
                        handleBackToTabCart()
                        
                    } else {
                        return
                    }
                }
                
            } else if vc.isKind(of: MoreVC.self) {
                if let vc = vc as? MoreVC {
                    if vc.isMoreVC {
                        handleBackToTabMore()
                        
                    } else {
                        return
                    }
                }
            }
        }
    }
}

//MARK: - DarkMode

extension ProductRatingVC {
    
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
        let bgC: UIColor = isDarkMode ? .black : .white
        view.backgroundColor = bgC
        tableView.backgroundColor = bgC
        tableView.separatorColor = isDarkMode ? darkSeparatorColor : lightSeparatorColor
        collectionView.backgroundColor = bgC
        headerView.setupDarkModeView(isDarkMode)
        bottomView.setupDarkModeView(isDarkMode)
        internetView.setupDarkMode(isDarkMode)
        tableView.reloadData()
    }
}
