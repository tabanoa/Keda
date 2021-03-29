//
//  TagVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol TagVCDelegate: class {
    func fetchTags(_ tags: [String], vc: TagVC)
}

class TagVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout = RecentlyViewedLayout()
    
    private let naContainerV = UIView()
    private let tagTF = TagTextField()
    private let titleLbl = UILabel()
    private let saveBtn = ShowMoreBtn()
    private let backBtn = UIButton()
    
    private let saveTxt = NSLocalizedString("Save", comment: "TagVC.swift: Save")
    let tagTxt = NSLocalizedString("Add tags", comment: "TagVC.swift: Add tags")
    
    weak var delegate: TagVCDelegate?
    var heightConsCollV = NSLayoutConstraint()
    var kTags: [String] = []
    private var tags: [String] = []
    private var isPop = true
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupHeightConstraint()
    }
    
    func setupHeightConstraint() {
        UIView.animate(withDuration: 0.15) {
            let contentS = self.collectionView.collectionViewLayout.collectionViewContentSize
            let height = contentS.height
            if height >= 150.0 {
                self.heightConsCollV.constant = 150.0
                
            } else {
                self.heightConsCollV.constant = height
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func handleCollectionView() {
        UIView.animate(withDuration: 0.25) {
            self.collectionView.isHidden = !(self.kTags.count != 0)
        }
    }
}

//MARK: - Configures

extension TagVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO: - Title
        let txt = NSLocalizedString("Tags", comment: "TagVC.swift: Tags")
        titleLbl.configureTitleForNavi(naContainerV, isTxt: txt)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Save
        let attributed = setupTitleAttri(saveTxt, size: 17.0)
        saveBtn.setAttributedTitle(attributed, for: .normal)
        saveBtn.frame = CGRect(x: naContainerV.frame.width-35.0, y: 0.0, width: 50.0, height: 40.0)
        saveBtn.contentMode = .right
        saveBtn.addTarget(self, action: #selector(saveDidTap), for: .touchUpInside)
        saveBtn.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 10.0)
        naContainerV.addSubview(saveBtn)
    }
    
    @objc func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            if self.kTags.count == 0 {
                if self.tags.count != 0 {
                    self.delegate?.fetchTags(self.tags, vc: self)
                    
                } else {
                    handleInternet(self.tagTxt, imgName: "icon-error")
                    return
                }
                
            } else {
                if self.tags.count == 0 {
                    self.tags = self.kTags
                    self.delegate?.fetchTags(self.tags, vc: self)
                    
                } else {
                    self.kTags.forEach({
                        if !self.tags.contains($0) {
                            self.tags.append($0)
                            
                            handleHUD(0.75, traitCollection: self.traitCollection) {
                                guard self.isPop else { return }
                                self.delegate?.fetchTags(self.tags, vc: self)
                                self.isPop = false
                            }
                        }
                    })
                }
            }
        }
    }
    
    func updateUI() {
        //TODO: - CollectionView
        collectionView.configureCV(.white, ds: self, dl: self)
        collectionView.register(TagCVCell.self, forCellWithReuseIdentifier: TagCVCell.identifier)
        heightConsCollV = collectionView.heightAnchor.constraint(equalToConstant: 50.0)
        heightConsCollV.isActive = true
        
        collectionView.collectionViewLayout = layout
        layout.contentPadding = SpacingMode(horizontal: 5.0, vertical: 20.0)
        layout.contentAlign = .left
        layout.cellPadding = 5.0
        layout.delegate = self
        collectionView.isHidden = true
        
        //TODO: - TagTF
        tagTF.placeholder = tagTxt
        tagTF.delegate = self
        tagTF.translatesAutoresizingMaskIntoConstraints = false
        tagTF.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        //TODO: - StackView
        let views = [collectionView, tagTF]
        let sv = createdStackView(views, spacing: 10.0, axis: .vertical, distribution: .fill, alignment: .fill)
        view.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension TagVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCVCell.identifier, for: indexPath) as! TagCVCell
        cell.tagLbl.text = kTags[indexPath.item]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TagVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.bounds.size.width - 15)/2.0
        return CGSize(width: cellSize, height: cellSize)
    }
}

//MARK: - UITextFieldDelegate

