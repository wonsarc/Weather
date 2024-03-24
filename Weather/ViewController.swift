//
//  ViewController.swift
//  Weather
//
//  Created by Artem Krasnov on 20.03.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var profileImageListViewObserver: NSObjectProtocol?
    let locationManager = CLLocationManager()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let screenWidth = UIScreen.main.bounds.width
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(screenWidth),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 34, bottom: 17, trailing: 34)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(screenWidth),
                    heightDimension: .fractionalHeight(0.5)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.5)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 34, bottom: 0, trailing: 34)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(screenWidth),
                    heightDimension: .fractionalHeight(0.5)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 7)
                group.interItemSpacing = .fixed(2)

                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named: "AccentBackgroundImage")
        return backgroundImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)

        configureCollectionView()
        configureDataSource()
        WeatherInfoService().fetchWeatherInfo()
        observeDataChanges()

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        locationManager.delegate = self
        checkLocationAuthorization()
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: CurrentWeatherCell.reuseIdent)
        collectionView.register(ShortWeatherCell.self, forCellWithReuseIdentifier: ShortWeatherCell.reuseIdent)
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(
            collectionView: collectionView) {(collectionView, indexPath, _) -> UICollectionViewCell? in
                if indexPath.section == 0 {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CurrentWeatherCell.reuseIdent, for: indexPath
                    ) as? CurrentWeatherCell else {
                        fatalError("Unable to dequeue CurrentWeatherCell")
                    }

                    if let currentWeather = WeatherStorage.cached.saveCurrentWeatherToUserDefaults {
                        cell.configure(with: currentWeather)
                    }
                    cell.delegate = self
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ShortWeatherCell.reuseIdent,
                        for: indexPath) as? ShortWeatherCell else {
                        fatalError("Unable to dequeue ShortWeatherCell")
                    }

                    if let shortWeather = WeatherStorage.cached.saveShortWeatherToUserDefaults,
                       WeatherStorage.cached.saveShortWeatherToUserDefaults?.count != 0 {
                        let weather = shortWeather[indexPath.row]
                        cell.configure(with: weather)
                    }
                    return cell
                }
            }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([0], toSection: 0)
        snapshot.appendItems(Array(1...7), toSection: 1)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func checkLocationAuthorization() {

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Access to location services is denied or restricted.")
        @unknown default:
            break
        }
    }

    func observeDataChanges() {
        profileImageListViewObserver = NotificationCenter.default.addObserver(
            forName: WeatherInfoService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }

                if let newCurrentWeatherData = WeatherStorage.cached.saveCurrentWeatherToUserDefaults,
                   let cell = self.collectionView.cellForItem(
                    at: IndexPath(item: 0, section: 0)) as? CurrentWeatherCell {
                    cell.configure(with: newCurrentWeatherData)
                }

                if let newShortWeatherData = WeatherStorage.cached.saveShortWeatherToUserDefaults {
                    for index in 0..<min(newShortWeatherData.count, 7) {
                        let weather = newShortWeatherData[index]
                        if let cell = self.collectionView.cellForItem(
                            at: IndexPath(item: index, section: 1)
                        ) as? ShortWeatherCell {
                            cell.configure(with: weather)
                        }
                    }
                }

                var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
                snapshot.appendSections([0, 1])
                snapshot.appendItems([0], toSection: 0)
                snapshot.appendItems(Array(1...7), toSection: 1)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
    }
}

// MARK: - CLLocationManagerDelegate

//extension ViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//            checkLocationAuthorization()
//        }
//
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//            guard let location = locations.last else { return }
//
//            saveLocationToUserDefaults(location: location)
//
//            locationManager.stopUpdatingLocation()
//        }
//
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Failed to get location: \(error.localizedDescription)")
//        }
//
//        func saveLocationToUserDefaults(location: CLLocation) {
//            WeatherStorage.cached.userLatitude = location.coordinate.latitude
//            WeatherStorage.cached.userLongitude = location.coordinate.longitude
//            print("Location saved to UserDefaults.")
//        }
//}

extension ViewController: CurrentWeatherCellDelegate {

    func didTapSearchButton(in cell: CurrentWeatherCell) {

        let alertController = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Город"
        }

        let searchAction = UIAlertAction(title: "Поиск", style: .default) { [weak self] _ in
            guard let city = alertController.textFields?.first?.text, !city.isEmpty else {
                return
            }
            self?.performCitySearch(for: city)
        }
        alertController.addAction(searchAction)

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

//    func didTapLocationButton(in cell: CurrentWeatherCell) {
//            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() == .authorizedAlways {
//                locationManager.requestLocation()
//            } else {
//                locationManager.requestWhenInUseAuthorization()
//        }
//    }

    func showCityNotFoundError() {
        let alertController = UIAlertController(title: nil, message: "Город не найден", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }

}

//extension ViewController {
//    func performCitySearch(for city: String) {
//        LocationService().coordinatesFromCity(city: city) { coordinates in
//             if let coordinates = coordinates {
//                 WeatherStorage.cached.userLatitude = coordinates.latitude
//                 WeatherStorage.cached.userLongitude = coordinates.longitude
//                 WeatherInfoService().fetchWeatherInfo()
//                 print("Координаты города \(city): \(coordinates.latitude), \(coordinates.longitude)")
//             } else {
//                 self.showCityNotFoundError()
//                 print("Не удалось найти координаты для города \(city)")
//             }
//         }
//    }
//
//    func showCityNotFoundError() {
//            let alertController = UIAlertController(title: nil, message: "Город не найден", preferredStyle: .alert)
//            present(alertController, animated: true, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                alertController.dismiss(animated: true, completion: nil)
//            }
//        }
//}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        saveLocationToUserDefaults(location: location)

        locationManager.stopUpdatingLocation()

        // Обновляем ячейки после получения новых координат
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
            // Если координаты есть, обновляем ячейки
            fetchWeatherAndUpdateCells()
        } else {
            // Если координат нет, показываем заглушку
            showPlaceholder()
        }
    }

    func fetchWeatherAndUpdateCells() {
        WeatherInfoService().fetchWeatherInfo()
    }

    func showPlaceholder() {
        // Показываем заглушку
        print("Показываем заглушку")
        // Например, можно добавить UIView с текстом "Предоставьте геолокацию"
    }
}

extension ViewController {
    func performCitySearch(for city: String) {
        LocationService().coordinatesFromCity(city: city) { coordinates in
             if let coordinates = coordinates {
                 WeatherStorage.cached.userLatitude = coordinates.latitude
                 WeatherStorage.cached.userLongitude = coordinates.longitude

                 // Обновляем ячейки после получения координат города
                 self.fetchWeatherAndUpdateCells()

                 print("Координаты города \(city): \(coordinates.latitude), \(coordinates.longitude)")
             } else {
                 self.showCityNotFoundError()
                 print("Не удалось найти координаты для города \(city)")
             }
         }
    }
}
