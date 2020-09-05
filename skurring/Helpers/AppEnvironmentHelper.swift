//
//  AppEnvironmentHelper.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/01/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation

enum AppEnvironment {
    case debug
    case appstore
}

struct AppEnvironmentHelper {
    private static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    static var currentEnvironment: AppEnvironment {
        if isDebug {
            return .debug
        } else {
            return .appstore
        }
    }
}
