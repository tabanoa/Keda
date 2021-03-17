//
//  SwatchesView.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

class SwatchesView: UIView, ColorPicker {
    
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let colorView = ColorTopView()
    let opacityView = OpacityView()
    
    lazy var colors: [UIColor] = {
        [
        UIColor(hex: 0xFF8A80), UIColor(hex: 0xEA80FC), UIColor(hex: 0xB388FF),
        UIColor(hex: 0x8C9EFF), UIColor(hex: 0x80D8FF), UIColor(hex: 0x84FFFF),
        UIColor(hex: 0xFF1744), UIColor(hex: 0xD500F9), UIColor(hex: 0x651FFF),
        UIColor(hex: 0x00B0FF), UIColor(hex: 0x00E5FF), UIColor(hex: 0xD50000),
        UIColor(hex: 0xAA00FF), UIColor(hex: 0x6200EA), UIColor(hex: 0x0091EA),
        UIColor(hex: 0x0091EA), UIColor(hex: 0x00B8D4), UIColor(hex: 0xB9F6CA),
        UIColor(hex: 0xFFFF8D), UIColor(hex: 0xFFD180), UIColor(hex: 0xFF9E80),
        UIColor(hex: 0xBCAAA4), UIColor(hex: 0xBDBDBD), UIColor(hex: 0x00E676),
        UIColor(hex: 0xFFEA00), UIColor(hex: 0xFF9100), UIColor(hex: 0xFF3D00),
        UIColor(hex: 0x795548), UIColor(hex: 0x616161), UIColor(hex: 0x00C853),
        UIColor(hex: 0xFFD600), UIColor(hex: 0xFF6D00), UIColor(hex: 0xDD2C00),
        UIColor(hex: 0x4E342E), UIColor(hex: 0x212121),
        ]
    }()
    
    var selectColor: UIColor?
    weak var delegate: ColorPickerDelegate?
    
    var selectedColor: UIColor = .white {
        didSet {
            colorView.backgroundColor = selectedColor
            
            var alpha: CGFloat = 0.0
            selectedColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            
            alpha = alpha*100
            opacityView.percentLbl.text = "\(NSString(format: "%.0f", alpha))"
            opacityView.slider.value = Float(alpha)
        }
    }
    
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

extension SwatchesView {
    
    func setupSwatchesView(_ view: UIView, topView: UIView) {
        isHidden = true
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - ColorView
        colorView.setupColorView(self)
        
        //TODO: - Opacity
        opacityView.setupOpacityView(self, txt: "Opacity", wTxt: "Opacity")
        opacityView.slider.addTarget(self, action: #selector(opacityChanged), for: .valueChanged)
        
        let oTap = UITapGestureRecognizer(target: self, action: #selector(opacityDidTap))
        opacityView.slider.addGestureRecognizer(oTap)
        
        //TODO: - CollectionView
        collectionView.configureCVAddSub(ds: self, dl: self, view: self)
        collectionView.register(CategoriesColorsCVCell.self, forCellWithReuseIdentifier: CategoriesColorsCVCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5.0
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topView.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            
            collectionView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 10.0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: opacityView.topAnchor, constant: -10.0),
        ])
    }
    
    @objc func opacityChanged(_ sender: UISlider) {
        opacityView.percentLbl.text = "\(Int(sender.value))"
        didSelect(colorView.backgroundColor!)
    }
    
    @objc func opacityDidTap(_ sender: UITapGestureRecognizer) {
        let slider = opacityView.slider
        let location = sender.location(in: self)
        let pos = slider.frame.origin
        let width = slider.frame.width
        let max = CGFloat(slider.maximumValue)
        let newValue = (location.x - pos.x) * max / width
        slider.setValue(Float(newValue), animated: true)
        
        opacityView.percentLbl.text = "\(NSString(format: "%.0f", slider.value))"
        didSelect(colorView.backgroundColor!)
    }
    
    private func didSelect(_ color: UIColor) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        let alpha = NSString(string: opacityView.percentLbl.text!).floatValue/100
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        let selectColor = UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
        colorView.backgroundColor = selectColor
        delegate?.colorPicker(self, didSelect: selectColor)
    }
    
    func reloadData() {
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    func setupDarkMode(_ isDarkMode: Bool) {
        opacityView.nameLbl.textColor = isDarkMode ? .white : .black
        opacityView.percentLbl.textColor = isDarkMode ? .white : .black
    }
}

//MARK: - UICollectionViewDataSource

extension SwatchesView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesColorsCVCell.identifier, for: indexPath) as! CategoriesColorsCVCell
        let color = colors[indexPath.item]
        cell.color = color
        setupCell(color, cell: cell)
        return cell
    }
    
    func setupCell(_ color: UIColor, cell: CategoriesColorsCVCell) {
        cell.isSelect = selectColor == color
    }
}

//MARK: - UICollectionViewDelegate

extension SwatchesView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesColorsCVCell else { return }
        let color = colors[indexPath.item]
        touchAnim(cell, frValue: 0.8) {
            self.selectColor = nil
            self.selectColor = color
            self.didSelect(color)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SwatchesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (screenWidth-(5*9))/8
        return CGSize(width: cellSize, height: cellSize)
    }
}
