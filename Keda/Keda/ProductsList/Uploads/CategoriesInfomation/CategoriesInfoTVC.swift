//
//  CategoriesInfoTVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import BSImagePicker
import Photos

protocol CategoriesInfoTVCDelegate: class {
    func fetchPrInfo(_ prInfo: ProductInfoModel, vc: CategoriesInfoTVC, cell: CategoriesColorSizeTVCell, tags: [String])
}

protocol CategoriesInfoTVCKDelegate: class {
    func fetchColorSizeFromPr(indexPath: IndexPath, vc: CategoriesInfoTVC)
}

class CategoriesInfoTVC: UITableViewController {
    
    //MARK: - Properties
    private let naContainerV = UIView()
    private var hud = HUD()
    
    private let titleLbl = UILabel()
    private let backBtn = UIButton()
    private let saveBtn = ShowMoreBtn()
    private let copyBtn = ShowMoreBtn()
    private let pasteBtn = ShowMoreBtn()
    
    private let saveTxt = NSLocalizedString("Save", comment: "CategoriesInfoTVC.swift: Save")
    let delTxt = NSLocalizedString("Are you sure want to delete?", comment: "CategoriesInfoTVC.swift: Are you sure want to delete?")
    
    weak var delegate: CategoriesInfoTVCDelegate?
    weak var kDelegate: CategoriesInfoTVCKDelegate?
    var indexPath = IndexPath()
    
    var imagePickerHelper: ImagePickerHelper?
    static var copy: Copies?
    
    var kColor: String = ""
    var kSize: String = ""
    var isEdit = false
    
    var kImageLinks: [String] = []
    var kImages: [UIImage] = []
    var kName = ""
    var kPrice: Double = 0.0
    var kDescription = ""
    var kSaleOff: Double = 0.0
    var kTags: [String] = []
    
    var category: String = ""
    var prUID: String = ""
    var type: String = ""
    var createdTime: String = ""
    var active: Bool = false
    
    private let imagePicker = BSImagePickerViewController()
    private var assets: [PHAsset] = []
    
    var cell: CategoriesColorSizeTVCell!
    private lazy var saleOffUID: [String] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        updateUI()
        setupDarkMode()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shared = NotificationFor.sharedInstance
        shared.fetchNotificationFrom(child: shared.saleOff) { (saleOffUID) in
            self.saleOffUID = saleOffUID
        }
    }
}

//MARK: - Configures

