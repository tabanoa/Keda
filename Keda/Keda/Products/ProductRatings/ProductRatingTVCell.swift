//
//  ProductRatingTVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

protocol ProductRatingTVCellDelegate: class {
    func viewImage(_ cell: ProductRatingTVCell, indexPath: IndexPath)
    func viewAllImage(_ cell: ProductRatingTVCell, indexPath: IndexPath)
}

class ProductRatingTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "ProductRatingTVCell"
    
    weak var delegate: ProductRatingTVCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let avatarIMGView = UIImageView()
    let nameLbl = UILabel()
    let descriptionLbl = UILabel()
    let createdTimeLbl = UILabel()
    let ratingLargeSV = RatingSmallSV()
    let prefixLbl = UILabel()
    
    var prRating: Rating?
    lazy var imageLinks: [String] = []
    
    var review: Review! {
        didSet {
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
            
            descriptionLbl.isHidden = review.description == nil
            
            if !review.show {
                collectionView.isHidden = false
                
            } else {
                collectionView.isHidden = review.imageLinks == []
            }
            
            if review.type == "text" {
                descriptionLbl.text = review.description
                
            } else if review.type == "image" {
                imageLinks = review.imageLinks
                collectionView.reloadData()
                
            } else {
                descriptionLbl.text = review.description
                imageLinks = review.imageLinks
                collectionView.reloadData()
            }
            
            let f = DateFormatter()
            f.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormatter().date(from: review.createdTime)!
            createdTimeLbl.text = f.string(from: date)
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
}

//MARK: - Condigure

extension ProductRatingTVCell {
    
    func configureCell() {
        //TODO: - Avatar ImageView
        let imgW: CGFloat = 50.0
        avatarIMGView.clipsToBounds = true
        avatarIMGView.layer.cornerRadius = imgW/2
        avatarIMGView.contentMode = .scaleAspectFit
        avatarIMGView.image = nil
        avatarIMGView.translatesAutoresizingMaskIntoConstraints = false
        avatarIMGView.widthAnchor.constraint(equalToConstant: imgW).isActive = true
        avatarIMGView.heightAnchor.constraint(equalToConstant: imgW).isActive = true
        
        //TODO: - Product ImageView
        collectionView.configureCV(.clear, ds: self, dl: self)
        collectionView.register(ProductRatingCVCell.self, forCellWithReuseIdentifier: ProductRatingCVCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.isHidden = true
        collectionView.isScrollEnabled = false
        collectionView.widthAnchor.constraint(equalToConstant: imgW*3+4).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: imgW).isActive = true
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        
        //TODO: - Name
        nameLbl.configureNameForCell(false, txtColor: .black, fontSize: 15.0, isTxt: "Keda Team")
        descriptionLbl.configureNameForCell(false, line: 0, txtColor: .black, fontSize: 13.0, isTxt: "Description", fontN: fontNamed)
        createdTimeLbl.configureNameForCell(false, txtColor: .gray, fontSize: 12.0, isTxt: "3 ngày trước", fontN: fontNamed)
        
        //TODO: - Ratings
        let height: CGFloat = ratingLargeSV.height
        ratingLargeSV.rating = 0
        contentView.addSubview(ratingLargeSV)
        ratingLargeSV.translatesAutoresizingMaskIntoConstraints = false
        
        let views1: [UIView] = [nameLbl, descriptionLbl, collectionView, createdTimeLbl]
        let sv1 = createdStackView(views1, spacing: 8.0, axis: .vertical, distribution: .fill, alignment: .leading)
        
        let views2: [UIView] = [avatarIMGView, sv1]
        let sv2 = createdStackView(views2, spacing: 10.0, axis: .horizontal, distribution: .fillProportionally, alignment: .top)
        contentView.addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv2.widthAnchor.constraint(equalToConstant: screenWidth-100),
            sv2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            sv2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            sv2.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20.0),
            
            ratingLargeSV.widthAnchor.constraint(equalToConstant: height*5),
            ratingLargeSV.heightAnchor.constraint(equalToConstant: height),
            ratingLargeSV.topAnchor.constraint(equalTo: sv2.topAnchor),
            ratingLargeSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        ])
        
        //TODO: - PrefixLbl
        let prefix = "\(nameLbl.text!.prefix(1))"
        prefixLbl.configureNameForCell(true, txtColor: .white, fontSize: 17.0, isTxt: prefix)
        contentView.insertSubview(prefixLbl, aboveSubview: avatarIMGView)
        prefixLbl.translatesAutoresizingMaskIntoConstraints = false
        prefixLbl.centerXAnchor.constraint(equalTo: avatarIMGView.centerXAnchor).isActive = true
        prefixLbl.centerYAnchor.constraint(equalTo: avatarIMGView.centerYAnchor).isActive = true
        
        if avatarIMGView.image == nil {
            avatarIMGView.backgroundColor = UIColor(hex: 0xDEDEDE)
            prefixLbl.isHidden = false
        }
        
        setupDarkMode()
    }
}

//MARK: - UICollectionViewDataSource

extension ProductRatingTVCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if imageLinks.count > 2 { return 2 }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard review.show else { return 1 }
        if section == 0 { return imageLinks.count >= 2 ? 2 : 1 }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductRatingCVCell.identifier, for: indexPath) as! ProductRatingCVCell
            if review.show {
                guard imageLinks.count != 0 else { return cell }
                cell.link = imageLinks[indexPath.item]
                cell.activityIndicator.isHidden = true
                cell.activityIndicator.stopAnimating()
                
            } else {
                cell.imgView.image = nil
                cell.imgView.backgroundColor = UIColor(hex: 0xDEDEDE)
                cell.activityIndicator.isHidden = false
                cell.activityIndicator.startAnimating()
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.backgroundColor = UIColor(hex: 0xDEDEDE)
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
            
            let imgView = UIImageView()
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFit
            imgView.image = UIImage(named: "icon-back")
            imgView.transform = CGAffineTransform(rotationAngle: CGFloat(180).degreesToRadians())
            cell.addSubview(imgView)
            imgView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imgView.widthAnchor.constraint(equalToConstant: 20.0),
                imgView.heightAnchor.constraint(equalToConstant: 20.0),
                imgView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
                imgView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            ])
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension ProductRatingTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            delegate?.viewImage(self, indexPath: indexPath)
            
        } else {
            delegate?.viewAllImage(self, indexPath: indexPath)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductRatingTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width-2)/3, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 2.0, height: 50.0)
    }
}

//MARK: - DarkMode

extension ProductRatingTVCell {
    
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
        nameLbl.textColor = isDarkMode ? .white : .black
        descriptionLbl.textColor = isDarkMode ? .white : .black
        createdTimeLbl.textColor = isDarkMode ? .lightGray : .gray
    }
}
