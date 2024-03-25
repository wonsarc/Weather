//
//  WeatherViewPresenter.swift
//  Weather
//
//  Created by Artem Krasnov on 25.03.2024.
//

import CoreLocation

protocol WeatherViewPresenterProtocol {

    var view: WeatherViewControllerProtocol? {get set}

    func startLocationUpdates()
    func didTapSearchButton()
    func observeDataChanges()
    func performCitySearch(for city: String)
    func showCityNotFoundErrorAlert()
    func showSearchAlert(completion: @escaping (String?) -> Void)
}

final class WeatherViewPresenter: NSObject, WeatherViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: WeatherViewControllerProtocol?
    var profileImageListViewObserver: NSObjectProtocol?
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Private Properties

    private var currentCompletion: ((String?) -> Void)?

    // MARK: - Public Methods

    func performCitySearch(for city: String) {
        LocationService().coordinatesFromCity(city: city) { coordinates in
            if let coordinates = coordinates {
                WeatherStorage.cached.userLatitude = coordinates.latitude
                WeatherStorage.cached.userLongitude = coordinates.longitude

                self.fetchWeatherAndUpdateCells()
                print("Координаты города \(city): \(coordinates.latitude), \(coordinates.longitude)")
            } else {
                self.showCityNotFoundErrorAlert()
                print("Не удалось найти координаты для города \(city)")
            }
        }
    }

    func observeDataChanges() {
        profileImageListViewObserver = NotificationCenter.default.addObserver(
            forName: WeatherInfoService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateCell()
            }
    }

    func startLocationUpdates() {
        checkLocationAuthorization()
    }

    func didTapSearchButton() {
        showSearchAlert { [weak self] city in
            guard let city = city, !city.isEmpty else { return }
            self?.performCitySearch(for: city)
        }
    }

    func showCityNotFoundErrorAlert() {
        view?.showCityNotFoundError()
    }

    func showSearchAlert(completion: @escaping (String?) -> Void) {
        currentCompletion = completion
        view?.showSearchAlert()
    }

    // MARK: - Private Methods

    private func checkLocationAuthorization() {
        switch CLLocationManager().authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Доступ к геолокации запрещен или ограничен.")
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewPresenter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        saveLocationToUserDefaults(location: location)

        locationManager.stopUpdatingLocation()

        updateCells()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }

    func saveLocationToUserDefaults(location: CLLocation) {
        WeatherStorage.cached.userLatitude = location.coordinate.latitude
        WeatherStorage.cached.userLongitude = location.coordinate.longitude
        print("Location saved to UserDefaults.")
    }

    func updateCells() {
        if WeatherStorage.cached.userLatitude != nil && WeatherStorage.cached.userLongitude != nil {
            fetchWeatherAndUpdateCells()
        } else {
            showPlaceholder()
        }
    }

    func fetchWeatherAndUpdateCells() {
        WeatherInfoService().fetchWeatherInfo()
    }

    func showPlaceholder() {
        print("Показываем заглушку") // todo
    }
}
