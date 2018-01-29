//
//  VegvesenCollectionObject.swift
//  Skurring
//
//  Created by Marius Fagerhol on 09/11/2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//

import UIKit

class VegvesenCollectionObject {
    
    private var _title: String!
    private var _desc: String!
    private var _locationArray: [String]!
    
    var getTitle: String {
        if self._title != nil {
            return self._title
        } else {
            return ""
        }
    }
    
    var getDesc: String {
        if self._desc != nil {
            return self._desc
        } else {
            return ""
        }
    }
    
    var getLocationArray: [String] {
        if self._locationArray != nil {
            return self._locationArray
        } else {
            return []
        }
    }
    
    init(title: String?, desc: String?, locationArray: [String]) {
        if let theTitle = title, let theDesc = desc {
            self._title = theTitle
            self._desc = theDesc
            self._locationArray = locationArray
        }
    }
    
    
}
