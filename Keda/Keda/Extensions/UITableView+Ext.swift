//
//  UITableView+Ext.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

extension UITableView {
    
    func configureTVNonSepar(_ bgColor: UIColor = .white, ds: UITableViewDataSource, dl: UITableViewDelegate, view: UIView) {
        configureTV(bgColor, ds: ds, dl: dl, view: view)
        separatorStyle = .none
    }
    
    func configureTVSepar(_ bgColor: UIColor = .white, ds: UITableViewDataSource, dl: UITableViewDelegate, view: UIView) {
        configureTV(bgColor, ds: ds, dl: dl, view: view)
        separatorColor = lightSeparatorColor
    }
    
    func configureTV(_ bgColor: UIColor, ds: UITableViewDataSource, dl: UITableViewDelegate, view: UIView) {
        contentInsetAdjustmentBehavior = .never
        backgroundColor = bgColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        sectionHeaderHeight = 0.0
        sectionFooterHeight = 0.0
        dataSource = ds
        delegate = dl
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        reloadData()
    }
}
