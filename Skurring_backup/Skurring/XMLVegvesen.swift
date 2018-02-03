//
//  XMLVegvesen.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class XMLVegvesen: NSObject, XMLParserDelegate {
    
    private var elementName: String!
    private var tagDict: Dictionary<String, String> = [:]
    private var parser: XMLParser!
    private var vegvesenObjects: [VegvesenCollectionObject]!
    private var locationArray: [String]!
    private var location: String!
    private var urlRequest: String!
    private var CompletionHandler: (([VegvesenCollectionObject]) -> Void)?
    
    init(fylke: String) {
        super.init()
        let fylkeID = getFylkeID(fylke: fylke)
        urlRequest = "https://www.vegvesen.no/trafikk/xml/search.rss?searchFocus.counties=\(fylkeID)"
        self.setup()
    }
    
    private func setup() {
        self.tagDict = [
            "title": "",
            "desc": ""
        ]
        self.locationArray = []
        location = ""
    }
    
    func beginParsing(Completion: @escaping ([VegvesenCollectionObject]) -> ()) {
        self.CompletionHandler = Completion
        self.vegvesenObjects = []
        
        let request = URLRequest.init(url: URL.init(string: urlRequest)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, respinse, error) in
            if error == nil {
                if let theData = data {
                    self.parser = XMLParser.init(data: theData)
                    self.parser.delegate = self
                    print("Starting to parse")
                    self.parser.parse()
                }
            }
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
        if self.elementName == "item" {
            setup()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let vegObject = VegvesenCollectionObject.init(title: self.tagDict["title"], desc: self.tagDict["desc"], locationArray: self.locationArray)
            self.vegvesenObjects.append(vegObject)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let elementName = self.elementName {
            switch elementName {
                case "title":
                    if self.tagDict["title"] != nil {
                        self.tagDict["title"]!.append(string)
                    }
                    break;
                case "description":
                    if self.tagDict["desc"] != nil {
                        self.tagDict["desc"]!.append(string)
                    }
                    break;
                case "gml:pos":
                    if string != "" && checkIfStringContainsInteger(checkString: string) {
                        self.locationArray.append(string)
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parser.abortParsing()
        self.CompletionHandler?(self.vegvesenObjects)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error occured: \(parseError.localizedDescription)")
    }
    
    func checkIfStringContainsInteger(checkString: String) -> Bool {
        let numberRange = checkString.rangeOfCharacter(from: .decimalDigits)
        return (numberRange != nil)
    }
    
}
