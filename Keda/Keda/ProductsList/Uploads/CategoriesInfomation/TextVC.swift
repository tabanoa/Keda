//
//  TextVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol TextVCNameDelegate: class {
    func fetchText(_ txt: String, vc: TextVC, cell: CategoriesNameTVCell)
}

protocol TextVCDescriptionDelegate: class {
    func fetchText(_ txt: String, vc: TextVC, cell: CategoriesDescriptionTVCell)
}

class TextVC: UIViewController {
    
    //MARK: - Properties
    weak var nameDelegate: TextVCNameDelegate?
    weak var descriptionDelegate: TextVCDescriptionDelegate?
    private let naContainerV = UIView()
    private let textView = UITextView()
    private let titleLbl = UILabel()
    private let backBtn = UIButton()
    private let saveBtn = ShowMoreBtn()
    
    private let saveTxt = NSLocalizedString("Save", comment: "TextVC.swift: Save")
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var shouldFinish = false
    
    var kTitle = ""
    var kPlaceholder = ""
    var kText = ""
    var txt = ""
    var isName = true
    
    var nameCell: CategoriesNameTVCell!
    var desCell: CategoriesDescriptionTVCell!
    
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
        textView.becomeFirstResponder()
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - Configures

extension TextVC {
    
    func setupNavi() {
        view.backgroundColor = .white
        navigationItem.setHidesBackButton(true, animated: false)
        naContainerV.configureContainerView(navigationItem)
        
        //TODO: - Title
        titleLbl.configureTitleForNavi(naContainerV, isTxt: kTitle)
        
        //TODO - Back
        backBtn.configureBackBtn(naContainerV, selector: #selector(backDidTap), controller: self)
        
        //TODO: - Next
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
        dismissKeyboard()
        
        touchAnim(sender) {
            guard self.txt != "" else {
                let txt = NSLocalizedString("Add Text", comment: "TextVC.swift: Add Text")
                handleInternet(txt, imgName: "icon-error")
                return
            }

            if self.isName {
                self.nameDelegate?.fetchText(self.txt, vc: self, cell: self.nameCell)
                
            } else {
                self.descriptionDelegate?.fetchText(self.txt, vc: self, cell: self.desCell)
            }
        }
    }
    
    func updateUI() {
        textView.font = UIFont(name: fontNamed, size: 17.0)
        textView.text = kText != "" ? kText : kPlaceholder
        textView.textColor = .black
        textView.delegate = self
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
        ])
    }
}

//MARK: - UINavigationControllerDelegate

extension TextVC: UINavigationControllerDelegate {
    
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

//MARK: - UITextViewDelegate

extension TextVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == kPlaceholder {
            textView.text = ""
            setupTraitCollection(textView, txtLight: .black, txtDark: .white)
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = kPlaceholder
            setupTraitCollection(textView, txtLight: .lightGray, txtDark: .gray)
        }
        
        textView.resignFirstResponder()
        
        if let text = textView.text,
            text != kPlaceholder,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            txt = text
            
        } else {
            txt = ""
        }
    }
    
    func setupTraitCollection(_ tv: UITextView, txtLight: UIColor, txtDark: UIColor) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: tv.textColor = txtLight
            case .dark: tv.textColor = txtDark
            default: break
            }
        } else {
            tv.textColor = txtLight
        }
    }
}

//MARK: - DarkMode

extension TextVC {
    
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
        textView.textColor = isDarkMode ? .white : .black
        appDl.window?.tintColor = isDarkMode ? .white : .black
    }
}
