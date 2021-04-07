//
//  ShowIMGViewVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ShowIMGViewVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollCenterLayout = ScrollCenterLayout()

    let containerView = UIView()
    let avatarIMGView = UIImageView()
    let nameLbl = UILabel()
    let descriptionTV = UITextView()
    let createdTimeLbl = UILabel()
    let ratingLargeSV = RatingSmallSV()
    let prefixLbl = UILabel()
    
    var indexPath: IndexPath!
    lazy var imageLinks: [String] = []
    var review: Review!
    var prRating: Rating?
    
    var dismissVCTrans: DismissVCTransition!
    
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
        setupContentView()
        
        dismissVCTrans.initializePanGesture(self, selector: #selector(handlePanDismiss))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        User.fetchUserFromUID(uid: review.userUID) { (user) in
            self.nameLbl.text = user.fullName
            
            user.fullName.fetchFirstLastName { (fn, ln) in
                self.prefixLbl.text = "\(fn.prefix(1) + ln.prefix(1))".uppercased()
            }
            
            guard let link = user.avatarLink else {
                self.prefixLbl.isHidden = false
                self.avatarIMGView.backgroundColor = UIColor(hex: 0xDEDEDE)
                self.avatarIMGView.image = nil
                return
            }
            
            user.downloadAvatar(link: link) { (image) in
                DispatchQueue.main.async {
                    self.prefixLbl.isHidden = true
                    self.avatarIMGView.image = image
                }
            }
            
            if let prRating = self.prRating {
                self.ratingLargeSV.rating = prRating.containerUserUID(user.uid)
            }
        }
        
        descriptionTV.isHidden = review.description == nil
        descriptionTV.text = review.description
        
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter().date(from: review.createdTime)!
        createdTimeLbl.text = f.string(from: date)
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: self.indexPath, at: .right, animated: false)
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

extension ShowIMGViewVC {
    
    func updateUI() {
        view.backgroundColor = .black
        
        //TODO: - UICollectionView
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
        
        //TODO: - ContainerView
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelBtn.widthAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.heightAnchor.constraint(equalToConstant: 40.0),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            cancelBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: cancelBtn.bottomAnchor, constant: 20.0),
            collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            
            containerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10.0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupContentView() {
        //TODO: - Avatar ImageView
        let imgW: CGFloat = 50.0
        avatarIMGView.clipsToBounds = true
        avatarIMGView.layer.cornerRadius = imgW/2
        avatarIMGView.layer.borderColor = UIColor.gray.cgColor
        avatarIMGView.layer.borderWidth = 1.0
        avatarIMGView.contentMode = .scaleAspectFit
        avatarIMGView.image = nil
        avatarIMGView.translatesAutoresizingMaskIntoConstraints = false
        avatarIMGView.widthAnchor.constraint(equalToConstant: imgW).isActive = true
        avatarIMGView.heightAnchor.constraint(equalToConstant: imgW).isActive = true
        
        //TODO: - Name
        nameLbl.configureNameForCell(false, txtColor: .white, fontSize: 14.0, isTxt: "Keda Team")
        createdTimeLbl.configureNameForCell(false, txtColor: .white, fontSize: 12.0, isTxt: "3 ngày trước", fontN: fontNamed)
        
        descriptionTV.font = UIFont(name: fontNamed, size: 13.0)
        descriptionTV.textColor = .white
        descriptionTV.backgroundColor = .clear
        descriptionTV.text = "Save energy & headaches, by not having to deal with hiring, prototyping, designing, development, testing, bug-fixing, optimizing, etc. Take a look at the list of features to get an idea of the amount of effort you’ll need to invest by starting from scratch. Save energy & headaches, by not having to deal with hiring, prototyping, designing, development, testing, bug-fixing, optimizing, etc. Take a look at the list of features to get an idea of the amount of effort you’ll need to invest by starting from scratch."
        descriptionTV.showsHorizontalScrollIndicator = false
        descriptionTV.showsVerticalScrollIndicator = false
        descriptionTV.isEditable = false
        containerView.addSubview(descriptionTV)
        descriptionTV.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Ratings
        let height: CGFloat = ratingLargeSV.height
        ratingLargeSV.rating = 5
        containerView.addSubview(ratingLargeSV)
        ratingLargeSV.translatesAutoresizingMaskIntoConstraints = false
        
        let views1: [UIView] = [nameLbl, createdTimeLbl]
        let sv1 = createdStackView(views1, spacing: 5.0, axis: .vertical, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [avatarIMGView, sv1]
        let sv2 = createdStackView(views2, spacing: 10.0, axis: .horizontal, distribution: .fillProportionally, alignment: .center)
        containerView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv2.widthAnchor.constraint(equalToConstant: screenWidth-100),
            sv2.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10.0),
            sv2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            sv2.heightAnchor.constraint(equalToConstant: 50.0),
            
            ratingLargeSV.widthAnchor.constraint(equalToConstant: height*5),
            ratingLargeSV.heightAnchor.constraint(equalToConstant: height),
            ratingLargeSV.topAnchor.constraint(equalTo: sv2.topAnchor),
            ratingLargeSV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            
            descriptionTV.topAnchor.constraint(equalTo: sv2.bottomAnchor, constant: 5.0),
            descriptionTV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0),
            descriptionTV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10.0),
            descriptionTV.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0),
        ])
        
        //TODO: - PrefixLbl
        let prefix = "\(nameLbl.text!.prefix(1))"
        prefixLbl.configureNameForCell(true, txtColor: .white, fontSize: 17.0, isTxt: prefix)
        containerView.insertSubview(prefixLbl, aboveSubview: avatarIMGView)
        prefixLbl.translatesAutoresizingMaskIntoConstraints = false
        prefixLbl.centerXAnchor.constraint(equalTo: avatarIMGView.centerXAnchor).isActive = true
        prefixLbl.centerYAnchor.constraint(equalTo: avatarIMGView.centerYAnchor).isActive = true
        
        if avatarIMGView.image == nil {
            avatarIMGView.backgroundColor = UIColor(hex: 0xCCCCCC)
            prefixLbl.isHidden = false
        }
    }
    
    @objc func cancelDidTap(_ sender: UIButton) {
        touchAnim(sender) { self.handleDismissVC() }
    }
}

//MARK: - UICollectionViewDataSource

extension ShowIMGViewVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowIMGViewCVCell.identifier, for: indexPath) as! ShowIMGViewCVCell
        guard imageLinks.count != 0 else { return cell }
        cell.link = imageLinks[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ShowIMGViewVC: UICollectionViewDelegate {}

//MARK: - UICollectionViewDelegateFlowLayout

extension ShowIMGViewVC: UICollectionViewDelegateFlowLayout {
    
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

extension ShowIMGViewVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -80.0 {
            self.handleDismissVC()
            
        } else if scrollView.contentOffset.x > screenWidth*CGFloat(imageLinks.count-1) + 80 {
            self.handleDismissVC()
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

extension ShowIMGViewVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissVCTrans
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissVCTrans.hasStated ? dismissVCTrans : nil
    }
}
