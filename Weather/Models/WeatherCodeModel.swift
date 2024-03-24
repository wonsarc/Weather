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
            return "Морось: легкая интенсивность"
        case .drizzleModerate:
            return "Морось: умеренная интенсивность"
        case .drizzleDense:
            return "Морось: высокая интенсивность"
        case .freezingDrizzleLight:
            return "Замерзающая морось: легкая интенсивность"
        case .freezingDrizzleDense:
            return "Замерзающая морось: высокая интенсивность"
        case .rainSlight:
            return "Дождь: слабая интенсивность"
        case .rainModerate:
            return "Дождь: умеренная интенсивность"
        case .rainHeavy:
            return "Дождь: сильная интенсивность"
        case .freezingRainLight:
            return "Ледяной дождь: легкая интенсивность"
        case .freezingRainHeavy:
            return "Ледяной дождь: высокая интенсивность"
        case .snowFallSlight:
            return "Снегопад: слабая интенсивность"
        case .snowFallModerate:
            return "Снегопад: умеренная интенсивность"
        case .snowFallHeavy:
            return "Снегопад: сильная интенсивность"
        case .snowGrains:
            return "Снежные зерна"
        case .rainShowersSlight:
            return "Дождь с прояснениями: слабая интенсивность"
        case .rainShowersModerate:
            return "Дождь с прояснениями: умеренная интенсивность"
        case .rainShowersViolent:
            return "Дождь с прояснениями: сильная интенсивность"
        case .snowShowersSlight:
            return "Снег с прояснениями: слабая интенсивность"
        case .snowShowersHeavy:
            return "Снег с прояснениями: сильная интенсивность"
        case .thunderstormSlight:
            return "Гроза: слабая интенсивность"
        case .thunderstormModerate:
            return "Гроза: умеренная интенсивность"
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
