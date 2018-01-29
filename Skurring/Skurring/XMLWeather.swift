//
//  XMLManager.swift
//  Skurring
//
//  Created by Marius Fagerhol on 08/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class XMLWeather: NSObject, XMLParserDelegate {
    
    private var parser = XMLParser()
    
    private var weatherSymbol: [[String: String]] = []
    private var weatherTemperature: [[String: String]] = []
    
    private var wholeUrl: String?
    
    private var completionHandler: ((_ object: WeatherCollectionObject, _ wentAsync: Bool) -> Void)?
    
    var getWholeUrl: String {
        if let theWholeUrl = self.wholeUrl {
            if let theFixedUrl = theWholeUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return theFixedUrl
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    
    private func formatPostalCode(postalCode: String) -> String {
        let formattedCode = postalCode.replacingOccurrences(of: " ", with: "")
        return formattedCode
    }
    
    init(postalCode: String?, countryName: String?) {
        super.init()
        if let thePostalCode = postalCode, let theCountryName = countryName {
            if theCountryName == "Norway" {
                self.wholeUrl = "https://www.yr.no/sted/Norge/Postnummer/\(formatPostalCode(postalCode: thePostalCode))/varsel.xml"
            }
        }
    }
    
    public func beginParsing(Completed: @escaping (_ object: WeatherCollectionObject, _ wentAsync: Bool) -> ()) {
        self.completionHandler = Completed
        if getWholeUrl != "" {
            if let theUrl = URL.init(string: self.getWholeUrl) {
                let theUrlRequest = URLRequest.init(url: theUrl)
                let urlSession = URLSession.shared
                let task = urlSession.dataTask(with: theUrlRequest) { (data, response, error) in
                    if error == nil {
                        if let theData = data {
                            self.parser = XMLParser.init(data: theData)
                            self.parser.delegate = self
                            self.parser.parse()
                        }
                    }
                }
                task.resume()
            } else {
                self.completionHandler?(WeatherCollectionObject(), false)
            }
        } else {
            self.completionHandler?(WeatherCollectionObject(), false)
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "symbol":
            self.weatherSymbol.append(attributeDict)
            break;
        case "temperature":
            self.weatherTemperature.append(attributeDict)
            break;
        default:
            break;
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parser.abortParsing()
        var weatherCollectionObject = WeatherCollectionObject()
        if self.weatherSymbol.count > 0 && self.weatherTemperature.count > 0 {
            weatherCollectionObject = WeatherCollectionObject.init(imageName: self.weatherSymbol[0]["var"], temperature: self.weatherTemperature[0]["value"])
            self.completionHandler?(weatherCollectionObject, true)
        } else {
            self.completionHandler?(weatherCollectionObject, true)
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error occured: \(parseError)")
    }
    
    
}

