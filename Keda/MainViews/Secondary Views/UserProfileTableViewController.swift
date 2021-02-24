//
//  UserProfileTableViewController.swift
//  Keda Profile
//
//  Created by Matthew Mukherjee on 12/22/2020.

import UIKit
import SKPhotoBrowser

protocol UserProfileTableViewControllerDelegate {
    func didLikeUser()
    func didDislikeUser()
}


class UserProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var preference1Label: UILabel!
    @IBOutlet weak var preference2Label: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var clothingSizeLabel: UILabel!
    
    
    //MARK: - Vars
    var userObject: FUser?
    var delegate: UserProfileTableViewControllerDelegate?
    
    var allImages: [UIImage] = []
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0)
    
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        
        if userObject != nil {
            showUserDetails()
            loadImages()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackgrounds()
        hideActivityIndicator()
        
    }

    
    //MARK: - IBActions
    @objc func startChatButtonPressed() {
        goToChat()
    }
    
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    
    //MARK: - Setup UI
    private func setupBackgrounds() {

        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
    }
    
    private func showStartChatButton() {
        
        let messageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startChatButtonPressed))
        }

    
    //MARK: - Show user profile
    private func showUserDetails() {
        
        aboutTextView.text = userObject!.about
        preference1Label.text = userObject!.preference1
        preference2Label.text = userObject!.preference2
        genderLabel.text = userObject!.isMale ? "Male" : "Female"
        heightLabel.text = String(format: "%.2f", userObject!.height)
        clothingSizeLabel.text = userObject!.clothingSize
        
    }

    //MARK: - Activity indicator
    
    private func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }

    private func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }

    //MARK: - Load Images
    private func loadImages() {
        
        let placeholder = userObject!.isMale ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named: placeholder)
        
        allImages = [avatar!]
        self.setPageControlPages()
        
        self.collectionView.reloadData()
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0 {
            
            showActivityIndicator()
            
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                
                self.allImages += returnedImages as! [UIImage]

                DispatchQueue.main.async {
                    self.setPageControlPages()
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }

            }
        } else {
            hideActivityIndicator()
        }
    }
    
    //MARK: - PageControl
    private func setPageControlPages() {
        
        self.pageControl.numberOfPages = self.allImages.count
    }
    
    private func setSelectedPageTo(page: Int) {
        self.pageControl.currentPage = page
    }

    
    //MARK: - SKPhotoBrowse
    private func showImages(_ images: [UIImage], startIndex: Int) {
        
        var SKImages: [SKPhoto] = []
        
        for image in images {
            SKImages.append(SKPhoto.photoWithImage(image))
        }
        
        let browser = SKPhotoBrowser(photos: SKImages)
        browser.initializePageIndex(startIndex)
        self.present(browser, animated: true, completion: nil)
    }

    //MARK: - Helpers
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Navigation
    private func goToChat() {
        
        let chatRoomId = startChat(user1: FUser.currentUser()!, user2: userObject!)
        
        let chatView = ChatViewController(chatId: chatRoomId, recipientId: userObject!.objectId, recipientName: userObject!.username)
        
        chatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatView, animated: true)
    }


}


extension UserProfileTableViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        
        let countryCity = userObject!.country + ", " + userObject!.city
        let nameAge = userObject!.username + ", " + "\(abs(userObject!.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cell.setupCell(image: allImages[indexPath.row], country: countryCity, nameAge: nameAge, indexPath: indexPath)
        
        return cell
    }
    
}


extension UserProfileTableViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showImages(allImages, startIndex: indexPath.row)
    }
    
}

extension UserProfileTableViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.width, height: 453.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        setSelectedPageTo(page: indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

extension UserProfileTableViewController: MatchViewControllerDelegate {
    func didClickSendMessage(to user: FUser) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.goToChat()
        }
    }
    
}