extension CategoriesInfoTVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO: - Title
        titleLbl.configureTitleForNavi(naContainerV, isTxt: category)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Save
        let attriSave = setupTitleAttri(saveTxt, size: 17.0)
        saveBtn.setAttributedTitle(attriSave, for: .normal)
        saveBtn.frame = CGRect(x: naContainerV.frame.width-35.0, y: 0.0, width: 50.0, height: 40.0)
        saveBtn.contentMode = .right
        saveBtn.addTarget(self, action: #selector(saveDidTap), for: .touchUpInside)
        saveBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 10.0)
        naContainerV.addSubview(saveBtn)
        
        guard !isEdit else { return }
        
        //TODO: - Copy
        copyBtn.frame = CGRect(x: saveBtn.frame.origin.x-35, y: 3.0, width: 30.0, height: 30.0)
        copyBtn.setImage(UIImage(named: "icon-copy")?.withRenderingMode(.alwaysTemplate), for: .normal)
        copyBtn.tintColor = .white
        copyBtn.addTarget(self, action: #selector(copyDidTap), for: .touchUpInside)
        copyBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        naContainerV.addSubview(copyBtn)
        
        //TODO: - Paste
        pasteBtn.frame = CGRect(x: copyBtn.frame.origin.x-35, y: 3.0, width: 30.0, height: 30.0)
        pasteBtn.setImage(UIImage(named: "icon-paste")?.withRenderingMode(.alwaysTemplate), for: .normal)
        pasteBtn.tintColor = .white
        pasteBtn.addTarget(self, action: #selector(pasteDidTap), for: .touchUpInside)
        pasteBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
        naContainerV.addSubview(pasteBtn)
    }
    
    @objc func backDidTap() {
        guard !isEdit else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard self.kImages.count != 0 ||
            self.kName != "" ||
            self.kPrice != 0.0 ||
            self.kDescription != "" ||
            self.kSaleOff != 0.0 ||
            self.kTags.count != 0 else {
                navigationController?.popViewController(animated: true)
                return
        }
        
        handleMessageAlert(vc: self, traitCollection: traitCollection) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func saveDidTap(_ sender: UIButton) {
        view.endEditing(true)
        
        touchAnim(sender) {
            guard !self.isEdit else {
                let hud = createdHUD()
                
                if self.kSaleOff != 0 {
                    guard self.active else { return }
                    
                    let title = self.kName
                    let saleOffTxt = NSLocalizedString("SALEOFF ", comment: "CategoriesInfoTVC.swift: SALEOFF ")
                    let body = saleOffTxt + "-\(self.kSaleOff)%"
                    pushNotificationForInfo(keyName: notifKeySaleOff, title: title, body: body)
                    
                    let modelFB = NotificationModel(title: title, body: body, prUID: self.prUID, type: saleOffKey, colorKey: self.kColor, sizeKey: self.kSize)
                    let notif = NotificationFB(model: modelFB)
                    notif.saveNotification {
                        self.saleOffUID.forEach({
                            let modelU = NotificationUserModel(notifUID: notif.uid, value: 1)
                            let notifU = NotificationUser()
                            notifU.saveNotificationUser(userUID: $0, modelU)
                        })
                    }
                }
                
                Product.editProduct(prUID: self.prUID,
                                    color: self.kColor,
                                    size: self.kSize,
                                    name: self.kName,
                                    price: self.kPrice,
                                    saleOff: self.kSaleOff,
                                    description: self.kDescription,
                                    images: self.kImages,
                                    imageLinks: self.kImageLinks) {
                                        delay(duration: 2.0) {
                                            self.handlePopToVC {
                                                hud.removeFromSuperview()
                                            }
                                        }
                }
                
                return
            }
            
            guard self.kColor != "",
                self.kSize != "",
                self.kImages.count != 0,
                self.kName != "",
                self.kPrice != 0.0,
                self.kDescription != "",
                self.kTags.count != 0 else {
                    let txt = NSLocalizedString("Missing data", comment: "CategoriesInfoTVC.swift: Missing data")
                    handleInternet(txt, imgName: "icon-error")
                    return
            }
            
            let prInfo = ProductInfoModel(name: self.kName, price: self.kPrice, saleOff: self.kSaleOff, imageLinks: [], description: self.kDescription, images: self.kImages)
            self.delegate?.fetchPrInfo(prInfo, vc: self, cell: self.cell, tags: self.kTags)
        }
    }
    
    func handlePopToVC(completion: @escaping () -> Void) {
        guard let navi = navigationController else { return }
        for vc in navi.viewControllers {
            if vc.isKind(of: ProductsListVC.self) {
                self.navigationController?.popToViewController(vc, animated: true)
                completion()
            }
        }
    }
    
    @objc func copyDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            CategoriesInfoTVC.copy = Copies(images: [],
                                            name: self.kName,
                                            price: self.kPrice,
                                            description: self.kDescription,
                                            saleOff: self.kSaleOff,
                                            tags: self.kTags)
            if CategoriesInfoTVC.copy != nil {
                let txt = NSLocalizedString("Copy", comment: "CategoriesInfoTVC.swift: Copy")
                handleInternet(txt, imgName: "icon-checkmark")
            }
        }
    }
    
    @objc func pasteDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            guard let copy = CategoriesInfoTVC.copy else { return }
            self.kName = copy.name
            self.kPrice = copy.price
            self.kDescription = copy.description
            self.kSaleOff = copy.saleOff
            self.kTags = copy.tags
            self.tableView.reloadData()
            self.handleReloadCollectionView()
        }
    }
    
    func handleReloadCollectionView() {
        let indexPath = IndexPath(item: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? CategoriesImageTVCell {
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
            }
        }
    }
    
    func updateUI() {
        imagePicker.maxNumberOfSelections = 7
        
        tableView.backgroundColor = groupColor
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.separatorStyle = .none
        tableView.register(CategoriesLoadIMGTVCell.self, forCellReuseIdentifier: CategoriesLoadIMGTVCell.identifier)
        tableView.register(CategoriesImageTVCell.self, forCellReuseIdentifier: CategoriesImageTVCell.identifier)
        tableView.register(CategoriesNameTVCell.self, forCellReuseIdentifier: CategoriesNameTVCell.identifier)
        tableView.register(CategoriesPriceTVCell.self, forCellReuseIdentifier: CategoriesPriceTVCell.identifier)
        tableView.register(CategoriesDescriptionTVCell.self, forCellReuseIdentifier: CategoriesDescriptionTVCell.identifier)
        tableView.register(CategoriesSaleOffTVCell.self, forCellReuseIdentifier: CategoriesSaleOffTVCell.identifier)
        tableView.register(CategoriesTagTVCell.self, forCellReuseIdentifier: CategoriesTagTVCell.identifier)
        tableView.register(CategoriesDelTVCell.self, forCellReuseIdentifier: CategoriesDelTVCell.identifier)
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension CategoriesInfoTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard !isEdit else { return 8 }
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if isEdit {
            switch section {
            case 0: return setupImageCell(tableView, indexPath)
            case 1: return setupLoadImageCell(tableView, indexPath)
            case 2: return setupNameCell(tableView, indexPath)
            case 3: return setupPriceCell(tableView, indexPath)
            case 4: return setupDesCell(tableView, indexPath)
            case 5: return setupSaleOffCell(tableView, indexPath)
            case 6: return setupTagCell(tableView, indexPath)
            default: return setupDeleteCell(tableView, indexPath)
            }
            
        } else {
            switch section {
            case 0: return setupImageCell(tableView, indexPath)
            case 1: return setupNameCell(tableView, indexPath)
            case 2: return setupPriceCell(tableView, indexPath)
            case 3: return setupDesCell(tableView, indexPath)
            case 4: return setupSaleOffCell(tableView, indexPath)
            default: return setupTagCell(tableView, indexPath)
            }
        }
    }
    
    private func setupLoadImageCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesLoadIMGTVCell.identifier, for: indexPath) as! CategoriesLoadIMGTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.imageLinks = kImageLinks
        return cell
    }
    
    private func setupDeleteCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesDelTVCell.identifier, for: indexPath) as! CategoriesDelTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    private func setupImageCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesImageTVCell.identifier, for: indexPath) as! CategoriesImageTVCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.images = kImages
        return cell
    }
    
    private func setupNameCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesNameTVCell.identifier, for: indexPath) as! CategoriesNameTVCell
        cell.selectionStyle = .none
        cell.nameLbl.text = kName
        return cell
    }
    
    private func setupPriceCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesPriceTVCell.identifier, for: indexPath) as! CategoriesPriceTVCell
        cell.selectionStyle = .none
        cell.priceTF.text = kPrice != 0 ? "\(kPrice)" : ""
        cell.delegate = self
        return cell
    }
    
    private func setupDesCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesDescriptionTVCell.identifier, for: indexPath) as! CategoriesDescriptionTVCell
        cell.selectionStyle = .none
        cell.descriptionLbl.text = kDescription
        return cell
    }
    
    private func setupSaleOffCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesSaleOffTVCell.identifier, for: indexPath) as! CategoriesSaleOffTVCell
        cell.saleOffTF.text = kSaleOff != 0 ? "\(kSaleOff)" : ""
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    private func setupTagCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesTagTVCell.identifier, for: indexPath) as! CategoriesTagTVCell
        cell.selectionStyle = .none
        cell.tagLbl.text = kTags.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CategoriesInfoTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEdit {
            switch indexPath.section {
            case 2: createNameForCell(tableView, indexPath)
            case 3: createPriceForCell(tableView, indexPath)
            case 4: createDesForCell(tableView, indexPath)
            case 5: createSaleOffForCell(tableView, indexPath)
            case 6: createTagsForCell(tableView, indexPath)
            default: break
            }
            
        } else {
            switch indexPath.section {
            case 1: createNameForCell(tableView, indexPath)
            case 2: createPriceForCell(tableView, indexPath)
            case 3: createDesForCell(tableView, indexPath)
            case 4: createSaleOffForCell(tableView, indexPath)
            case 5: createTagsForCell(tableView, indexPath)
            default: break
            }
        }
    }
    
    private func createNameForCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesNameTVCell else { return }
        touchAnim(cell, frValue: 0.8) {
            let txt = NSLocalizedString("Name", comment: "CategoriesInfoTVC.swift: Name")
            let textVC = TextVC()
            textVC.nameDelegate = self
            textVC.kTitle = txt
            textVC.kPlaceholder = txt
            textVC.nameCell = cell
            textVC.kText = self.kName
            textVC.isName = true
            self.navigationController?.pushViewController(textVC, animated: true)
        }
    }
    
    private func createPriceForCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesPriceTVCell else { return }
        cell.priceTF.becomeFirstResponder()
    }
    
    private func createDesForCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesDescriptionTVCell else { return }
        touchAnim(cell, frValue: 0.8) {
            let txt = NSLocalizedString("Description", comment: "CategoriesInfoTVC.swift: Description")
            let textVC = TextVC()
            textVC.descriptionDelegate = self
            textVC.kTitle = txt
            textVC.kPlaceholder = txt
            textVC.desCell = cell
            textVC.kText = self.kDescription
            textVC.isName = false
            self.navigationController?.pushViewController(textVC, animated: true)
        }
    }
    
    private func createSaleOffForCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesSaleOffTVCell else { return }
        cell.saleOffTF.becomeFirstResponder()
    }
    
    private func createTagsForCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoriesTagTVCell else { return }
        touchAnim(cell, frValue: 0.8) {
            let tagVC = TagVC()
            tagVC.delegate = self
            tagVC.kTags = self.kTags
            self.navigationController?.pushViewController(tagVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !isEdit else {
            if section == 7 { return CGFloat.leastNonzeroMagnitude }
            return 40.0
        }
        
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEdit {
            switch indexPath.section {
            case 0, 1: return 70.0
            case 2, 4: return tableView.rowHeight
            case 7: return 50.0
            default: return tableView.estimatedRowHeight
            }
            
        } else {
            switch indexPath.section {
            case 0: return 70.0
            case 1, 3: return tableView.rowHeight
            default: return tableView.estimatedRowHeight
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView().configureHeaderView(view, tableView: tableView)
        
        if isEdit {
            switch section {
            case 0: createAddImageHeader(kView)
            case 1: createImageHeader(kView)
            case 2: createNameHeader(kView)
            case 3: createPriceHeader(kView)
            case 4: createDesHeader(kView)
            case 5: createSaleOffHeader(kView)
            case 6: createTagsHeader(kView)
            default: break
            }
            
        } else {
            switch section {
            case 0: createAddImageHeader(kView)
            case 1: createNameHeader(kView)
            case 2: createPriceHeader(kView)
            case 3: createDesHeader(kView)
            case 4: createSaleOffHeader(kView)
            default: createTagsHeader(kView)
            }
        }
        
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: kView.backgroundColor = groupColor
            case .dark: kView.backgroundColor = .black
            default: break
            }
        } else {
            kView.backgroundColor = groupColor
        }
        
        return kView
    }
    
    private func createAddImageHeader(_ kView: UIView) {
        let txt = NSLocalizedString("ADD IMAGES", comment: "CategoriesInfoTVC.swift: ADD IMAGES")
        let imgLbl = UILabel()
        imgLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        imgLbl.configureHeaderTitle(kView)
    }
    
    private func createImageHeader(_ kView: UIView) {
        let txt = NSLocalizedString("IMAGE", comment: "CategoriesInfoTVC.swift: IMAGE")
        let imgLbl = UILabel()
        imgLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        imgLbl.configureHeaderTitle(kView)
    }
    
    private func createNameHeader(_ kView: UIView) {
        let txt = NSLocalizedString("NAME", comment: "CategoriesInfoTVC.swift: NAME")
        let nameLbl = UILabel()
        nameLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        nameLbl.configureHeaderTitle(kView)
    }
    
    private func createPriceHeader(_ kView: UIView) {
        let txt = NSLocalizedString("PRICE", comment: "CategoriesInfoTVC.swift: PRICE")
        let priceLbl = UILabel()
        priceLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        priceLbl.configureHeaderTitle(kView)
    }
    
    private func createDesHeader(_ kView: UIView) {
        let txt = NSLocalizedString("DESCRIPTION", comment: "CategoriesInfoTVC.swift: DESCRIPTION")
        let descriptionLbl = UILabel()
        descriptionLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        descriptionLbl.configureHeaderTitle(kView)
    }
    
    private func createSaleOffHeader(_ kView: UIView) {
        let txt = NSLocalizedString("SALEOFF", comment: "CategoriesInfoTVC.swift: SALEOFF")
        let saleOffLbl = UILabel()
        saleOffLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        saleOffLbl.configureHeaderTitle(kView)
    }
    
    private func createTagsHeader(_ kView: UIView) {
        let txt = NSLocalizedString("TAG", comment: "CategoriesInfoTVC.swift: TAG")
        let tagLbl = UILabel()
        tagLbl.configureNameForCell(false, txtColor: .lightGray, fontSize: 14.0, isTxt: txt)
        tagLbl.configureHeaderTitle(kView)
    }
}

