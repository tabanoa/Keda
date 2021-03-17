//
//  EditColorHeaderView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol EditColorHeaderViewDelegate: class {
    func handleSelectDidTap()
    func handleSegmentChanged(_ index: Int)
}

class EditColorHeaderView: UIView {
    
    //MARK: - Properties
    weak var delegate: EditColorHeaderViewDelegate?
    private var segmentControl = UISegmentedControl()
    private let selectBtn = ShowMoreBtn()
    
    private let txt = NSLocalizedString("Select", comment: "EditColorHeaderView.swift: Select")
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Congigure

extension EditColorHeaderView {
    
    func setupHeaderView(_ view: UIView, dl: EditColorHeaderViewDelegate) {
        //TODO: - TopView
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SelectBtn
        let fontSize: CGFloat
        if appDl.iPhone5 {
            fontSize = 11.0
            
        } else {
            fontSize = 15.0
        }
        
        let attributed = setupTitleAttri(txt, size: fontSize)
        selectBtn.setAttributedTitle(attributed, for: .normal)
        selectBtn.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        selectBtn.backgroundColor = .black
        selectBtn.clipsToBounds = true
        selectBtn.layer.cornerRadius = 3.0
        selectBtn.addTarget(self, action: #selector(selectDidTap), for: .touchUpInside)
        addSubview(selectBtn)
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SegmentControl
        segmentControl = UISegmentedControl(items: ["Wheel", "Swatches", "Slider"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40.0),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            selectBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            selectBtn.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            selectBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.0),
            
            segmentControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            segmentControl.leadingAnchor.constraint(equalTo: selectBtn.trailingAnchor, constant: 10.0)
        ])
        
        delegate = dl
    }
    
    @objc func selectDidTap(_ sender: UIButton) {
        touchAnim(sender) {
            self.delegate?.handleSelectDidTap()
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        delegate?.handleSegmentChanged(sender.selectedSegmentIndex)
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        let fontSize: CGFloat
        if appDl.iPhone5 {
            fontSize = 11.0
            
        } else {
            fontSize = 15.0
        }
        
        let attC: UIColor = isDarkMode ? .black : .white
        let attributed = setupTitleAttri(txt, txtColor: attC, size: fontSize)
        selectBtn.setAttributedTitle(attributed, for: .normal)
        selectBtn.backgroundColor = isDarkMode ? .white : .black
    }
}
