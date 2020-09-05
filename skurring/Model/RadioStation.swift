//
//  RadioChannel.swift
//  skurring
//
//  Created by Daniel Bornstedt on 23/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

struct RadioStation: Decodable {
    var imageURL: String?
    var name: String?
    var radioCountry: String?
    var radioURL: String?
    var radioHQURL: String?
}

struct RadioObject {
    var buttonTag: Int
    var image: UIImage
    var name: String
    var radioCountry: String
    var radioURL: String
    var radioHQURL: String
}
