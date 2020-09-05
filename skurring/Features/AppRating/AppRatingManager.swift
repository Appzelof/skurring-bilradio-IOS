//
//  AppRatingManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/01/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import StoreKit

class AppRatingManager {

    static let shared = AppRatingManager()
    private let minimumLaunchCount = 5
    private let launchKey = "launched"

    func handleSKStoreReview() {
        incrementLaunchCount()
        if
            AppEnvironmentHelper.currentEnvironment == .appstore,
            launchCount == minimumLaunchCount {
            SKStoreReviewController.requestReview()
        }
    }

    private var launchCount: Int {
        set { UserDefaults().set(newValue, forKey: launchKey) }
        get { UserDefaults().integer(forKey: launchKey) }
    }

    private func incrementLaunchCount() {
        launchCount += 1
    }
}
