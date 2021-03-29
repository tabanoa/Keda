//
//  ProductImageVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

class ProductImageVC: UIViewController {
    
    private let productImgView = UIImageView()
    var imageLink: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(productImgView)
        productImgView.clipsToBounds = true
        productImgView.contentMode = .scaleAspectFill
        productImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            productImgView.topAnchor.constraint(equalTo: view.topAnchor),
            productImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productImgView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Product.downloadImage(from: imageLink) { (image) in
            self.productImgView.image = image
        }
    }
}
