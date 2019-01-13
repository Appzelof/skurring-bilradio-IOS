//
//  SendObject.swift
//  Skurring
//
//  Created by Daniel Bornstedt on 20.02.2017.
//  Copyright © 2017 Appzelof. All rights reserved.
//s

import Foundation
import CoreData

func lagTommeObjekterTilMainScreenRadioObjectsHvisArrayenErTom(context: NSManagedObjectContext) -> [Radiostations] {
    
    
    
    let knappNummer0 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 0)
    let knappNummer1 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 1)
    let knappNummer2 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 2)
    let knappNummer3 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 3)
    let knappNummer4 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 4)
    let knappNummer5 = MainScreenRadioObjects.init(image: UIImage(), URL: "", radioInfo: "", radioSpot: 5)
    
    let coreDataObject0 = Radiostations.init(radioRequestedToSave: knappNummer0, radioImageRequestedToSave: UIImage(), context: context)
    let coreDataObject1 = Radiostations.init(radioRequestedToSave: knappNummer1, radioImageRequestedToSave: UIImage(), context: context)
    let coreDataObject2 = Radiostations.init(radioRequestedToSave: knappNummer2, radioImageRequestedToSave: UIImage(), context: context)
    let coreDataObject3 = Radiostations.init(radioRequestedToSave: knappNummer3, radioImageRequestedToSave: UIImage(), context: context)
    let coreDataObject4 = Radiostations.init(radioRequestedToSave: knappNummer4, radioImageRequestedToSave: UIImage(), context: context)
    let coreDataObject5 = Radiostations.init(radioRequestedToSave: knappNummer5, radioImageRequestedToSave: UIImage(), context: context)
    
    return [coreDataObject0, coreDataObject1, coreDataObject2, coreDataObject3, coreDataObject4, coreDataObject5]
}

class SendObject{
    
    private var _radioNumber: Int!
    private var _image: NSData!
    private var _URL: String!
    private var _radioInfo: String!
    
    var radioNumber: Int {
        return _radioNumber
    }
    
    var image: NSData {
        return _image
    }
    
    var URL: String{
        return _URL
    }
    
    var radioInfo: String{
        return _radioInfo
    }
    
    init(image: NSData, URL: String, radioInfo: String, radioNumber: Int) {
        self._radioNumber = radioNumber
        self._image = image
        self._URL = URL
        self._radioInfo = radioInfo
    }
    
    
}
