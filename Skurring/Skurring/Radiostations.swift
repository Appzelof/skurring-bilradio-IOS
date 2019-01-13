//
//  SavedRadioStations.swift
//  Skurring
//
//  Created by Marius Fagerhol on 12/01/2019.
//  Copyright © 2019 Appzelof. All rights reserved.
//

import UIKit
import CoreData

@objc(Radiostations)
class Radiostations: NSManagedObject {
    
    convenience init(radioRequestedToSave: MainScreenRadioObjects, radioImageRequestedToSave: UIImage, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Radiostations", in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.radioStream = radioRequestedToSave.URL
        self.radioInfo = radioRequestedToSave.radioInfo
        self.radioSpot = Int32(radioRequestedToSave.radioSpot)
        
        let imageData = UIImagePNGRepresentation(radioImageRequestedToSave)
        if imageData != nil {
            self.radioImage = imageData! as NSData
        }
    }
    
}