//MARK: - CategoriesLoadIMGTVCellDelegate

extension CategoriesInfoTVC: CategoriesLoadIMGTVCellDelegate {
    
    func handleDeleteDidTap(_ cvCell: CategoriesLoadIMGCVCell, _ tvCell: CategoriesLoadIMGTVCell) {
        guard self.kImageLinks.count > 1 else { return }
        
        handleMessageAlert(vc: self, txt: delTxt, traitCollection: traitCollection) {
            guard let indexPath = tvCell.collectionView.indexPath(for: cvCell) else { return }
            
            self.kImageLinks.remove(at: indexPath.item)
            tvCell.collectionView.deleteItems(at: [indexPath])
            tvCell.collectionView.reloadData()
            self.tableView.reloadData()
        }
    }
}

//MARK: - CategoriesDelTVCellDelegate

extension CategoriesInfoTVC: CategoriesDelTVCellDelegate {
    
    func handleDelete() {
        handleMessageAlert(vc: self, txt: delTxt, traitCollection: traitCollection) {
            self.kDelegate?.fetchColorSizeFromPr(indexPath: self.indexPath, vc: self)
        }
    }
}

//MARK: - CategoriesImageTVCellDelegate

extension CategoriesInfoTVC: CategoriesImageTVCellDelegate {
    
