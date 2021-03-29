//
//  HomeScrollView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class HomeScrollView: UIScrollView {
    
    //MARK: - Properties
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension HomeScrollView {
    
    func setupSV(_ view: UIView, dl: UIScrollViewDelegate, ref: UIRefreshControl, contView: UIView, topH: CGFloat) {
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        refreshControl = ref
        contentInsetAdjustmentBehavior = .automatic
        alwaysBounceVertical = true
        bounces = true
        delegate = dl
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ContainerView
        addSubview(contView)
        contView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewW2 = screenWidth/3
        let sellerW = screenWidth + viewW2
        let spacing: CGFloat = 10*7
        let value: CGFloat = 100+(30+40)*3 + sellerW
        let heightCont: CGFloat = topH + screenWidth*2 + value + spacing
        let heightAnchor = contView.heightAnchor.constraint(equalToConstant: heightCont)
        heightAnchor.priority = UILayoutPriority.defaultLow
        heightAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contView.topAnchor.constraint(equalTo: topAnchor),
            contView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
}
