//
//  WeatherStorage.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

private enum Keys: String {
    case cachedShortWeather
    case cachedCurrentWeather
}

final class WeatherStorage {

    // MARK: - Public Properties

    static let cached = WeatherStorage()

    var saveCurrentWeatherToUserDefaults: CurrentWeatherModel? {
        get {
            if let savedData = UserDefaults.standard.data(forKey: Keys.cachedCurrentWeather.rawValue) {
                let decoder = JSONDecoder()
                do {
                    let decodedWeather = try decoder.decode(CurrentWeatherModel.self, from: savedData)
                    return decodedWeather
                } catch {
                    print("Failed to decode saved weather data:", error)
                    return nil
                }
            }
            return nil
        }

        set {
            let encoder = JSONEncoder()
            do {
                let encodedData = try encoder.encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: Keys.cachedCurrentWeather.rawValue)
            } catch {
                print("Failed to encode weather data:", error)
            }
        }
    }

    var saveShortWeatherToUserDefaults: [ShortWeatherModel]? {
        get {
            if let savedData = UserDefaults.standard.data(forKey: Keys.cachedShortWeather.rawValue) {
                let decoder = JSONDecoder()
                do {
                    let decodedWeather = try decoder.decode([ShortWeatherModel].self, from: savedData)
                    return decodedWeather
                } catch {
                    print("Failed to decode saved weather data:", error)
                    return nil
                }
            }
            return nil
        }

        set {
            let encoder = JSONEncoder()
            do {
                let encodedData = try encoder.encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: Keys.cachedShortWeather.rawValue)
            } catch {
                print("Failed to encode weather data:", error)
            }
        }
    }

    // MARK: - Initializers

    private init() {}
}
