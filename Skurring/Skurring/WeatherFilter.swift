//
//  WeatherFilter.swift
//  Skurring
//
//  Created by Marius Fagerhol on 28/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class WeatherFilter {
    private var weatherIcon = ""
    func formatWeatherIcon(weatherIconName: String) -> String {
        switch weatherIconName {
        case "04":
            self.weatherIcon = "04w"
            break
        case "09":
            self.weatherIcon = "09w"
            break
        case "10":
            self.weatherIcon = "10w"
            break
        case "11":
            self.weatherIcon = "11w"
            break
        case "12":
            self.weatherIcon = "12w"
            break
        case "13":
            self.weatherIcon = "13w"
            break
        case "14":
            self.weatherIcon = "14w"
            break
        case "15":
            self.weatherIcon = "15w"
            break
        case "22":
            self.weatherIcon = "22w"
            break
        case "23":
            self.weatherIcon = "23w"
            break
        case "30":
            self.weatherIcon = "30w"
            break
        case "31":
            self.weatherIcon = "31w"
            break
        case "32":
            self.weatherIcon = "32w"
            break
        case "33":
            self.weatherIcon = "33w"
            break
        case "34":
            self.weatherIcon = "34w"
            break
        case "46":
            self.weatherIcon = "46w"
            break
        case "47":
            self.weatherIcon = "47w"
            break
        case "48":
            self.weatherIcon = "48w"
            break
        case "49":
            self.weatherIcon = "49w"
            break
        case "50":
            self.weatherIcon = "50w"
        default:
            self.weatherIcon = weatherIconName
            break
        }
        return self.weatherIcon
    }
}
