//
//  SendObject.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 20.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//s

import Foundation

func lagTommeObjekterTilMainScreenRadioObjectsHvisArrayenErTom() -> [MainScreenRadioObjects] {
    
    let knappNummer0 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    let knappNummer1 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    let knappNummer2 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    let knappNummer3 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    let knappNummer4 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    let knappNummer5 = MainScreenRadioObjects.init(image: "", URL: "", radioInfo: "")
    
    
    return [knappNummer0, knappNummer1, knappNummer2, knappNummer3, knappNummer4, knappNummer5]
}

class SendObject{
    
    private var _radioNumber: Int!
    private var _image: String!
    private var _URL: String!
    private var _radioInfo: String!
    
    var radioNumber: Int {
        return _radioNumber
    }
    
    var image: String{
        return _image
    }
    
    var URL: String{
        return _URL
    }
    
    var radioInfo: String{
        return _radioInfo
    }
    
    init(image: String, URL: String, radioInfo: String, radioNumber: Int) {
        self._radioNumber = radioNumber
        self._image = image
        self._URL = URL
        self._radioInfo = radioInfo
    }
    
    
}
