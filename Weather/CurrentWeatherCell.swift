//
//  CurrentWeatherCell.swift
//  Weather
//
//  Created by Artem Krasnov on 23.03.2024.
//

import UIKit
import CoreLocation

final class CurrentWeatherCell: UICollectionViewCell {

    static let reuseIdent = "CurrentWeatherCell"

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
        temperatureLabel.text = "-14 °"
        temperatureLabel.font = .systemFont(ofSize: 64)
        return temperatureLabel
    }()

    lazy var descriptionCurrentWeatherLabel: UILabel = {
        let descriptionCurrentWeatherLabel = UILabel()
        descriptionCurrentWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCurrentWeatherLabel.textColor = mainColor
        descriptionCurrentWeatherLabel.textAlignment = .center
        descriptionCurrentWeatherLabel.text = "Снег"
        descriptionCurrentWeatherLabel.font = .systemFont(ofSize: 22)
        return descriptionCurrentWeatherLabel
    }()

    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = mainColor
        locationLabel.textAlignment = .center
        locationLabel.text = "Москва"
        locationLabel.font = .systemFont(ofSize: 15)
        return locationLabel
    }()

    lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.textColor = mainColor
        windSpeedLabel.textAlignment = .center
        windSpeedLabel.text = "18.6 м/c"
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
        feelsLikeLabel.text = "Feels like -2"
        feelsLikeLabel.font = .systemFont(ofSize: 15)
        return feelsLikeLabel
    }()

    lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.textColor = mainColor
        searchField.placeholder = " Узнать погоду в .."
        searchField.backgroundColor = secondColor
        searchField.borderStyle = .roundedRect
        searchField.layer.cornerRadius = 5
        return searchField
    }()

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
        addSubview(searchField)
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

            feelsLikeLabel.trailingAnchor.constraint(equalTo: rectangleLabel.leadingAnchor, constant: -20),
            feelsLikeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 35),

            rectangleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rectangleLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 35),

            windSpeedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 10),
            windSpeedLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 35),

            windImageView.widthAnchor.constraint(equalToConstant: 15),
            windImageView.heightAnchor.constraint(equalToConstant: 15),
            windImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 37),
            windImageView.leadingAnchor.constraint(equalTo: rectangleLabel.trailingAnchor, constant: 20),

            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchField.topAnchor.constraint(equalTo: rectangleLabel.bottomAnchor, constant: 40)
        ])
    }

    func configure(with currentWeather: CurrentWeatherModel) {
        weatherImageView.image = UIImage(named: currentWeather.iconWeather ?? "")?.withRenderingMode(.alwaysTemplate)
        temperatureLabel.text = "\(currentWeather.currentTemp ?? "-") °"
        descriptionCurrentWeatherLabel.text = currentWeather.descriptionWeather
        locationLabel.text = currentWeather.locate
        feelsLikeLabel.text = "Ощущается:    \(currentWeather.feelsLikeTemp ?? "-") °"
        windSpeedLabel.text = currentWeather.windSpeedLabel
    }
}

// extension CurrentWeatherCell: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
// }