extension TagVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if !tags.contains(text.lowercased()) {
                if tags.count <= 15 {
                    tags.append(text.lowercased())
                    createTagCloud(with: tags as [AnyObject])
                    setupDarkMode()
                }
            }
            
            textField.text = nil
            
        } else {
            textField.text = nil
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let range = Range(range, in: oldText) else { return false }
        let subString = oldText[range]
        let count = oldText.count - subString.count + string.count
        return count <= 63
    }
}

//MARK: - Functions

extension TagVC {
    
    func createTagCloud(with array: [AnyObject]) {
        for sub in view.subviews {
            if sub.tag != 0 {
                sub.removeFromSuperview()
            }
        }
        
        var x: CGFloat = 15.0
        var y: CGFloat
        if collectionView.isHidden == true {
            y = 65.0
            
        } else {
            y = 8.0 + collectionView.contentSize.height + 10.0 + 35.0 + 15.0
        }
        
        var tag: Int = 1
        
        for str in array {
            let str = str as! String
            let height: CGFloat = 29.0
            let width = estimatedText(str).width
            let checkWidth = x + width + 13.0 + 25.0
            if checkWidth > screenWidth-30 {
                x = 15.0
                y += height + 8.0
            }
            
            //TODO: - BGView
            let rectView = CGRect(x: x, y: y, width: width + 17.0 + 38.5, height: height)
            let bgView = UIView()
            bgView.frame = rectView
            bgView.backgroundColor = .black
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = height/2.0
            bgView.tag = tag
            
            //TODO: - Label
            let rectLbl = CGRect(x: 17.0, y: 0.0, width: width, height: height)
            let textLbl = UILabel()
            textLbl.frame = rectLbl
            textLbl.font = UIFont(name: fontNamed, size: 13.0)
            textLbl.textColor = .white
            textLbl.text = str.lowercased()
            bgView.addSubview(textLbl)
            
            //TODO: - Button
            let btnW: CGFloat = 23.0
            let btnX = bgView.frame.size.width - 2.5 - btnW
            let rectBtn = CGRect(x: btnX, y: 3.0, width: btnW, height: btnW)
            let removeBtn = UIButton(type: .custom)
            removeBtn.frame = rectBtn
            removeBtn.backgroundColor = .white
            removeBtn.clipsToBounds = true
            removeBtn.layer.cornerRadius = btnW/2.0
            removeBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
            removeBtn.tintColor = .black
            removeBtn.tag = tag
            removeBtn.addTarget(self, action: #selector(removeDidTap), for: .touchUpInside)
            removeBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            bgView.addSubview(removeBtn)
            x += width + 17.0 + 43.5
            view.addSubview(bgView)
            tag = tag + 1
            
            if #available(iOS 12.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified: setupTraitCollection(false, bgView, textLbl, removeBtn)
                case .dark: setupTraitCollection(true, bgView, textLbl, removeBtn)
                default: break
                }
            } else {
                setupTraitCollection(false, bgView, textLbl, removeBtn)
            }
        }
    }
    
    func setupTraitCollection(_ isDarkMode: Bool, _ bgView: UIView, _ textLbl: UILabel, _ removeBtn: UIButton) {
        bgView.backgroundColor = isDarkMode ? .white : .black
        textLbl.textColor = isDarkMode ? .black : .white
        removeBtn.backgroundColor = isDarkMode ? .black : .white
        removeBtn.tintColor = isDarkMode ? .white : .black
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func removeDidTap(_ sender: AnyObject) {
        tags.remove(at: sender.tag - 1)
        createTagCloud(with: tags as [AnyObject])
    }
}

//MARK: - TagCVCellDelegate

extension TagVC: TagCVCellDelegate {
    
    func handleRemove(cell: TagCVCell) {
        dismissKeyboard()
        
        let indexPath = collectionView.indexPath(for: cell)!
        kTags.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadData()
        setupHeightConstraint()
        handleCollectionView()
    }
}

//MARK: - RecentlyViewedLayoutDelegate

extension TagVC: RecentlyViewedLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath) -> CGSize {
        let estimated = estimatedText(kTags[indexPath.item], fontS: 14.0)
        let height = estimated.height + 20.0
        let width = estimated.width + 40.0
        return CGSize(width: width, height: height)
    }
}

//MARK: - DarkMode

extension TagVC {
    
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
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
}
