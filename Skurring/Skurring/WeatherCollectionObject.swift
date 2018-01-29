//
//  WeatherCollectionObject.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class WeatherCollectionObject {
    
    private var imageName: String!
    private var temperature: String!
    
    var getImageName: String {
        if self.imageName != nil {
            return self.imageName
        } else {
            return ""
        }
    }
    
    var getTemperature: String {
        if self.temperature != nil {
            return self.temperature
        } else {
            return ""
        }
    }
    
    init() {}
    
    init(imageName: String?, temperature: String?) {
        if let theImageName = imageName {
            self.imageName = theImageName
        }
        
        if let theTemperature = temperature {
            self.temperature = theTemperature
        }
    }
    
}
