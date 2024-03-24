//
//  WeatherResult.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

struct WeatherResult: Decodable {

    let current: CurrentWeather
    let daily: DailyWeather

}

struct CurrentWeather: Decodable {

    let temperature2m: Double?
    let apparentTemperature: Double?
    let weatherCode: Int?
    let rain: Double?
    let showers: Double?
    let snowfall: Double?
    let windSpeed10m: Double?

    enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
        case rain
        case showers
        case snowfall
        case windSpeed10m = "wind_speed_10m"
    }
}

struct DailyWeather: Decodable {

    let time: [String]?
    let weatherCode: [Int]?
    let temperature2mMax: [Double]?
    let temperature2mMin: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
    }
}
