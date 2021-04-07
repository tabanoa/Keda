//
//  Types.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit
import MobileCoreServices
import Firebase
import MessageUI

public let screenWidth = UIScreen.main.bounds.size.width
public let screenHeight = UIScreen.main.bounds.size.height
//let naviHeight = navigationController!.navigationBar.frame.height
//let statusHeight = UIApplication.shared.statusBarFrame.height

public let fontNamed = "HelveticaNeue"
public let fontNamedBold = "HelveticaNeue-Bold"

public let fontLinhLight = "LinhAmorSans-Light"
public let fontLinhBold = "LinhAmorSans-Bold"

public let defaultColor = UIColor(hex: 0xeeae33)
public let groupColor = UIColor(hex: 0xEFEFF3)
public let darkColor = UIColor(hex: 0x1C1C1E)
public let lightSeparatorColor = UIColor(hex: 0xEFEFF4)
public let darkSeparatorColor = UIColor(hex: 0x373737)

let appDl = UIApplication.shared.delegate as! AppDelegate
var numbers: [Int] = Array(0...50)
let deviceUID = UIDevice.current.identifierForVendor!.uuidString

public let passwordKey = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP"
public let passwordIV = "gqLOHUioQ0QjhuvI"

public var colors: [UIColor] = [.white, .black, UIColor(hex: 0xee9ca7), UIColor(hex: 0x2980B9), UIColor(hex: 0xFF416C), UIColor(hex: 0x11998e), UIColor(hex: 0x4AC29A)]
public var sizes: [String] = ["M", "L", "XL", "S", "XS"]


public let reviewTxt = "text"
public let reviewIMG = "image"
public let reviewTxtAndIMG = "textAndimage"

public var categories: [String] = [
    NSLocalizedString("Hoodies", comment: "Types.swift: hoodies"),        //0
    NSLocalizedString("Belts", comment: "Types.swift: belts"),  //1
    NSLocalizedString("Shoes", comment: "Types.swift: shoes"),              //2
    NSLocalizedString("Watches", comment: "Types.swift: watches"),          //3
    NSLocalizedString("Bags", comment: "Types.swift: bags"),                //4
    NSLocalizedString("Jackets", comment: "Types.swift: jackets"),          //5
    NSLocalizedString("Shirts", comment: "Types.swift: shirts"),        //6
    NSLocalizedString("Shorts", comment: "Types.swift: shorts"),                  //7
    NSLocalizedString("Pants", comment: "Types.swift: pants"),                //8
    NSLocalizedString("Slides", comment: "Types.swift: slides"),            //9
    NSLocalizedString("Lounge", comment: "Types.swift: Sl/Users/laptop/Desktop/Fashi-Document/Keda/Keda/MyUtils/Types.swifteepwear"),      //10
    NSLocalizedString("Collectables", comment: "Types.swift: collectables")         //11
]

public var kCategories: [String] = [
    "hoodies",         //0
    "belts",      //1
    "shoes",            //2
    "watches",          //3
    "bags",             //4
    "jackets",          //5
    "shirts",         //6
    "shorts",              //7
    "pants",             //8
    "slides",           //9
    "lounge",        //10
    "collectables"          //11
]

//MARK: - Extimated Text

