//
//  WeatherView.swift
//  skurring
//
//  Created by Daniel Bornstedt on 03/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import Combine

class WeatherView: UIView {

    private lazy var tempLabel: UILabel = makeTempLabel()
    private lazy var weatherImageView: UIImageView = makeWeatherLabel()

    private var weatherViewProvider: WeatherViewProvider?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIPrerequisits()
        [tempLabel, weatherImageView].forEach(addSubview)
        addConstraints()

        weatherViewProvider = WeatherViewProvider(
            tempLabel: tempLabel,
            weatherImageView: weatherImageView
        )
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit { weatherViewProvider = nil }

    private func makeTempLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }

    private func makeWeatherLabel() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        return imageView
    }

    private func setupUIPrerequisits() {
        translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addConstraints() {
        NSLayoutConstraint.activate(
            [

                weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                weatherImageView.topAnchor.constraint(equalTo: topAnchor),
                weatherImageView.bottomAnchor.constraint(equalTo: tempLabel.topAnchor, constant: -10),

                tempLabel.heightAnchor.constraint(equalToConstant: 20),
                tempLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                tempLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
            ]
        )
    }
}