    func editImage(_ cell: CategoriesImageTVCell, index: Int) {
        imagePickerHelper = ImagePickerHelper(vc: self, completion: { (image) in
            self.kImages[index] = image!
            cell.images[index] = image!
            cell.collectionView.reloadData()
        })
    }
    
    func addImage(_ cell: CategoriesImageTVCell) {
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
                self.convertAssetToImage(cell)
                
        }, completion: nil)
    }
    
    func handleDeleteDidTap(_ cvCell: CategoriesImageCVCell, _ tvCell: CategoriesImageTVCell) {
        guard let indexPath = tvCell.collectionView.indexPath(for: cvCell) else { return }
        kImages.remove(at: indexPath.item)
        tvCell.collectionView.deleteItems(at: [indexPath])
        tvCell.collectionView.reloadData()
        tableView.reloadData()
    }
    
    func convertAssetToImage(_ cell: CategoriesImageTVCell) {
        kImages = []
        guard assets.count != 0 else { return }
        defer {
            DispatchQueue.main.async {
                cell.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
        
        let size = CGSize(width: screenWidth, height: screenWidth)
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        for i in 0..<assets.count {
            manager.requestImage(for: assets[i],
                                 targetSize: size,
                                 contentMode: .aspectFill,
                                 options: options) { (image, info) in
                                    guard let image = image else { return }
                                    let data = image.jpegData(compressionQuality: 1.0)!
                                    let img = UIImage(data: data)!
                                    self.kImages.append(img)
            }
        }
    }
}

//MARK: - CategoriesPriceTVCellDelegate

extension CategoriesInfoTVC: CategoriesPriceTVCellDelegate {
    
    func fetchPrice(_ txt: String) {
        kPrice = txt.removeFormatAmountDouble()
    }
}

//MARK: - CategoriesSaleOffTVCellDelegate

extension CategoriesInfoTVC: CategoriesSaleOffTVCellDelegate {
    
    func fetchSaleOff(_ txt: String) {
        kSaleOff = txt.removeFormatAmountDouble()
    }
}

//MARK: - TextVCNameDelegate

extension CategoriesInfoTVC: TextVCNameDelegate {
    
    func fetchText(_ txt: String, vc: TextVC, cell: CategoriesNameTVCell) {
        kName = txt
        vc.navigationController?.popViewController(animated: true)
        
        let height = estimatedText(kName, fontS: 17.0).height + 20
        cell.heightConsName.priority = kName != "" ? .defaultLow : .defaultHigh
        cell.heightConsName.priority = height > 44 ? .defaultLow : .defaultHigh
        cell.heightConsName.constant = height > 44 ? height : 39
        tableView.reloadData()
    }
}

//MARK: - TextVCDescriptionDelegate

extension CategoriesInfoTVC: TextVCDescriptionDelegate {
    
    func fetchText(_ txt: String, vc: TextVC, cell: CategoriesDescriptionTVCell) {
        kDescription = txt
        vc.navigationController?.popViewController(animated: true)
        
        let height = estimatedText(kDescription, fontS: 17.0).height + 20
        cell.heightConsDes.priority = kDescription != "" ? .defaultLow : .defaultHigh
        cell.heightConsDes.priority = height > 44 ? .defaultLow : .defaultHigh
        cell.heightConsDes.constant = height > 44 ? height : 39
        tableView.reloadData()
    }
}

//MARK: - TagVCDelegate

extension CategoriesInfoTVC: TagVCDelegate {
    
    func fetchTags(_ tags: [String], vc: TagVC) {
        self.kTags = tags
        vc.navigationController?.popViewController(animated: true)
        tableView.reloadData()
    }
}

//MARK: - DarkMode

extension CategoriesInfoTVC {
    
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
        tableView.backgroundColor = isDarkMode ? .black : groupColor
        tableView.reloadData()
    }
}
