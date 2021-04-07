//
//  ProductRatingHeaderView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class ProductRatingHeaderView: UIView {
    
    //MARK: - Properties
    let averageLbl = UILabel()
    let ratingLargeSV = RatingLargeSV()
    let ratingSV = RatingStackView()
    let ratingCountLbl = UILabel()
    
    private let ratingSmallSV5 = RatingSmallSV()
    private let ratingSmallSV4 = RatingSmallSV()
    private let ratingSmallSV3 = RatingSmallSV()
    private let ratingSmallSV2 = RatingSmallSV()
    private let ratingSmallSV1 = RatingSmallSV()
    
    private let progressV5 = UIProgressView()
    private let progressV4 = UIProgressView()
    private let progressV3 = UIProgressView()
    private let progressV2 = UIProgressView()
    private let progressV1 = UIProgressView()
    
    private let ratingCountLbl5 = UILabel()
    private let ratingCountLbl4 = UILabel()
    private let ratingCountLbl3 = UILabel()
    private let ratingCountLbl2 = UILabel()
    private let ratingCountLbl1 = UILabel()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configures

extension ProductRatingHeaderView {
    
    func setupHeaderView(tableView: UITableView, dl: RatingStackViewDelegate) {
        frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 260.0)
        tableView.tableHeaderView = self
        
        averageLbl.configureNameForCell(false, txtColor: .black, fontSize: 25.0, isTxt: "0.0")
        
