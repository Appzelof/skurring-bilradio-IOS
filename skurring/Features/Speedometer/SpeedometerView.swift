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

final class SpeedometerView: UIView {

    private lazy var speedLabel: UILabel = createLabel()
    private var speedometerViewProvider: SpeedometerViewProvider?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(speedLabel)
        addConstraints()

        speedometerViewProvider = SpeedometerViewProvider(
            speedLabel: speedLabel
        )
    }

    deinit { speedometerViewProvider = nil }

    private func addConstraints() {
        speedLabel.pinToEdges()
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .green
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

