//
//  MyCustomPinAnnotation.swift
//  Skurring
//
//  Created by Marius Fagerhol on 21/10/2018.
//  Copyright © 2018 Appzelof. All rights reserved.
//

import UIKit
import MapKit

class MyCustomPinAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    
}
