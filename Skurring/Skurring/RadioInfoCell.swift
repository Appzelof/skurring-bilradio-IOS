//
//  RadioInfoCell.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 19.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class RadioInfoCell: UITableViewCell {
    
    @IBOutlet weak var radioInfo: UILabel!
    @IBOutlet weak var theImage: UIImageView!
    
    private var dataTask: URLSessionDataTask?

    func updateUI(information: RadioPlayer){
        self.radioInfo.text = information.radioINFO
        
        self.theImage.alpha = 0
        dataTask?.cancel()
        if let theSavedImage = DS.dsInstance.stationImageCache.object(forKey: information.imgPNG as NSString) {
            self.theImage.image = theSavedImage
            self.theImage.alpha = 1
        } else {
            loadImage(url: information.imgPNG) { (theImage) in
                if let loadedImage = theImage {
                    self.theImage.image = loadedImage
                    self.theImage.alpha = 1
                }
            }
        }
    }
    
    private func loadImage(url: String, done: @escaping (_ loadedImage: UIImage?) -> ()) {
        if let theUrl = URL(string: url) {
           dataTask = URLSession.shared.dataTask(with: theUrl) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data else {
                        print("There is no data")
                        done(nil)
                        return
                    }
                    if let theImage = UIImage(data: data) {
                        print("Got the image, the image should be set")
                        DS.dsInstance.stationImageCache.setObject(theImage, forKey: url as NSString)
                        done(theImage)
                    } else {
                        print("Something is wrong with the data")
                        done(nil)
                    }
                }
            }
            dataTask?.resume()
        }
    }


}
