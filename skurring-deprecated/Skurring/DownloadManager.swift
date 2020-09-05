//
//  DownloadManager.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 06/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation
import Alamofire

typealias Complete = (_ imageUrl: String) -> ()
typealias ImageComplete = (_ downloadedImage: UIImage) -> ()

class DownloadCurrentArtImage {
    
    func DownloadImageUrl(url: String, urlComplete: @escaping Complete) {
        
        print("I GOT THE IMAGE URL \(url)")
        
        if url != "" {
            Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!).responseJSON { (response) in
                let TheResult = response.result
                
                if let TheDownloadingValue = TheResult.value as? Dictionary<String, AnyObject> {
                    
                    if let TheDownloadingResults = TheDownloadingValue["results"] as? [Dictionary<String, AnyObject>] {
                        
                        if TheDownloadingResults.count > 0 {
                            if let TheBigPic = TheDownloadingResults[0]["artworkUrl100"] as? String {
                                urlComplete(TheBigPic)
                            }
                        } else {
                            urlComplete("")
                        }
                    }
                }
            }
        } else {
            urlComplete(url)
        }
    }
}

func getAppIcon() -> UIImage {
    return UIImage(named: "AppIcon")!
}

class makeImageFromUrl {
    
    func makeImage(url: String, imageComplete: @escaping ImageComplete) {
        if url == "" {
            imageComplete(getAppIcon())
        } else {
            let TheFixedUrl = url.replacingOccurrences(of: "/source/100x100bb.jpg", with: "/source/1000x1000bb.jpg")
            print("URL AFTER FIXED: \(TheFixedUrl)")
            Alamofire.request(TheFixedUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!).validate(contentType: ["image/*"]).response { (response) in
                if let theData = response.data {
                    if let theHttpResponse = response.response {
                        if theHttpResponse.statusCode == 200 {
                            if let TheImage = UIImage(data: theData) {
                                imageComplete(TheImage)
                            }
                        } else {
                            imageComplete(getAppIcon())
                        }
                    }
                }
            }
        }
    }
    
}
