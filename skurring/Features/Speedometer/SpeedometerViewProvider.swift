//
//  SpeedometerViewProvider.swift
//  skurring
//
//  Created by Daniel Bornstedt on 05/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit

class SpeedometerViewProvider {
    private weak var speedLabel: UILabel?

    init(speedLabel: UILabel) {
        self.speedLabel = speedLabel
        self.speedLabel?.attributedText = createAttributedKPH(with: 0.description)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSpeed),
            name: .kilometersPerHour,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .kilometersPerHour,
            object: nil
        )

        LocationManager.shared.stopUpdatingLocation()

        print("deinit")
    }

    private func createAttributedKPH(with info: String) -> NSMutableAttributedString {
        let mutableSpeed = NSMutableAttributedString()

        let speedAttribute = NSAttributedString(
            string: info + "\n", attributes: [NSAttributedString.Key.font: UIFont(name: "Digital dream Fat", size: 50) ?? .italicSystemFont(ofSize: 50)]
        )
        let kilometerAttribute = NSAttributedString(
            string: "km/h", attributes: [NSAttributedString.Key.font : UIFont(name: "Digital dream Narrow", size: 15) ?? .italicSystemFont(ofSize: 10)]
        )

        mutableSpeed.append(speedAttribute)
        mutableSpeed.append(kilometerAttribute)

        return mutableSpeed
    }

    @objc
    private func updateSpeed(notification: Notification) {
        guard
            let dictionary = notification.userInfo as? [LocationKeys: String],
            let kilometersPerHour = dictionary[.kilometersPerHour]?.description
        else { return }

        speedLabel?.attributedText = createAttributedKPH(with: kilometersPerHour)
    }
}
