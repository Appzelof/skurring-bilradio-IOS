//
//  Notification+Extensions.swift
//  skurring
//
//  Created by Daniel Bornstedt on 06/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let kilometersPerHour = Notification.Name("KilometersPerHour")
    static let coordinates = Notification.Name("Coordinates")

    static let applicationDidBecomeActive = Notification.Name("applicationDidBecomeActive")
}
