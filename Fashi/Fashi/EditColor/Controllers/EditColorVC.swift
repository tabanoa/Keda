//
//  EditColorVC.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol EditColorVCDelegate: class {
    func fetchColor(_ color: UIColor, vc: EditColorVC)
}

class EditColorVC: UIViewController {
    
    //MARK: - Properties
    private let headerView = EditColorHeaderView()
    
    private let wheelView = WheelView()
    private let swatchesView = SwatchesView()
    private let sliderView = SliderView()
    
    weak var kDelegate: EditColorVCDelegate?
    weak var delegate: ColorPickerDelegate?
    
    var selectedColor = UIColor.white
    
    enum SegmentIndex: Int {
        case picker = 0, swatches, slider
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateUI()
        setupDarkMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

//MARK: - Configures

extension EditColorVC {
    
    func updateUI() {
        headerView.setupHeaderView(view, dl: self)
        wheelView.setupWheelView(view, topView: headerView)
        swatchesView.setupSwatchesView(view, topView: headerView)
        sliderView.setupSliderView(view, topView: headerView)
        
        wheelView.delegate = self
        wheelView.selectedColor = selectedColor
        
        swatchesView.delegate = self
        swatchesView.selectedColor = selectedColor
        
        sliderView.delegate = self
        sliderView.selectedColor = selectedColor
    }
}

//MARK: - EditColorHeaderViewDelegate

extension EditColorVC: EditColorHeaderViewDelegate {
    
    func handleSelectDidTap() {
        kDelegate?.fetchColor(selectedColor, vc: self)
    }
    
    func handleSegmentChanged(_ index: Int) {
        sliderView.closeKeyboard()
        
        switch index {
        case 0:
            wheelView.isHidden = false
            swatchesView.isHidden = true
            sliderView.isHidden = true
        case 1:
            wheelView.isHidden = true
            swatchesView.isHidden = false
            sliderView.isHidden = true
        default:
            wheelView.isHidden = true
            swatchesView.isHidden = true
            sliderView.isHidden = false
        }
    }
}

//MARK: - ColorPicker

extension EditColorVC: ColorPicker {}

//MARK: - ColorPickerDelegate

extension EditColorVC: ColorPickerDelegate {
    
    func colorPicker(_ colorPicker: ColorPicker, didSelect color: UIColor) {
        selectedColor = color
        
        if colorPicker == wheelView {
            swatchesView.selectedColor = color
            sliderView.selectedColor = color
            
        } else if colorPicker == swatchesView {
            wheelView.selectedColor = color
            sliderView.selectedColor = color
            
        } else if colorPicker == sliderView {
            wheelView.selectedColor = color
            swatchesView.selectedColor = color
        }
        
        delegate?.colorPicker(self, didSelect: color)
    }
}

//MARK: - DarkMode

extension EditColorVC {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupDarkMode()
    }
    
    private func setupDarkMode() {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified: setupDarkModeView()
            case .dark: setupDarkModeView(true)
            default: break
            }
        } else {
            setupDarkModeView()
        }
    }
    
    private func setupDarkModeView(_ isDarkMode: Bool = false) {
        view.backgroundColor = isDarkMode ? .black : .white
        headerView.setupDarkMode(isDarkMode)
        wheelView.setupDarkMode(isDarkMode)
        swatchesView.setupDarkMode(isDarkMode)
        sliderView.setupDarkMode(isDarkMode)
    }
}
