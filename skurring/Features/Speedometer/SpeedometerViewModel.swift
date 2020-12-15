//
//  SpeedometerViewProvider.swift
//  skurring
//
//  Created by Daniel Bornstedt on 05/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class SpeedometerViewModel {

    var attributedSpeedInfoSubject = PassthroughSubject<NSMutableAttributedString?, Never>()

    private var cancellable = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: .kilometersPerHour)
            .map { [weak self] output -> NSMutableAttributedString? in

                guard
                    let self = self,
                    let userData = output.userInfo as? [LocationKeys: String],
                    let kilometers = userData[.kilometersPerHour]?.description
                else { return nil }

                return self.composeAttributedText(with: kilometers)
            }
            .sink { self.attributedSpeedInfoSubject.send($0) }
            .store(in: &cancellable)
    }

    deinit { LocationManager.shared.stopUpdatingLocation() }

    private func composeAttributedText(with info: String) -> NSMutableAttributedString {
        let mutableSpeedInfoText = NSMutableAttributedString()

        let kilometerPerHour = NSAttributedString(
            string: info + "\n", attributes: [NSAttributedString.Key.font: UIFont(name: "Digital dream Fat", size: 150) ?? .italicSystemFont(ofSize: 90)]
        )
        let kilometerPerHourAbbreviation = NSAttributedString(
            string: "km/h", attributes: [NSAttributedString.Key.font : UIFont(name: "Digital dream Narrow", size: 20) ?? .italicSystemFont(ofSize: 20)]
        )

        mutableSpeedInfoText.append(kilometerPerHour)
        mutableSpeedInfoText.append(kilometerPerHourAbbreviation)

        return mutableSpeedInfoText
    }
}
