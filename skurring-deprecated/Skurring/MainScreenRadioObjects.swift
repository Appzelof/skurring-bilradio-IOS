//
//  MainScreenRadioObjects.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 20.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation
import UIKit

class MainScreenRadioObjects {
    
    private var _image: UIImage!
    private var _URL: String!
    private var _radioInfo: String!
    private var _radioSpot: Int!
    
    var radioSpot: Int {
        get {
            return self._radioSpot
        }
        
        set {
            self._radioSpot = newValue
        }
    }
    
    var image: UIImage {
        
        get{
            return _image
            
        }
        set{
            self._image = newValue
            
        }
    }
    
    var URL: String{
        get{
            return  _URL
        }
        set{
            self._URL = newValue
        }
    }
    
    var radioInfo: String{
        
        get{
            return _radioInfo
            
        }set {
            
            self._radioInfo = newValue
        }
    }
    /*
    override init() {
    
    }
 */
    /*
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self._image = aDecoder.decodeObject(forKey: "image") as? String
        self._URL = aDecoder.decodeObject(forKey: "URL") as? String
        self._radioInfo = aDecoder.decodeObject(forKey: "radioInfo") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._image, forKey: "image")
        aCoder.encode(self._URL, forKey: "URL")
        aCoder.encode(self._radioInfo, forKey: "radioInfo")
    }
 */
    
    init(image: UIImage, URL: String, radioInfo: String, radioSpot: Int) {
        self._image = image
        self._URL = URL
        self._radioInfo = radioInfo
        self._radioSpot = radioSpot
    }
    
    static var mainScreenRadioObjectsArray: [MainScreenRadioObjects] = []
    
        
    
}
