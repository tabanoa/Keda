//
//  ImageCollectionViewCell.swift
// kedaCataloguePayment
// By Manjot Sidhu
// February 7th 2021


import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImage
    }
    
}
