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
    private var weatherUri: String = ""
    private var cancellable = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIPrerequisits()
        [tempLabel, weatherImageView].forEach(addSubview)
        addConstraints()

        LocationManager.shared.locationDelegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

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

    private func fetchWeather(uri: String) {
        guard let url = URL(string: uri) else { return }
        NetworkManager.shared.fetch(url: url, model: METForecast.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            }) { [weak self] metForecast in
                guard let self = self else { return }

                let temperature = metForecast.properties.timeSeries.first?.data.instant.details?.airTemperature
                let imageSymbol = metForecast.properties.timeSeries.first?.data.nextOneHour?.summary.symbolCode ?? ""

                self.tempLabel.text = (temperature?.description ?? "") + " Cº"
                self.weatherImageView.image = UIImage(named: imageSymbol)
            }
            .store(in: &cancellable)
    }
}

extension WeatherView: LocationHandlerDelegate {
    func coordinatesDidUpdate(lat: Double, lon: Double) {
        guard weatherImageView.image == nil else { return }
        self.weatherUri = "https://api.met.no/weatherapi/locationforecast/2.0/complete.json?lat=" + "\(lat)" + "&lon=" + "\(lon)"
        print(weatherUri)
        self.fetchWeather(uri: self.weatherUri)
    }
}



