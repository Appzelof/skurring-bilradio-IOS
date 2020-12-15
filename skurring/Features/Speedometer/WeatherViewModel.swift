//
//  WeatherViewModel.swift
//  skurring
//
//  Created by Daniel Bornstedt on 05/09/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//

import UIKit
import Combine

final class WeatherViewModel {

    var dataSubject = PassthroughSubject<WeatherData, Never>()

    private var cancellable = Set<AnyCancellable>()

    struct WeatherData {
        let temperature: String?
        let image: UIImage?

        init(metForecast: METForecast) {
            let timeSeriesData = metForecast.properties.timeSeries.first?.data
            let symbolCode = [timeSeriesData?.nextOneHour?.summary.symbolCode].compactMap { $0 }

            self.temperature = timeSeriesData?.instant.details?.airTemperature.map { $0.description + "º" }

            #warning("This needs a fallback to a local image")
            self.image = UIImage(named: symbolCode.joined())
        }
    }

    init() {
        NotificationCenter.default.publisher(for: .coordinates)
            .map { $0.userInfo as? [LocationKeys: [Float]] }
            .replaceNil(with: [:])
            .map { [weak self] location -> URL? in
                guard let self = self else { return nil }

                guard
                    let lat = location[.coordinates]?.first,
                    let lon = location[.coordinates]?.last
                else { return nil }

                return self.composeURL(latitude: lat, longitude: lon)
            }
            .sink(receiveValue: fetchWeather(url:))
            .store(in: &cancellable)
    }

    private func composeURL(latitude: Float, longitude: Float) -> URL? {
        //Only 4 digit decimals
        let format = "%.4f"

        let lat = String(format: format, latitude)
        let lon = String(format: format, longitude)

        let completeURLString = "https://api.met.no/weatherapi/locationforecast/2.0/complete.json?lat=" + lat + "&lon=" + lon

        guard let url = URL(string: completeURLString) else { return nil }

        return url
    }

    private func fetchWeather(url: URL?) {
        guard let url = url else { return }
        NetworkManager.shared.fetch(url: url, model: METForecast.self)
            .map(WeatherData.init)
            .sink { completion in
                switch completion {
                case .failure(let error): print(error)
                case .finished: break
                }
            } receiveValue: { self.dataSubject.send($0) }
            .store(in: &cancellable)
    }
}
