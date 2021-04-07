//
//  OrderHistoryTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol OrderHistoryTVCellDelegate: class {
    func handleReorder(cell: OrderHistoryTVCell)
    func handleDidSelect(_ cell: OrderHistoryTVCell)
}

class OrderHistoryTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "OrderHistoryTVCell"
    
    weak var delegate: OrderHistoryTVCellDelegate?
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let containerView = UIView()
    let topView = UIView()
    let bottomView = UIView()
    
    let topImgView = UIImageView()
    let topTitleLbl = UILabel()
    let createTimeLbl = UILabel()
    let totalLbl = UILabel()
    let reorderBtn = ShowMoreBtn()
    let dimsView = UIView()
    
    lazy var prCarts: [ProductCart] = []
    
    let txt = NSLocalizedString("REORDER", comment: "OrderHistoryTVCell.swift: REORDER")
    
    var history: History! {
        didSet {
            let orderPTxt = NSLocalizedString("Order Placed", comment: "OrderHistoryTVCell.swift: Order Placed")
            let deliveredTxt = NSLocalizedString("Delivered", comment: "OrderHistoryTVCell.swift: Delivered")
            topTitleLbl.text = history.delivered ? deliveredTxt : orderPTxt
            
            let totalTxt = NSLocalizedString("Total: ", comment: "OrderHistoryTVCell.swift: Total: ")
            totalLbl.text = totalTxt + history.shoppingCart.total.formattedWithCurrency
            
            let f = DateFormatter()
            f.dateFormat = "dd/MM"
            
            let date = dateFormatter().date(from: history.uid)!
            let createTimeTxt = NSLocalizedString("Ordered On ", comment: "OrderHistoryTVCell.swift: Ordered On ")
            createTimeLbl.text = createTimeTxt + f.string(from: date)
            
            prCarts = history.shoppingCart.productCarts.sorted(by: { $0.createdTime > $1.createdTime })
            collectionView.reloadData()
            
            let link = history.shoppingCart.productCarts.first!.imageLink
            Product.downloadImage(from: link) { (image) in
                DispatchQueue.main.async {
                    fadeImage(imgView: self.topImgView, toImg: image, effect: true)
                    return
                }
            }
        }
    }
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        collectionView.frame = CGRect(x: 0.0, y: 0.0,
                                 width: targetSize.width,
                                 height: CGFloat.greatestFiniteMagnitude)
        let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
        let value: CGFloat
        if appDl.iPhone5 {
            value = 170.0
            
        } else {
            value = 200.0
        }
        
        let size = CGSize(width: contentSize.width, height: contentSize.height + value)
        return size
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 0.8
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        layer.opacity = 1.0
        super.touchesCancelled(touches, with: event)
    }
}

//MARK: - Configures

extension OrderHistoryTVCell {
    
    func configureCell() {
        //TODO: - ContainerView
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TopView
        topView.backgroundColor = .clear
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 10.0
        containerView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ImageView
        topImgView.clipsToBounds = true
        topImgView.contentMode = .scaleAspectFill
        topImgView.image = UIImage(named: "watches")
        topView.addSubview(topImgView)
        topImgView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - DimsBGView
        dimsView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
        dimsView.clipsToBounds = true
        dimsView.layer.cornerRadius = 10.0
        topView.insertSubview(dimsView, aboveSubview: topImgView)
        dimsView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TitleLbl
        topTitleLbl.configureNameForCell(false, fontSize: 18.0, isTxt: "Order Placed", fontN: fontNamedBold)
        
        //TODO: - CreatedTime
        createTimeLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 15.0, isTxt: "", fontN: fontNamedBold)
        
        topView.insertSubview(topTitleLbl, aboveSubview: dimsView)
        topView.insertSubview(createTimeLbl, aboveSubview: dimsView)
        topTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        createTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - BottomView
        bottomView.backgroundColor = .white
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 10.0
        containerView.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - TotalLbl
        totalLbl.configureNameForCell(false, txtColor: .darkGray, fontSize: 17.0, isTxt: "", fontN: fontNamedBold)
        bottomView.addSubview(totalLbl)
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ReorderBtn
        let attributed = setupTitleAttri(txt, size: 17.0)
        reorderBtn.setAttributedTitle(attributed, for: .normal)
        reorderBtn.backgroundColor = .black
        reorderBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        reorderBtn.addTarget(self, action: #selector(reorderDidTap), for: .touchUpInside)
        reorderBtn.clipsToBounds = true
        reorderBtn.layer.cornerRadius = 5.0
        bottomView.addSubview(reorderBtn)
        reorderBtn.translatesAutoresizingMaskIntoConstraints = false
        reorderBtn.sizeToFit()
        
        //TODO: - CollectionView
        collectionView.configureCVAddSub(.white, ds: self, dl: self, view: containerView)
        collectionView.isScrollEnabled = false
        collectionView.register(OrderHistoryCVCell.self, forCellWithReuseIdentifier: OrderHistoryCVCell.identifier)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            
            topView.heightAnchor.constraint(equalToConstant: screenWidth*0.23),
            topView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            topImgView.topAnchor.constraint(equalTo: topView.topAnchor),
            topImgView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            topImgView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            topImgView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            dimsView.topAnchor.constraint(equalTo: topView.topAnchor),
            dimsView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            dimsView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            dimsView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            topTitleLbl.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            topTitleLbl.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -10.0),
            
            createTimeLbl.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -10.0),
            createTimeLbl.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -5.0),
            
            bottomView.heightAnchor.constraint(equalToConstant: screenWidth*0.15),
            bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            totalLbl.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            totalLbl.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10.0),
            
            reorderBtn.heightAnchor.constraint(equalToConstant: 40.0),
            reorderBtn.widthAnchor.constraint(equalToConstant: 110.0),
            reorderBtn.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            reorderBtn.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10.0),
            
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
        
        setupDarkMode()
    }
    
    @objc func reorderDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleReorder(cell: self)
        }
    }
}

//MARK: - UICollectionViewDataSource

extension OrderHistoryTVCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prCarts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderHistoryCVCell.identifier, for: indexPath) as! OrderHistoryCVCell
        cell.orderHistoryTVCell = self
        cell.prCart = prCarts[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension OrderHistoryTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        touchAnim(self, frValue: 0.8) {
            self.delegate?.handleDidSelect(self)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension OrderHistoryTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth-40.0, height: 90.0)
    }
}

//MARK: - DarkMode

extension OrderHistoryTVCell {
    
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
        let conC: UIColor = isDarkMode ? .white : .black
        containerView.layer.shadowColor = conC.cgColor
        containerView.backgroundColor = isDarkMode ? darkColor : .white
        dimsView.backgroundColor = UIColor(hex: 0x000000, alpha: isDarkMode ? 0.5 : 0.7)
        bottomView.backgroundColor = isDarkMode ? darkColor : .white
        totalLbl.textColor = isDarkMode ? .lightGray : .darkGray
        createTimeLbl.textColor = isDarkMode ? .white : .lightGray
        
        let reC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(txt, txtColor: reC, size: 17.0)
        reorderBtn.setAttributedTitle(attributed, for: .normal)
        reorderBtn.backgroundColor = isDarkMode ? .white : .black
        collectionView.backgroundColor = isDarkMode ? darkColor : .white
    }
}
