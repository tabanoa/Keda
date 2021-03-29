//
//  UICollectionView+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension UICollectionView {
    
    func configureCVAddSub(_ bgColor: UIColor = .clear, ds: UICollectionViewDataSource, dl: UICollectionViewDelegate, view: UIView) {
        configureCV(bgColor, ds: ds, dl: dl)
        view.addSubview(self)
    }
    
    func configureCVInsert(_ bgColor: UIColor = .clear, ds: UICollectionViewDataSource, dl: UICollectionViewDelegate, view: UIView, below: UIView) {
        configureCV(bgColor, ds: ds, dl: dl)
        view.insertSubview(self, belowSubview: below)
    }
    
    func configureCV(_ bgColor: UIColor, ds: UICollectionViewDataSource, dl: UICollectionViewDelegate) {
        contentInsetAdjustmentBehavior = .never
        backgroundColor = bgColor
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        dataSource = ds
        delegate = dl
        translatesAutoresizingMaskIntoConstraints = false
        reloadData()
    }
}
