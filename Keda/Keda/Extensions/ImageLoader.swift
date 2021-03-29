//
//  ImageLoader.swift
//  Keda
//
//  Created by Matthew Mukherjee on 03/03/2021.

import UIKit
import Foundation
import Combine

final class ImageLoader {
    
    private let cache = ImageCache()
    
    @available(iOS 13.0, *)
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ (data, response) -> UIImage? in return UIImage(data: data) })
            .catch({ error in return Just(nil) })
            .handleEvents(receiveOutput: { [unowned self] (image) in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
