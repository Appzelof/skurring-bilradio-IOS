//
//  WeatherViewModel.swift
//  skurring
//
//  Created by Daniel Bornstedt on 05/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import Foundation
import UIKit
import Combine

class WeatherViewProvider {
    private weak var tempLabel: UILabel?
    private weak var weatherImageView: UIImageView?
    
    private var cancellable = Set<AnyCancellable>()

    init(tempLabel: UILabel, weatherImageView: UIImageView) {
        self.tempLabel = tempLabel
        self.weatherImageView = weatherImageView

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateWeather),
            name: .coordinates,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .coordinates,
            object: self
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

                self.tempLabel!.text = (temperature?.description ?? "") + "º"
                self.weatherImageView!.image = UIImage(named: imageSymbol)
            }
            .store(in: &cancellable)
    }

    private func createWeatherURI(latitude: Double, longitude: Double) -> String {
        return "https://api.met.no/weatherapi/locationforecast/2.0/complete.json?lat=" + "\(latitude)" + "&lon=" + "\(longitude)"
    }

    @objc
    private func updateWeather(notification: Notification) {
        guard
            weatherImageView!.image == nil,
            let coordinatesDict = notification.userInfo as? [LocationKeys: [Double]],
            let coordinates = coordinatesDict[.coordinates],
            let latitude = coordinates.first,
            let longitude = coordinates.last
        else { return }
        fetchWeather(uri: createWeatherURI(latitude: latitude, longitude: longitude))
    }
}
