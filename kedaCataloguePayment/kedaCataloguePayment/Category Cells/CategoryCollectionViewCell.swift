// CategoryCollectionViewCell.swift
// kedaCataloguePayment
// By Manjot Sidhu
// February 7th 2021

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category: Category) {
        
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
}
