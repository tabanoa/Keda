//
//  NewUserOnboardingVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class NewUserOnboardingVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let previousBtn = ShowMoreBtn()
    private let skipBtn = ShowMoreBtn()
    private let nextBtn = ShowMoreBtn()
    private let nextView = UIView()
    private let bgIMGView = UIImageView()
    private let pageControl = UIPageControl()
    private let gradientLayer = CAGradientLayer()
    
    private let nextTxt = NSLocalizedString("NEXT", comment: "NewUserOnboardingVC.swift: NEXT")
    
    private lazy var newUsers: [NewUser] = {
        return NewUser.sharedInstance()
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x282b32)
        createCV()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

//MARK: - Configures

extension NewUserOnboardingVC {
    
    func createCV() {
        bgIMGView.clipsToBounds = true
        bgIMGView.image = UIImage(named: "bg-userOnboarding")
        bgIMGView.contentMode = .scaleAspectFit
        view.addSubview(bgIMGView)
        bgIMGView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.configureCVAddSub(ds: self, dl: self, view: view)
        collectionView.register(NewUserOnboardingCVCell.self, forCellWithReuseIdentifier: NewUserOnboardingCVCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        NSLayoutConstraint.activate([
            bgIMGView.widthAnchor.constraint(equalToConstant: screenWidth),
            bgIMGView.heightAnchor.constraint(equalToConstant: screenWidth),
            bgIMGView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bgIMGView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateUI() {
        
        
        nextView.clipsToBounds = true
        nextView.backgroundColor = .clear
        view.insertSubview(nextView, aboveSubview: collectionView)
        nextView.translatesAutoresizingMaskIntoConstraints = false
        
        createBtn("", txtC: .black, btn: nextBtn, selector: #selector(nextDidTap), fontS: 20.0)
        view.insertSubview(nextBtn, aboveSubview: nextView)
        
        let skipTxt = NSLocalizedString("Skip", comment: "NewUserOnboardingVC.swift: Skip")
        createBtn(skipTxt, btn: skipBtn, selector: #selector(skipDidTap))
        view.insertSubview(skipBtn, aboveSubview: collectionView)
        
        let t: CGFloat = 7.0
        previousBtn.isHidden = true
        previousBtn.contentEdgeInsets = UIEdgeInsets(top: t, left: t, bottom: t, right: t)
        previousBtn.setImage(UIImage(named: "icon-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        previousBtn.tintColor = .white
        previousBtn.addTarget(self, action: #selector(previousDidTap), for: .touchUpInside)
        view.insertSubview(previousBtn, aboveSubview: collectionView)
        previousBtn.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.backgroundColor = .clear
        pageControl.currentPage = 0
        pageControl.numberOfPages = newUsers.count
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        view.insertSubview(pageControl, aboveSubview: collectionView)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        let widthBtn: CGFloat = 30.0
        let nextViewW: CGFloat = screenWidth*0.5
        let nextViewH: CGFloat = 44.0
        NSLayoutConstraint.activate([
            nextView.widthAnchor.constraint(equalToConstant: nextViewW),
            nextView.heightAnchor.constraint(equalToConstant: nextViewH),
            nextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30.0),
            
            nextBtn.topAnchor.constraint(equalTo: nextView.topAnchor),
            nextBtn.leadingAnchor.constraint(equalTo: nextView.leadingAnchor),
            nextBtn.trailingAnchor.constraint(equalTo: nextView.trailingAnchor),
            nextBtn.bottomAnchor.constraint(equalTo: nextView.bottomAnchor),
            
            previousBtn.widthAnchor.constraint(equalToConstant: widthBtn),
            previousBtn.heightAnchor.constraint(equalToConstant: widthBtn),
            previousBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            previousBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            
            skipBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0),
            skipBtn.centerYAnchor.constraint(equalTo: previousBtn.centerYAnchor),
            
            pageControl.widthAnchor.constraint(equalToConstant: 39.0),
            pageControl.heightAnchor.constraint(equalToConstant: 37.0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: -20.0)
        ])
        
        createGradientForNextView(nextTxt)
    }
    
    private func createGradientForNextView(_ txt: String) {
        gradientLayer.removeFromSuperlayer()
        
        let nextViewW: CGFloat = screenWidth*0.5
        let nextViewH: CGFloat = 44.0
        
        //TODO: - Gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let colors = [
            UIColor(hex: 0xffa600).cgColor,
            UIColor.white.cgColor,
            UIColor(hex: 0xffa600).cgColor
        ]
        gradientLayer.colors = colors
        
        let gX: CGFloat = (screenWidth-nextViewW)/2
        let locations: [NSNumber] = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations
        gradientLayer.frame = CGRect(x: -gX, y: 0.0, width: screenWidth, height: nextViewH)
        nextView.layer.addSublayer(gradientLayer)
        
        //TODO: - Animation
        let gradientAnim = CABasicAnimation(keyPath: "locations")
        gradientAnim.fromValue = [0.0, 0.0, 0.25]
        gradientAnim.toValue = [0.75, 1.0, 1.0]
        gradientAnim.duration = 3.0
        gradientAnim.repeatCount = Float.infinity
        gradientLayer.add(gradientAnim, forKey: nil)
        
        //TODO: - DrawImage
        let alt: [NSAttributedString.Key: Any] = {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            return [
                .font: UIFont(name: fontNamedBold, size: 25.0)!,
                .paragraphStyle: style
            ]
        }()
        
        let rect = CGRect(x: 0.0, y: 0.0, width: nextViewW, height: nextViewH)
        let image = UIGraphicsImageRenderer(size: CGSize(width: nextViewW, height: nextViewH)).image { (context) in
            NSString(string: txt).draw(in: rect, withAttributes: alt)
        }

        //TODO: - MaskLayer
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = rect.offsetBy(dx: rect.size.width/2, dy: 5.0)
        maskLayer.contents = image.cgImage
        gradientLayer.mask = maskLayer
    }
    
    private func createBtn(_ txt: String, txtC: UIColor = .white, btn: UIButton, selector: Selector, fontS: CGFloat = 15.0) {
        let alt = setupTitleAttri(txt, txtColor: txtC, size: fontS)
        btn.contentEdgeInsets = .zero
        btn.setAttributedTitle(alt, for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func nextDidTap(_ sender: UIButton) {
        touchAnim(sender, frValue: 0.8) {
            self.nextPage()
        }
    }
    
    @objc func skipDidTap(_ sender: UIButton) {
        touchAnim(sender, frValue: 0.9) {
            self.pageControl.currentPage = self.newUsers.count-1
            self.nextPage()
        }
    }
    
    @objc func previousDidTap(_ sender: UIButton) {
        touchAnim(sender, frValue: 0.9) {
            if self.pageControl.currentPage == 0 { return }
            let indexPath = IndexPath(item: self.pageControl.currentPage-1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.pageControl.currentPage -= 1
            
            if self.pageControl.currentPage == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.previousBtn.isHidden = true
                }
                return
            }
            
            if self.pageControl.currentPage < self.newUsers.count-1 {
                UIView.animate(withDuration: 0.5) {
                    self.createGradientForNextView(self.nextTxt)
                }
            }
        }
    }
    
    private func nextPage() {
        if pageControl.currentPage == newUsers.count-1 {
            if !Manager.sharedInstance.getFirstTime() {
                Manager.sharedInstance.setFirstTime(true)
            }
            
            let vc = TabBarController()
            navigationController?.pushViewController(vc, animated: false)
            return
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage+1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
        
        if pageControl.currentPage >= 1 {
            UIView.animate(withDuration: 0.5) {
                self.previousBtn.isHidden = false
            }
        }
        
        if pageControl.currentPage == newUsers.count-1 {
            UIView.animate(withDuration: 0.5) {
                let txt = NSLocalizedString("FINISH", comment: "NewUserOnboardingVC.swift: FINISH")
                self.createGradientForNextView(txt)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension NewUserOnboardingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewUserOnboardingCVCell.identifier, for: indexPath) as! NewUserOnboardingCVCell
        cell.newUser = newUsers[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension NewUserOnboardingVC: UICollectionViewDelegate {}

//MARK: - UICollectionViewDelegateFlowLayout

extension NewUserOnboardingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
}
