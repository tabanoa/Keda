//
//  ColorPickerProtocol.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.
import UIKit

public protocol ColorPicker: NSObject {}

public protocol ColorPickerDelegate: class {
    func colorPicker(_ colorPicker: ColorPicker, didSelect color: UIColor)
}