public func estimatedText(_ text: String, fontS: CGFloat = 13.0, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGRect {
    let height = CGFloat.greatestFiniteMagnitude
    let size = CGSize(width: width, height: height)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let attributes = setupAttri(fontNamedBold, size: fontS, txtColor: .black)
    return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
}

//Dollar
/*
public func calculatesaleOff(_ price: Double, saleOff: Double, completion: @escaping (Double) -> Void) {
    let saleOff = (100.0 - saleOff)/100.0
    let kPrice = round(100*(price * saleOff))/100
    completion(round(kPrice/1000)*1000)
}
*/

//MARK: - saleOff

public func calculatesaleOff(_ price: Double, saleOff: Double, completion: @escaping (Double) -> Void) {
    let saleOff = (100.0 - saleOff)/100.0
    let kPrice = round(100*(price * saleOff))/100
    completion(kPrice)
}

//MARK: - UIStackView

public func createdStackView(_ views: [UIView],
                           spacing: CGFloat,
                           axis: NSLayoutConstraint.Axis,
                           distribution: UIStackView.Distribution,
                           alignment: UIStackView.Alignment) -> UIStackView {
    let sv = UIStackView(arrangedSubviews: views)
    sv.spacing = spacing
    sv.axis = axis
    sv.distribution = distribution
    sv.alignment = alignment
    return sv
}

//MARK: - UIRectCorner

func setupCorners(_ view: UIView, corner: UIRectCorner, rect: CGRect, fColor: CGColor) {
    let shape = CAShapeLayer()
    shape.frame = rect
    shape.fillColor = fColor
    shape.lineWidth = 1.0
    shape.strokeColor = UIColor.clear.cgColor
    shape.path = UIBezierPath(roundedRect: rect,
                              byRoundingCorners: corner,
                              cornerRadii: CGSize(width: 2.0, height: 2.0)).cgPath
    view.layer.addSublayer(shape)
}

public func delay(duration: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
}

public func touchAnim(_ sender: UIView, frValue: CGFloat = 0.5, toValue: CGFloat = 1.0, completion: @escaping () -> Void) {
    let opacity = CABasicAnimation(keyPath: "opacity")
    let duration: TimeInterval = 0.15
    opacity.duration = duration
    opacity.fromValue = frValue
    opacity.toValue = toValue
    opacity.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    sender.layer.add(opacity, forKey: nil)
    delay(duration: duration) { completion() }
}

public func setupSelectedCell(selectC: UIColor, completion: @escaping (UIView) -> Void) {
    let selectedView = UIView(frame: .zero)
    selectedView.backgroundColor = selectC
    completion(selectedView)
}

public func handleText(_ number: Double, completion: @escaping (String) -> Void) {
    var text: String {
        if number >= 1000 && number < 999999 {
            return String(format: "%0.1f", locale: .current, number).replacingOccurrences(of: ".0", with: "")
        }
        
        if number > 999999 {
            return String(format: "%0.1f", locale: .current, number).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%0.0f", locale: .current, number)
    }
    
    completion(text)
}

public func createBadgeLabel(_ numberBadge: Int, completion: (CGFloat, CGFloat) -> Void) -> UILabel {
    let fontSize: CGFloat = 13.0
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: fontSize)
    label.textAlignment = .center
    label.backgroundColor = UIColor(hex: 0xF33D30)
    label.textColor = .white
    label.text = "\(numberBadge)"
    label.sizeToFit()
    
    var kHeight = label.frame.size.height
    kHeight += fontSize * 0.4
    let kWidth = (numberBadge <= 9) ? kHeight : label.frame.size.width + fontSize
    label.clipsToBounds = true
    label.layer.cornerRadius = kHeight/2.0
    label.isHidden = numberBadge == 0
    completion(kWidth, kHeight)
    return label
}

public func setupBagLbl(_ numberBadge: Int, label: UILabel) {
    let fontSize: CGFloat = 12.0
    label.font = UIFont(name: fontNamedBold, size: fontSize)
    label.textAlignment = .center
    label.backgroundColor = .clear
    label.textColor = .white
    label.text = "\(numberBadge)"
    label.sizeToFit()
}

public func isTakePhoto(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
    let image = kUTTypeImage as String
    
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
        return
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imgPC.sourceType = .camera
        
        if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
            if available.contains(image) {
                imgPC.mediaTypes = [image]
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imgPC.cameraDevice = .front
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imgPC.cameraDevice = .rear
            }
        }
        
    } else {
        return
    }
    
    imgPC.showsCameraControls = true
    imgPC.allowsEditing = edit
    imgPC.modalPresentationStyle = .custom
    vc.present(imgPC, animated: true, completion: nil)
}

public func isPhotoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
    let image = kUTTypeImage as String
    
    if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
        !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
        return
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        imgPC.sourceType = .photoLibrary
        
        if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            if available.contains(image) {
                imgPC.mediaTypes = [image]
            }
        }
        
    } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
        imgPC.sourceType = .savedPhotosAlbum
        
        if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
            if available.contains(image) {
                imgPC.mediaTypes = [image]
            }
        }
        
    } else {
        return
    }
    
    imgPC.allowsEditing = edit
    imgPC.modalPresentationStyle = .custom
    vc.present(imgPC, animated: true, completion: nil)
}

