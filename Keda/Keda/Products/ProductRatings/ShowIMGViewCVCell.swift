//
//  ShowIMGViewCVCell.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ShowIMGViewCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "ShowIMGViewCVCell"
    let productImgView = UIImageView()
    let scrollView = UIScrollView()
    let bgView = UIView()
    var newFrame = CGRect()
    var zoomImgView = UIImageView()
    
    var link: String! {
        didSet {
            Product.downloadImage(from: link) { (image) in
                DispatchQueue.main.async {
                    self.zoomImgView.image = image
                }
            }
        }
    }
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ShowIMGViewCVCell {
    
    func configureCell() {
        productImgView.image = nil
        productImgView.clipsToBounds = true
        productImgView.contentMode = .scaleAspectFill
        contentView.addSubview(productImgView)
        productImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        
        //TODO: - ZoomImage
        newFrame = productImgView.superview!.convert(productImgView.frame, to: nil)
        zoomImgView = UIImageView(frame: newFrame)
        zoomImgView.image = productImgView.image
        zoomImgView.alpha = 0.0
        
        bgView.frame = bounds
        bgView.backgroundColor = .black
        bgView.alpha = 0.0
        
        scrollView.frame = bounds
        scrollView.alpha = 0.0
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        
        contentView.addSubview(bgView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(zoomImgView)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseOut,
                       animations: {
                        self.bgView.alpha = 1.0
                        self.scrollView.alpha = 1.0
                        self.zoomImgView.center = self.center
                        self.zoomImgView.frame = CGRect(origin: .zero, size: self.frame.size)
                        self.zoomImgView.contentMode = .scaleAspectFill
                        self.productImgView.isHidden = true
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.25) {
                            self.zoomImgView.alpha = 1.0
                        }
        })
    }
}

//MARK: - UIScrollViewDelegate

extension ShowIMGViewCVCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImgView
    }
}
