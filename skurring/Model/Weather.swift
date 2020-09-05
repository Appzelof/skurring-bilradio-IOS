//
//  Weather.swift
//  SnapCatch
//
//  Created by Daniel Bornstedt on 04/05/2020.
//  Copyright © 2020 Daniel Bornstedt. All rights reserved.
//
// Modeled after yr´s METForecast model

struct METForecast: Decodable {
    var type: String
    var properties: Forecast
    var geometry: PointGeometry
}

struct Forecast: Decodable {
    var meta: InlineModelZero
    var timeSeries: [ForecastTimeStep]

    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case timeSeries = "timeseries"
    }
}


struct PointGeometry: Decodable {
    var coordinates: [Float]
    var type: String
}

struct InlineModelZero: Decodable {
    var units: ForecastUnits
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case units = "units"
        case updatedAt = "updated_at"
    }
}

struct ForecastTimeStep: Decodable {
    var time: String
    var data: InlineModel
}

struct ForecastUnits: Decodable {

    var windSpeedOfGust: String? //wind_speed_of_gust (string, optional),
    var precipitationAmountMin: String? //precipitation_amount_min (string, optional),
    var dewPointTemperature: String? //dew_point_temperature (string, optional),
    var windFromDirection: String? //wind_from_direction (string, optional),
    var airTemperatureMax: String? //air_temperature_max (string, optional),
    var fogAreaFraction: String? //fog_area_fraction (string, optional),
    var airTemperature: String? //air_temperature (string, optional),
    var windSpeed: String? //wind_speed (string, optional),
    var cloudAreaFractionHigh: String? //cloud_area_fraction_high (string, optional),
    var precipitationAmount: String? //precipitation_amount (string, optional),
    var ultravioletIndexClearSkyMax: String? //ultraviolet_index_clear_sky_max (string, optional),
    var cloudAreaFractionLow: String? // cloud_area_fraction_low (string, optional),
    var airTemperatureMin: String? //air_temperature_min (string, optional),
    var cloudAreaFraction: String? //cloud_area_fraction (string, optional),
    var probabilityOfThunder: String? // probability_of_thunder (string, optional),
    var relativeHumidty: String? //relative_humidity (string, optional),
    var cloudAreaFractionMedium: String? //cloud_area_fraction_medium (string, optional),
    var airPressureAtSeaLevel: String? // air_pressure_at_sea_level (string, optional),
    var probabilityOfPrecipitation: String? //probability_of_precipitation (string, optional),
    var precipitationAmountMax: String? //precipitation_amount_max (string, optional)


    enum CodingKeys: String, CodingKey {

        case windSpeedOfGust = "wind_speed_of_gust"
        case precipitationAmountMin = "precipitation_amount_min"
        case dewPointTemperature = "dew_point_temperature"
        case windFromDirection = "wind_from_direction"
        case airTemperatureMax = "air_temperature_max"
        case fogAreaFraction = "fog_area_fraction"
        case airTemperature = "air_temperature"
        case windSpeed = "wind_speed"
        case cloudAreaFractionHigh = "cloud_area_fraction_high"
        case precipitationAmount = "precipitation_amount"
        case ultravioletIndexClearSkyMax = "ultraviolet_index_clear_sky_max"
        case cloudAreaFractionLow = "cloud_area_fraction_low"
        case airTemperatureMin = "air_temperature_min"
        case cloudAreaFraction = "cloud_area_fraction"
        case probabilityOfThunder = "probability_of_thunder"
        case relativeHumidty = "relative_humidity"
        case cloudAreaFractionMedium = "cloud_area_fraction_medium"
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"
        case probabilityOfPrecipitation = "probability_of_precipitation"
        case precipitationAmountMax = "precipitation_amount_max"
    }


}

struct InlineModel: Decodable {
    var nextSixHours: InlineModelOne?
    var nextOneHour: InlineModelTwo?
    var instant: InlineModelThree

    enum CodingKeys: String, CodingKey {
        case nextSixHours = "next_6_hours"
        case nextOneHour = "next_1_hours"
        case instant = "instant"
    }
}

struct InlineModelOne: Decodable {
    var details: ForecastTimePeriod
    var summary: ForecastSummary
}

struct InlineModelTwo: Decodable {
    var details: ForecastTimePeriod
    var summary: ForecastSummary
}

struct InlineModelThree: Decodable {
    var details: ForecastTimeInstant?
}

struct ForecastTimePeriod: Decodable {
    var airTemperatureMax: Float? //Maximum air temperature in period ,
    var airTemperatureMin: Float? //Minimum air temperature in period ,
    var probabilityOfThunder: Float? //Probability of any thunder coming for this period ,
    var precipitationAmountMin: Float? //Minimum amount of precipitation for this period ,
    var precipitationAmount: Float? //Best estimate for amount of precipitation for this period ,
    var precipitationAmountMax: Float? //Maximum amount of precipitation for this period ,
    var ultravioletIndexClearSkyMax: Float? //Maximum ultraviolet index if sky is clear ,
    var probabilityOfPrecipitation: Float? //Probability of any precipitation coming for this period

    enum CodingKeys: String, CodingKey {
        case airTemperatureMin = "air_temperature_min"
        case precipitationAmountMin = "precipitation_amount_min"
        case airTemperatureMax = "air_temperature_max"
        case ultravioletIndexClearSkyMax = "ultraviolet_index_clear_sky_max"
        case precipitationAmountMax = "precipitation_amount_max"
        case probabilityOfThunder = "probability_of_thunder"
        case precipitationAmount = "precipitation_amount"
        case probabilityOfPrecipitation = "probability_of_precipitation"
    }
}

struct ForecastSummary: Decodable {
    var symbolCode: String

    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbolCode = try container.decodeIfPresent(String.self, forKey: .symbolCode) ?? ""
    }
}

struct ForecastTimeInstant: Decodable {
    var windSpeed: Float? //Speed of wind ,
    var airTemperature: Float? //Air temperature ,
    var airPressureAtSeaLevel: Float? //Air pressure at sea level ,
    var cloudAreaFractionHigh: Float? //Amount of sky covered by clouds at high elevation. ,
    var cloudAreaFraction: Float? //Amount of sky covered by clouds. ,
    var windSpeedOfGust: Float? //Speed of wind gust ,
    var cloudAreaFractionLow: Float? //Amount of sky covered by clouds at low elevation. ,
    var cloudAreaFractionMedium: Float? //Amount of sky covered by clouds at medium elevation. ,
    var fogAreaFraction: Float? //Amount of area covered by fog.
    var dewPointTemperature: Float? //Dew point temperature at sea level
    var windFromDirection: Float? //The directon which moves towards
    var relativeHimidity: Float? //Amount of humidity in the air.

    enum CodingKeys: String, CodingKey {
        case cloudAreaFractionHigh = "cloud_area_fraction_high"
        case cloudAreaFraction = "cloud_area_fraction"
        case windSpeedOfGust =  "wind_speed_of_gust"
        case cloudAreaFractionLow = "cloud_area_fraction_low"
        case cloudAreaFractionMedium = "cloud_area_fraction_medium"
        case dewPointTemperature = "dew_point_temperature"
        case fogAreaFraction = "fog_area_fraction"
        case windFromDirection = "wind_from_direction"
        case relativeHimidity = "relative_humidity"
        case windSpeed = "wind_speed"
        case airTemperature = "air_temperature"
        case airPressureAtSeaLevel = "air_pressure_at_sea_level"

    }
}