public func isVideoFromLibrary(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
    let movie = kUTTypeMovie as String
    
    if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ||
        !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
        return
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        imgPC.sourceType = .photoLibrary
        
        if let available = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            if available.contains(movie) {
                imgPC.mediaTypes = [movie]
            }
        }
        
    } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
        imgPC.sourceType = .savedPhotosAlbum
        
        if let available = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
            if available.contains(movie) {
                imgPC.mediaTypes = [movie]
            }
        }
        
    } else {
        return
    }
    
    imgPC.allowsEditing = edit
    imgPC.modalPresentationStyle = .custom
    vc.present(imgPC, animated: true, completion: nil)
}

public func isVideo(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
    let movie = kUTTypeMovie as String
    
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
        return
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imgPC.sourceType = .camera
        
        if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
            if available.contains(movie) {
                imgPC.mediaTypes = [movie]
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imgPC.cameraDevice = .front
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imgPC.cameraDevice = .rear
            }
        }
        
    } else {
        return
    }
    
    imgPC.showsCameraControls = true
    imgPC.allowsEditing = edit
    imgPC.modalPresentationStyle = .custom
    vc.present(imgPC, animated: true, completion: nil)
}

public func isCamera(_ vc: UIViewController, imgPC: UIImagePickerController, edit: Bool) {
    let image = kUTTypeImage as String
    let movie = kUTTypeMovie as String
    
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
        return
    }
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
        imgPC.sourceType = .camera
        
        if let available = UIImagePickerController.availableMediaTypes(for: .camera) {
            if available.contains(image) {
                imgPC.mediaTypes = [image, movie]
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imgPC.cameraDevice = .front
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imgPC.cameraDevice = .rear
            }
        }
        
    } else {
        return
    }
    
    imgPC.showsCameraControls = true
    imgPC.allowsEditing = edit
    imgPC.modalPresentationStyle = .custom
    vc.present(imgPC, animated: true, completion: nil)
}

public var kWindow: UIWindow? {
    guard let window = UIApplication.shared.keyWindow else { return nil }
    return window
}

func createdHUD() -> HUD {
    let hud = HUD.hud(kWindow!, effect: true)
    return hud
}

//MARK: - BorderView

public func setupAnimBorderView(_ view: UIView) {
    let posAnim = CABasicAnimation(keyPath: "position.x")
    posAnim.fromValue = view.center.x + 2.0
    posAnim.toValue = view.center.x - 2.0
    
    let borderAnim = CASpringAnimation(keyPath: "borderColor")
    borderAnim.damping = 5.0
    borderAnim.initialVelocity = 10.0
    borderAnim.toValue = UIColor(hex: 0xFF755F).cgColor
    
    let animGroup = CAAnimationGroup()
    animGroup.duration = 0.1
    animGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
    animGroup.autoreverses = true
    animGroup.animations = [posAnim, borderAnim]
    
    view.layer.add(animGroup, forKey: nil)
    view.layer.borderColor = UIColor(hex: 0xFF755F).cgColor
}

public func borderView(_ view: UIView, color: UIColor = .white) {
    view.layer.borderColor = color.cgColor
}

//MARK: - DateFormatter

public func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "ddMMyyyyHHmmss"
    return dateFormatter
}

public func dateFormatterShort() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyMMddHHmmss"
    return dateFormatter
}

//MARK: - Alert

public func handleErrorAlert(_ title: String, mes: String, act: String, vc: UIViewController, completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: mes, preferredStyle: .alert)
    let act = UIAlertAction(title: act, style: .default) { (_) in completion?() }
    
    alert.addAction(act)
    vc.present(alert, animated: true, completion: nil)
}

