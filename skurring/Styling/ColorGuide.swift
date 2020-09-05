//
//  ColorGuide.swift
//  skurring
//
//  Created by Daniel Bornstedt on 22/07/2019.
//  Copyright © 2019 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

protocol ColorGuide {
    var backgroundColor: UIColor { get }
    var orangeTheme: UIColor { get }
    var textColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
    var skurringTheme: UIColor { get }
}
