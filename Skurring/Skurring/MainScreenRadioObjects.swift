//
//  MainScreenRadioObjects.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 20.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation
import UIKit

class MainScreenRadioObjects: NSObject, NSCoding {
    
    private var _image: String!
    private var _URL: String!
    private var _radioInfo: String!
    
    var image: String{
        
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
    
    override init() {
    
    }
    
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
    
    init(image: String, URL: String, radioInfo: String) {
        self._image = image
        self._URL = URL
        self._radioInfo = radioInfo
    }
    
    static var mainScreenRadioObjectsArray: [MainScreenRadioObjects] = []
    
        
    
}
