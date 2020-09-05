//
//  WeatherDataModel.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 07/09/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation

class WeatherData {
    
    private var _cityName: String?
    private var _cityTemp: Int?
    private var _weatherImg: String?
    
    var cityName: String? {
        get {
            if _cityName == nil {
                _cityName = ""
            }
            return _cityName
        }
        set {
            _cityName = newValue
        }
    }
    
    var cityTemp: Int? {
        get {
            if _cityTemp == nil {
                _cityTemp = 0
            }
            return _cityTemp
        }
        set {
            _cityTemp = newValue
        }
    }
    
    var weatherImg: String? {
        get {
            if _weatherImg == nil {
                _weatherImg = ""
            }
            return _weatherImg
        }
        set {
            _weatherImg = newValue
        }
    }
    
}


    

