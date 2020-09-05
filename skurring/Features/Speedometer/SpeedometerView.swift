//
//  LocationManager.swift
//  skurring
//
//  Created by Daniel Bornstedt on 20/04/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


//TODO: - Location logic needs to come from an own class.
class SpeedometerView: UIView {

    private lazy var speedLabel: UILabel = createLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(speedLabel)
        addConstraints()

        LocationManager.shared.locationDelegate = self
    }

    private func addConstraints() {
        speedLabel.pinToEdges()
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.numberOfLines = 2
        label.attributedText = createMutableText(with: "0")
        return label
    }

    deinit {
        LocationManager.shared.stopUpdatingLocation()
        LocationManager.shared.locationDelegate = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createMutableText(with info: String) -> NSMutableAttributedString {
        let mutableSpeed = NSMutableAttributedString()

        let speedAttribute = NSAttributedString(
            string: info + "\n", attributes: [NSAttributedString.Key.font: UIFont(name: "Digital dream Fat", size: 60) ?? .italicSystemFont(ofSize: 50)]
        )
        let kilometerAttribute = NSAttributedString(
            string: "km/h", attributes: [NSAttributedString.Key.font : UIFont(name: "Digital dream Narrow", size: 15) ?? .italicSystemFont(ofSize: 10)]
        )

        mutableSpeed.append(speedAttribute)
        mutableSpeed.append(kilometerAttribute)

        return mutableSpeed
    }
}

extension SpeedometerView: LocationHandlerDelegate {
    func speedDidUpdate(speed: String) {
        speedLabel.attributedText = createMutableText(with: speed)
    }
}

