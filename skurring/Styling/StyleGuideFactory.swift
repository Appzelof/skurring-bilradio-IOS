//
//  Styling.swift
//  skurring
//
//  Created by Daniel Bornstedt on 15/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

struct StyleGuideFactory {
    static var current: StyleGuide {
        return DarkStyleGuide()
    }
}

protocol StyleGuide {
    var colors: ColorGuide { get }
}

struct DarkStyleGuide: StyleGuide {
    var colors: ColorGuide = DarkColorGuide()
}
