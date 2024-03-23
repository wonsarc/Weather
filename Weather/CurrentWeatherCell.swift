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

    let col = UIColor(red: 228/255.0, green: 241/255.0, blue: 249/255.0, alpha: 1.0)

    lazy var todayLabel: UILabel = {
        let todayLabel = UILabel()
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.textColor = col
        todayLabel.textAlignment = .center
        todayLabel.text = "Сегодня"
        todayLabel.font = .systemFont(ofSize: 32)
        return todayLabel
    }()

    lazy var weatherImageView: UIImageView = {
        let weatherImageView = UIImageView()
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.image = UIImage(named: "Cloudy")
        return weatherImageView
    }()

    lazy var temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textColor = col
        temperatureLabel.textAlignment = .center
        temperatureLabel.text = "-14 °"
        temperatureLabel.font = .systemFont(ofSize: 64)
        return temperatureLabel
    }()

    lazy var descriptionCurrentWeatherLabel: UILabel = {
        let descriptionCurrentWeatherLabel = UILabel()
        descriptionCurrentWeatherLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionCurrentWeatherLabel.textColor = col
        descriptionCurrentWeatherLabel.textAlignment = .center
        descriptionCurrentWeatherLabel.text = "Снег"
        descriptionCurrentWeatherLabel.font = .systemFont(ofSize: 22)
        return descriptionCurrentWeatherLabel
    }()

    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = col
        locationLabel.textAlignment = .center
        locationLabel.text = "Москва"
        locationLabel.font = .systemFont(ofSize: 15)
        return locationLabel
    }()

    lazy var windSpeedLabel: UILabel = {
        let windSpeedLabel = UILabel()
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.textColor = col
        windSpeedLabel.textAlignment = .center
        windSpeedLabel.text = "18.6 м/c"
        windSpeedLabel.font = .systemFont(ofSize: 15)
        return windSpeedLabel
    }()

    lazy var rectangleImageView: UIImageView = {
        let rectangleImageView = UIImageView()
        rectangleImageView.translatesAutoresizingMaskIntoConstraints = false
        rectangleImageView.image = UIImage(named: "Rectangle")
        rectangleImageView.image?.withTintColor(col)
        return rectangleImageView
    }()

    lazy var feelsLikeLabel: UILabel = {
        let feelsLikeLabel = UILabel()
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeLabel.textColor = col
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.text = "Feels like -2"
        feelsLikeLabel.font = .systemFont(ofSize: 15)
        return feelsLikeLabel
    }()

    lazy var searchField: UITextField = {
        let searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.textColor = col
        searchField.placeholder = " Узнать погоду в .."
        searchField.backgroundColor = UIColor(red: 228/255.0, green: 241/255.0, blue: 249/255.0, alpha: 0.2)
        searchField.layer.cornerRadius = 5
        return searchField
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 35
        backgroundColor = UIColor(red: 153/255.0, green: 184/255.0, blue: 204/255.0, alpha: 0.95)

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
        addSubview(feelsLikeLabel)
        addSubview(rectangleImageView)
        addSubview(windSpeedLabel)
        addSubview(searchField)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            todayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            todayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            weatherImageView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 40),

            temperatureLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 15),
            temperatureLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 40),

            descriptionCurrentWeatherLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionCurrentWeatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),

            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: descriptionCurrentWeatherLabel.bottomAnchor, constant: 20),

            feelsLikeLabel.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 80),
            feelsLikeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),

            rectangleImageView.leadingAnchor.constraint(equalTo: feelsLikeLabel.trailingAnchor, constant: 15),
            rectangleImageView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 35),

            windSpeedLabel.leadingAnchor.constraint(equalTo: rectangleImageView.trailingAnchor, constant: 20),
            windSpeedLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 30),

            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchField.topAnchor.constraint(equalTo: rectangleImageView.bottomAnchor, constant: 30)
        ])
    }

}

//extension CurrentWeatherCell: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//}