public func handleMessageAlert(vc: UIViewController,
                               txt: String = NSLocalizedString("Are you sure want to exit?", comment: "Types.swift: Title"),
                               traitCollection: UITraitCollection,
                               completion: @escaping () -> Void) {
    let alert = UIAlertController(title: txt, message: nil, preferredStyle: .alert)
    let yesAct = UIAlertAction(title: NSLocalizedString("Yes", comment: "Types.swift: Yes"), style: .default, handler: { _ in
        completion()
    })
    
    if #available(iOS 12.0, *) {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: appDl.window?.tintColor = .black
        case .dark: appDl.window?.tintColor = .white
        default: break
        }
    } else {
        appDl.window?.tintColor = .black
    }
    
    let noAct = UIAlertAction(title: NSLocalizedString("No", comment: "Types.swift: No"), style: .cancel, handler: nil)
    
    alert.addAction(yesAct)
    alert.addAction(noAct)
    vc.present(alert, animated: true, completion: nil)
}

public func handleBackToTabHome() {
    backToTabBar(0)
    appDl.isHomeVC = false
    appDl.isWishlistVC = false
    appDl.isShopVC = false
    appDl.isArrivalsDetailVC = false
    appDl.isFeaturedDetailVC = false
    appDl.isSellersDetailVC = false
    appDl.isProductRatingVC = false
}

public func handleBackToTabWishlish() {
    backToTabBar(1)
}

public func handleBackToTabShop() {
    backToTabBar(2)
}

public func handleBackToTabCart() {
    backToTabBar(3)
}

public func handleBackToTabPrList() {
    backToTabBar(3)
}

public func handleBackToTabMore() {
    backToTabBar(4)
}

public func backToTabBar(_ index: Int) {
    let window = (UIApplication.shared.delegate as! AppDelegate).window!
    let tabBar = TabBarController()
    tabBar.selectedIndex = index
    tabBar.tabBar.selectionIndicatorImage = UIImage()
    window.rootViewController = tabBar
    window.makeKeyAndVisible()
}

public func setupTitleAttri(_ title: String,
                            txtColor: UIColor = .white,
                            fontN: String = fontNamedBold,
                            size: CGFloat = 15.0) -> NSAttributedString {
    let attributes = setupAttri(fontN, size: size, txtColor: txtColor)
    let attributed = NSMutableAttributedString(string: title, attributes: attributes)
    return attributed
}

public func setupAttri(_ fontN: String, size: CGFloat, txtColor: UIColor) -> [NSAttributedString.Key : Any] {
    let attributes = [
        NSAttributedString.Key.font : UIFont(name: fontN, size: size)!,
        NSAttributedString.Key.foregroundColor : txtColor
    ]
    return attributes
}

//MARK: - Mail

public func configureMail(_ dl: MFMailComposeViewControllerDelegate, email: String, vc: UIViewController) {
    if MFMailComposeViewController.canSendMail() {
        let controller = MFMailComposeViewController()
        let txt = NSLocalizedString("Require A Supported!", comment: "Types.swift: Require A Supported")
        controller.setSubject(txt)
        controller.setToRecipients([email])
        controller.mailComposeDelegate = dl
        controller.modalPresentationStyle = .formSheet
        vc.present(controller, animated: true, completion: nil)
    }
}

func handleHUD(_ duration: TimeInterval = 1.5, traitCollection: UITraitCollection, completion: (() -> ())? = nil) {
    let hud = HUD.hud(kWindow!, effect: true)
    if #available(iOS 12.0, *) {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified: hud.backgroundColor = .white
        case .dark: hud.backgroundColor = .black
        default: break
        }
    } else {
        hud.backgroundColor = .white
    }
    
    delay(duration: duration) {
        UIView.animate(withDuration: 0.5, animations: {
            hud.alpha = 0.0
            
        }) { (_) in
            hud.removeFromSuperview()
            completion?()
        }
    }
}

func createTime() -> String {
    return dateFormatter().string(from: Date())
}

public func isLogIn() -> Bool {
    if Auth.auth().currentUser != nil {
        return true
        
    } else {
        return false
    }
}

public func presentWelcomeVC(_ vc: UIViewController, isPresent: Bool = false) {
    let welcomeVC = WelcomeVC()
    welcomeVC.isPresent = isPresent
    let navi = UINavigationController(rootViewController: welcomeVC)
    navi.modalPresentationStyle = .fullScreen
    vc.present(navi, animated: true, completion: nil)
}

