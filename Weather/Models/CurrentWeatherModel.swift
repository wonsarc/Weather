//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

struct CurrentWeatherModel: Codable {

    let currentTemp: String?
    let iconWeather: String?
    let descriptionWeather: String?
    let feelsLikeTemp: String?
    let windSpeedLabel: String?
}
