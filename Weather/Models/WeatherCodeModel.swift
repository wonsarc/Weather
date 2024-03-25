//
//  WeatherInterpretationCodesModel.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

enum WeatherCodeModel: Int {

    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case freezingDrizzleLight = 56
    case freezingDrizzleDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case freezingRainLight = 66
    case freezingRainHeavy = 67
    case snowFallSlight = 71
    case snowFallModerate = 73
    case snowFallHeavy = 75
    case snowGrains = 77
    case rainShowersSlight = 80
    case rainShowersModerate = 81
    case rainShowersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderstormSlight = 95
    case thunderstormModerate = 96
    case thunderstormHail = 99
    case unknown = -1

    var description: String {

        switch self {
        case .clearSky:
            return "Ясное небо"
        case .mainlyClear:
            return "В основном ясно"
        case .partlyCloudy:
            return "Переменная облачность"
        case .overcast:
            return "Пасмурно"
        case .fog:
            return "Туман"
        case .drizzleLight:
            return "Морось: слабая"
        case .drizzleModerate:
            return "Морось: умеренная"
        case .drizzleDense:
            return "Морось: сильная"
        case .rainSlight, .rainShowersSlight:
            return "Дождь: слабый"
        case .rainModerate, .rainShowersModerate:
            return "Дождь: умеренный"
        case .rainHeavy, .rainShowersViolent:
            return "Дождь: сильный"
        case .freezingRainLight, .freezingDrizzleLight:
            return "Ледяной дождь: слабый"
        case .freezingRainHeavy, .freezingDrizzleDense:
            return "Ледяной дождь: сильный"
        case .snowFallSlight, .snowShowersSlight:
            return "Снегопад: слабый"
        case .snowFallModerate:
            return "Снегопад: умеренный"
        case .snowFallHeavy, .snowShowersHeavy:
            return "Снегопад: сильный"
        case .snowGrains:
            return "Снежные зерна"
        case .thunderstormSlight:
            return "Гроза: слабая"
        case .thunderstormModerate:
            return "Гроза: умеренная"
        case .thunderstormHail:
            return "Гроза с градом"
        case .unknown:
            return "-"
        }
    }
}

extension WeatherCodeModel {

    func imageName() -> String {
        switch self {
        case .clearSky, .mainlyClear:
            return "clear_sun"
        case .partlyCloudy, .overcast:
            return "cloud"
        case .fog:
            return "fog"
        case .drizzleLight, .rainSlight:
            return "drizzle_light"
        case .drizzleModerate, .rainModerate:
            return "drizzle_moderate"
        case .drizzleDense, .rainHeavy:
            return "drizzle_heavy"
        case .freezingDrizzleLight, .freezingRainLight:
            return "snow_drizzle_light"
        case .freezingDrizzleDense, .freezingRainHeavy:
            return "snow_drizzle_heavy"
        case .snowFallSlight, .snowShowersSlight:
            return "snow_lite"
        case .snowFallModerate:
            return "snow_moderate"
        case .snowFallHeavy, .snowShowersHeavy:
            return "snow_heavy"
        case .snowGrains:
            return "snow_grains"
        case .rainShowersSlight, .rainShowersViolent:
            return "rain"
        case .rainShowersModerate:
            return "rain_moderate"
        case .thunderstormSlight, .thunderstormModerate:
            return "lightning"
        case .thunderstormHail:
            return "thunderstorm"
        case .unknown:
            return "na"
        }
    }
}
