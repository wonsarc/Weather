//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Artem Krasnov on 23.03.2024.
//

import UIKit
import CoreLocation

protocol CurrentWeatherCellDelegate: AnyObject {
    func didTapSearchButton(in cell: CurrentWeatherCell)
//    func didTapLocationButton(in cell: CurrentWeatherCell)
}

final class CurrentWeatherCell: UICollectionViewCell {

    static let reuseIdent = "CurrentWeatherCell"
    weak var delegate: CurrentWeatherCellDelegate?

    var mainColor: UIColor = .accent
    var secondColor: UIColor = .accentSecondary

    lazy var todayLabel: UILabel = {
        let todayLabel = UILabel()
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.textColor = mainColor
        todayLabel.textAlignment = .center
        todayLabel.text = "Сегодня"
        todayLabel.font = .systemFont(ofSize: 32)
        return todayLabel
    }()

    lazy var weatherImageView: UIImageView = {
        let weatherImageView = UIImageView()
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.tintColor = mainColor
        return weatherImageView
    }()

    lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textColor = mainColor
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = .systemFont(ofSize: 64)
        return temperatureLabel
    }()

    lazy var descriptionCurrentWeatherLabel: UILabel = {
        let descriptionCurrentWeatherLabel = UILabel()
        descriptionCurrentWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCurrentWeatherLabel.textColor = mainColor
        descriptionCurrentWeatherLabel.textAlignment = .center
        descriptionCurrentWeatherLabel.font = .systemFont(ofSize: 22)
        return descriptionCurrentWeatherLabel
    }()

    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = mainColor
        locationLabel.font = .systemFont(ofSize: 15)
        return locationLabel
    }()

    lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.textColor = mainColor
        windSpeedLabel.textAlignment = .center
        windSpeedLabel.font = .systemFont(ofSize: 15)
        return windSpeedLabel
    }()

    lazy var rectangleLabel: UILabel = {
        let rectangleImageView = UILabel()
        rectangleImageView.translatesAutoresizingMaskIntoConstraints = false
        rectangleImageView.textColor = mainColor
        rectangleImageView.textAlignment = .center
        rectangleImageView.text = "|"
        rectangleImageView.font = .systemFont(ofSize: 15)
        return rectangleImageView
    }()

    lazy var feelsLikeLabel: UILabel = {
        let feelsLikeLabel = UILabel()
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeLabel.textColor = mainColor
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.font = .systemFont(ofSize: 15)
        return feelsLikeLabel
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = mainColor
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

//    lazy var getLocationButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let image = UIImage(systemName: "location")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(image, for: .normal)
//        button.tintColor = mainColor
//        button.addTarget(self, action: #selector(getLocationButtonTapped), for: .touchUpInside)
//        return button
//    }()

    lazy var windImageView: UIImageView = {
        let windImageView = UIImageView()
        windImageView.translatesAutoresizingMaskIntoConstraints = false
        windImageView.image = UIImage(named: "windIcon")?.withRenderingMode(.alwaysTemplate)
        windImageView.backgroundColor = secondColor
        return windImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 35
        backgroundColor =  secondColor.withAlphaComponent(0.95)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(todayLabel)
        addSubview(weatherImageView)
        addSubview(temperatureLabel)
        addSubview(descriptionCurrentWeatherLabel)
        addSubview(locationLabel)
        addSubview(rectangleLabel)
        addSubview(feelsLikeLabel)
        addSubview(windSpeedLabel)
        addSubview(windImageView)
        addSubview(searchButton)
//        addSubview(getLocationButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            todayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            todayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),
            temperatureLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 25),

            weatherImageView.heightAnchor.constraint(equalToConstant: 64),
            weatherImageView.widthAnchor.constraint(equalToConstant: 64),
            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            weatherImageView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 30),

            descriptionCurrentWeatherLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionCurrentWeatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),

            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: descriptionCurrentWeatherLabel.bottomAnchor, constant: 20),

            feelsLikeLabel.trailingAnchor.constraint(equalTo: rectangleLabel.leadingAnchor, constant: -10),
            feelsLikeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),

            rectangleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectangleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),

            windSpeedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 10),
            windSpeedLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),

            windImageView.widthAnchor.constraint(equalToConstant: 15),
            windImageView.heightAnchor.constraint(equalToConstant: 15),
            windImageView.leadingAnchor.constraint(equalTo: rectangleLabel.trailingAnchor, constant: 25),
            windImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 32),

            searchButton.trailingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: -10),
            searchButton.topAnchor.constraint(equalTo: descriptionCurrentWeatherLabel.bottomAnchor, constant: 20)
        ])
    }

    func configure(with currentWeather: CurrentWeatherModel) {
        getCity { city in
            if let city = city {
                self.locationLabel.text = city
            } else {
                self.locationLabel.text = "unknown"
            }
        }
        weatherImageView.image = UIImage(named: currentWeather.iconWeather ?? "")?.withRenderingMode(.alwaysTemplate)
        temperatureLabel.text = "\(currentWeather.currentTemp ?? "-") °"
        descriptionCurrentWeatherLabel.text = currentWeather.descriptionWeather
        feelsLikeLabel.text = "Ощущается:   \(currentWeather.feelsLikeTemp ?? "-") °"
        windSpeedLabel.text = currentWeather.windSpeedLabel
    }

    private func getCity(completion: @escaping (String?) -> Void) {
        guard let latitude = WeatherStorage.cached.userLatitude,
              let longitude = WeatherStorage.cached.userLongitude else {
            completion(nil)
            return
        }

        LocationService().cityFromCoordinates(latitude: latitude, longitude: longitude) { city in
            completion(city)
        }
    }

    @objc func searchButtonTapped() {
        delegate?.didTapSearchButton(in: self)
    }
//
//    @objc func getLocationButtonTapped() {
//        delegate?.didTapLocationButton(in: self)
//    }
}
