//
//  ShortWeatherModel.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

struct ShortWeatherModel: Codable {

    let day: String?
    let iconWeather: String?
    let minTemp: String?
    let maxTemp: String?
}
