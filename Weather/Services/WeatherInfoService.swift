//
//  WeatherInfoService.swift
//  Weather
//
//  Created by Artem Krasnov on 24.03.2024.
//

import Foundation

protocol WeatherInfoServiceProtocol {
    //    var photos: [Photo] { get }
    //
    //    func fetchPhotosNextPage()
    //    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class WeatherInfoService: WeatherInfoServiceProtocol {

    // MARK: - Public Properties

    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    // MARK: - Private Properties

    private let baseURL = "https://api.open-meteo.com/v1/forecast"
    private let latitude = 52.52
    private let longitude = 13.41
    private let currentFields = [
        "temperature_2m",
        "apparent_temperature",
        "precipitation",
        "rain",
        "showers",
        "snowfall",
        "weather_code",
        "cloud_cover",
        "wind_speed_10m"
    ].joined(separator: ",")
    private let dailyFields = "weather_code,temperature_2m_max,temperature_2m_min"
    private let timezone = "auto"
    private let forecastDays = 8
    private let networkClient = NetworkClient()
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    private var task: URLSessionTask?
    private (set) var weatherInfo: WeatherResult?

    // MARK: - Public Methods

    func fetchWeatherInfo() {
        assert(Thread.isMainThread)
        if task != nil {
            //            if lastLoadedPage == photos.count / perPage {
            //                task?.cancel()
            //            } else {
            //                return
            //            }
            return
        }

        let queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: currentFields),
            URLQueryItem(name: "daily", value: dailyFields),
            URLQueryItem(name: "timezone", value: timezone),
            URLQueryItem(name: "forecast_days", value: String(forecastDays))
        ]

        let url = networkClient.createURL(
            url: baseURL,
            queryItems: queryItems
        )

        let request = networkClient.createRequest(
            url: url,
            httpMethod: .GET
        )
        task = createWeatherTask(request: request)
        task?.resume()

    }

    // MARK: - Private Methods

    private func createNotification() {
        NotificationCenter.default
            .post(
                name: WeatherInfoService.didChangeNotification,
                object: self,
                userInfo: nil
            )
    }

    private func createWeatherTask(request: URLRequest) -> URLSessionTask? {
        return urlSession.objectTask(
            for: request,
            completion: { (result: Result<WeatherResult, Error>) in
                print(request)
                //                guard let self = self else { return }
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let weatherInfo):
                        createCurrentWeather(from: weatherInfo)
                        createShortWeather(from: weatherInfo)

                        self.createNotification()
                    case .failure(let error):
                        print(error)
                    }
                }
            })
    }

    private func createCurrentWeather(from weatherInfo: WeatherResult) {

        var currentTemp: String?
        var feelsLikeTemp: String?

        if let temp = weatherInfo.current.temperature2m {
            currentTemp = Int(temp.rounded()).description
        }

        if let temp = weatherInfo.current.apparentTemperature {
            feelsLikeTemp = Int(temp.rounded()).description
        }

        if let temp = weatherInfo.current.apparentTemperature {
            feelsLikeTemp = Int(temp.rounded()).description
        }

        let weatherCode = weatherInfo.current.weatherCode ?? -1
        let descriptionWeather = WeatherCodeModel(rawValue: weatherCode)?.description

        WeatherStorage.cached.saveCurrentWeatherToUserDefaults = CurrentWeatherModel(
            currentTemp: currentTemp,
            iconWeather: "01_sun_line",
            descriptionWeather: descriptionWeather,
            locate: "Москва",
            feelsLikeTemp: feelsLikeTemp,
            windSpeedLabel: "\(weatherInfo.current.windSpeed10m ?? 0) km/h"
        )
    }

    private func createShortWeather(from weatherInfo: WeatherResult) {
        var shortWeatherModels: [ShortWeatherModel] = []
        let dailyWeather = weatherInfo.daily

        guard let time = dailyWeather.time,
              let weatherCode = dailyWeather.weatherCode,
              let minTemps = dailyWeather.temperature2mMin,
              let maxTemps = dailyWeather.temperature2mMax,
              !time.isEmpty,
              time.count == weatherCode.count,
              time.count == minTemps.count,
              time.count == maxTemps.count else {
            return
        }

        for index in 0..<time.count {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: time[index]) {
                dateFormatter.locale = Locale(identifier: "ru")
                dateFormatter.dateFormat = "EEEE"
                let dayOfWeek = dateFormatter.string(from: date).capitalized

                let iconWeather = "01_sun_line"
                let minTemp = Int(minTemps[index].rounded()).description
                let maxTemp = Int(maxTemps[index].rounded()).description
                let shortWeatherModel = ShortWeatherModel(
                    day: dayOfWeek,
                    iconWeather: iconWeather,
                    minTemp: minTemp,
                    maxTemp: maxTemp
                )

                shortWeatherModels.append(shortWeatherModel)
            }
        }

        WeatherStorage.cached.saveShortWeatherToUserDefaults = shortWeatherModels
    }
}