        let ratingTxt = NSLocalizedString("Ratings", comment: "ProductRatingHeaderView.swift: Ratings")
        ratingCountLbl.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "0.0 \(ratingTxt)", fontN: fontNamed)
        
        let height: CGFloat = ratingLargeSV.height
        ratingLargeSV.translatesAutoresizingMaskIntoConstraints = false
        ratingLargeSV.widthAnchor.constraint(equalToConstant: height*5).isActive = true
        ratingLargeSV.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let views1: [UIView] = [averageLbl, ratingLargeSV]
        let sv1 = createdStackView(views1, spacing: 5.0, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let views2: [UIView] = [sv1, ratingCountLbl]
        let sv2 = createdStackView(views2, spacing: 3.0, axis: .vertical, distribution: .fill, alignment: .center)
        addSubview(sv2)
        sv2.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - Progress
        setupProgress(progressV5)
        setupProgress(progressV4)
        setupProgress(progressV3)
        setupProgress(progressV2)
        setupProgress(progressV1)
        
        ratingCountLbl5.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "\(0)", fontN: fontNamed)
        ratingCountLbl4.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "\(0)", fontN: fontNamed)
        ratingCountLbl3.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "\(0)", fontN: fontNamed)
        ratingCountLbl2.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "\(0)", fontN: fontNamed)
        ratingCountLbl1.configureNameForCell(false, txtColor: .black, fontSize: 13.0, isTxt: "\(0)", fontN: fontNamed)
        
        setupRatingSmallSV(ratingSmallSV5, rating: 5)
        setupRatingSmallSV(ratingSmallSV4, rating: 4)
        setupRatingSmallSV(ratingSmallSV3, rating: 3)
        setupRatingSmallSV(ratingSmallSV2, rating: 2)
        setupRatingSmallSV(ratingSmallSV1, rating: 1)
        
        let spacing: CGFloat = 8.0
        let viewsP5: [UIView] = [ratingSmallSV5, progressV5, ratingCountLbl5]
        let svP5 = createdStackView(viewsP5, spacing: spacing, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let viewsP4: [UIView] = [ratingSmallSV4, progressV4, ratingCountLbl4]
        let svP4 = createdStackView(viewsP4, spacing: spacing, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let viewsP3: [UIView] = [ratingSmallSV3, progressV3, ratingCountLbl3]
        let svP3 = createdStackView(viewsP3, spacing: spacing, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let viewsP2: [UIView] = [ratingSmallSV2, progressV2, ratingCountLbl2]
        let svP2 = createdStackView(viewsP2, spacing: spacing, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let viewsP1: [UIView] = [ratingSmallSV1, progressV1, ratingCountLbl1]
        let svP1 = createdStackView(viewsP1, spacing: spacing, axis: .horizontal, distribution: .fill, alignment: .center)
        
        let viewsP: [UIView] = [svP5, svP4, svP3, svP2, svP1]
        let svP = createdStackView(viewsP, spacing: 12.0, axis: .vertical, distribution: .fill, alignment: .leading)
        addSubview(svP)
        svP.translatesAutoresizingMaskIntoConstraints = false
        
        let hR: CGFloat = ratingSV.height
        ratingSV.delegate = dl
        addSubview(ratingSV)
        ratingSV.translatesAutoresizingMaskIntoConstraints = false
        ratingSV.widthAnchor.constraint(equalToConstant: hR*5+12).isActive = true
        ratingSV.heightAnchor.constraint(equalToConstant: hR).isActive = true
        
        NSLayoutConstraint.activate([
            sv2.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv2.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
            
            svP.topAnchor.constraint(equalTo: sv2.bottomAnchor, constant: 20.0),
            svP.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            
            ratingSV.topAnchor.constraint(equalTo: svP.bottomAnchor, constant: 5.0),
            ratingSV.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setupProgress(_ progressView: UIProgressView) {
        let value: CGFloat = (15*5)+20+16+42
        progressView.progress = 0.0
        progressView.tintColor = defaultColor
        progressView.transform = progressView.transform.scaledBy(x: 1.0, y: 5.0)
        /*
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10.0
        progressView.layer.sublayers![1].cornerRadius = 10.0
        progressView.subviews[1].clipsToBounds = true
        */
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalToConstant: screenWidth-value).isActive = true
    }
    
    func setupRatingSmallSV(_ small: RatingSmallSV, rating: Int) {
        let height: CGFloat = small.height
        small.rating = rating
        small.translatesAutoresizingMaskIntoConstraints = false
        small.widthAnchor.constraint(equalToConstant: height*5).isActive = true
        small.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setupProgressViewUnit(_ rating5: Int,
                               _ rating4: Int,
                               _ rating3: Int,
                               _ rating2: Int,
                               _ rating1: Int) {
        setupFraction(progressV5, unit: Float(rating5)/1000.0)
        setupFraction(progressV4, unit: Float(rating4)/1000.0)
        setupFraction(progressV3, unit: Float(rating3)/1000.0)
        setupFraction(progressV2, unit: Float(rating2)/1000.0)
        setupFraction(progressV1, unit: Float(rating1)/1000.0)
        setupProgressView()
    }
    
    func setupFraction(_ progressView: UIProgressView, unit: Float) {
        progressView.progress = unit
        progressView.setProgress(progressView.progress, animated: false)
    }
    
    func setupProgressView() {
        setupRatingCountLbl(ratingCountLbl5, progV: progressV5)
        setupRatingCountLbl(ratingCountLbl4, progV: progressV4)
        setupRatingCountLbl(ratingCountLbl3, progV: progressV3)
        setupRatingCountLbl(ratingCountLbl2, progV: progressV2)
        setupRatingCountLbl(ratingCountLbl1, progV: progressV1)
    }
    
    func setupRatingCountLbl(_ lbl: UILabel, progV: UIProgressView) {
        lbl.text = "\(Int(progV.progress*1000))"
    }
    
    func setupDarkModeView(_ isDarkMode: Bool) {
        let txtC: UIColor = isDarkMode ? .white : .black
        backgroundColor = isDarkMode ? .black : .white
        averageLbl.textColor = txtC
        ratingCountLbl.textColor = txtC
        ratingCountLbl5.textColor = txtC
        ratingCountLbl4.textColor = txtC
        ratingCountLbl3.textColor = txtC
        ratingCountLbl2.textColor = txtC
        ratingCountLbl1.textColor = txtC
    }
}