public var currentUID: String! {
    return Auth.auth().currentUser!.uid
}

func getPath() {
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)
    print("*** CoreData: \(urls[0].path)")
}

//MARK: - DateFormatter

public func isDate(_ time: TimeInterval) -> NSString {
    let integer = NSInteger(time)
    let day = integer / (24*60*60)
    return NSString(format: "%0.1d", day)
}

public func isHour(_ time: TimeInterval) -> NSString {
    let integer = NSInteger(time)
    let hour = integer / (60*60)
    return NSString(format: "%0.1d", hour)
}

public func isMinute(_ time: TimeInterval) -> NSString {
    let integer = NSInteger(time)
    let minute = (integer/60) % 60
    return NSString(format: "%0.1d", minute)
}

public func isSecond(_ time: TimeInterval) -> NSString {
    let integer = NSInteger(time)
    let second = integer % 60
    return NSString(format: "%0.1d", second)
}

public func fadeImage(imgView: UIImageView, toImg: UIImage, effect: Bool) {
    UIView.transition(with: imgView,
                      duration: 0.5,
                      options: .transitionCrossDissolve,
                      animations: {
                        imgView.image = toImg
    },
                      completion: nil)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0.0,
                   options: .curveEaseOut,
                   animations: {
                    imgView.alpha = effect ? 1.0 : 0.0
    },
                   completion: nil)
}

func removeHUD(_ hud: HUD, duration: TimeInterval = 0.75, completion: (() -> Void)? = nil) {
    delay(duration: duration) {
        UIView.animate(withDuration: 0.5, animations: {
            hud.alpha = 0.0
        }) { (_) in
            hud.removeFromSuperview()
            completion?()
        }
    }
}

//MARK: - Online

public func setupOnlineFor(time: String, txt: String = NSLocalizedString("Online just now", comment: "Types.swift: Online just now"), completion: @escaping (String) -> ()) {
    var text: String
    
    let date = dateFormatter().date(from: time)!
    let timeInterval = NSDate().timeIntervalSince(date)
    let formatter = DateFormatter()
    
    if timeInterval <= 5 {
        text = txt
        
    } else if timeInterval > 5 && timeInterval < 60 {
        let seconds = isSecond(timeInterval)
        text = "\(seconds)" + NSLocalizedString(" seconds ago", comment: "Types.swift: seconds ago")
        
    } else if timeInterval >= 60 && timeInterval < (60*60) {
        let minutes = isMinute(timeInterval)
        text = "\(minutes)" + NSLocalizedString(" minutes ago", comment: "Types.swift: minutes ago")
        
    } else if timeInterval >= (60*60) && timeInterval < (24*60*60) {
        let hours = isHour(timeInterval)
        text = "\(hours)" + NSLocalizedString(" hours ago", comment: "Types.swift: hours ago")
        
    } else if timeInterval >= (24*60*60) && timeInterval <= (7*24*60*60) {
        let dates = isDate(timeInterval)
        text = "\(dates)" + NSLocalizedString(" days ago", comment: "Types.swift: days ago")
        
    } else {
        formatter.dateFormat = "dd/MM/yyyy"
        text = formatter.string(from: date)
    }
    
    completion(text)
}

public func createSearchBarController(_ sC: UISearchController,
                                      _ naviItem: UINavigationItem,
                                      resultU: UISearchResultsUpdating,
                                      vc: UIViewController,
                                      sbDl: UISearchBarDelegate) {
    let cancelTxt = NSLocalizedString("Cancel", comment: "Types.swift: Cancel")
    let searchBar = sC.searchBar
    naviItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    vc.definesPresentationContext = true
    sC.searchResultsUpdater = resultU
    sC.dimsBackgroundDuringPresentation = false
    sC.hidesNavigationBarDuringPresentation = false
    searchBar.searchBarStyle = .prominent
    searchBar.customFontSearchBar()
    searchBar.setValue(cancelTxt, forKey: "cancelButtonText")
    searchBar.returnKeyType = .search
    searchBar.delegate = sbDl
}
