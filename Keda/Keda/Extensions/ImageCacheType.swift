//
//  ImageCacheType.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit

protocol ImageCacheType: class {
    
    func image(for url: URL) -> UIImage?
    func insertImage(_ img: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImage()
    subscript(_ url: URL) -> UIImage? { get set }
}
