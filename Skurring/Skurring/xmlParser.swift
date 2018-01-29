//
//  xmlParser.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 26/10/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import Foundation

struct RSSItem {
    var title: String
    var description: String
    var pubData: String
}

class FeedParser: NSObject, XMLParserDelegate {
    private var RSSitems: [RSSItem] = []
    
    private var currentElement: String = ""
    

    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parseCompletionHandler: (([RSSItem]) -> Void)?
    
    
    func ParseFeed(url: String, completionHandler: (([RSSItem])-> Void)?) {
        
        self.parseCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error  {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
            
        }
        task.resume()
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        	currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        
            }
        }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubData: currentPubDate)
            self.RSSitems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
       parseCompletionHandler?(RSSitems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
}
