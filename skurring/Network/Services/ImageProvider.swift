//
//  ImageDownloader.swift
//  skurring
//
//  Created by Daniel Bornstedt on 13/10/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

final class ImageProvider {
    private let imageCache = NSCache<AnyObject, AnyObject>()
    private var cacheKey: AnyObject?

    func fetchImage(url: String, completion: @escaping(UIImage) -> Void) {
        cacheKey = url as AnyObject
        
        if
            let key = cacheKey,
            let image = getCachedImage(forKey: key) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            downloadImage(url: url, completion: completion)
        }
    }

    private func downloadImage(url: String, completion: @escaping (UIImage) -> Void){
        guard
            let url = URL(string: url),
            let cacheKey = cacheKey
        else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                if let image = image {
                    self.cacheImage(image: image, forKey: cacheKey)
                    DispatchQueue.main.sync {
                        completion(image)
                    }
                }
            }
        }.resume()
    }
}

extension ImageProvider {
    func cacheImage(image: AnyObject, forKey: AnyObject) {
        imageCache.setObject(image, forKey: forKey)
    }

    func getCachedImage(forKey: AnyObject) -> UIImage? {
        return imageCache.object(forKey: forKey) as? UIImage
    }
}
