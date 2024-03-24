//
//  ShortWeatherCell.swift
//  Weather
//
//  Created by Artem Krasnov on 23.03.2024.
//

import UIKit

final class ShortWeatherCell: UICollectionViewCell {

    static let reuseIdent = "ShortWeatherCell"

    lazy var date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = .white
        date.textAlignment = .center
        date.font = UIFont.boldSystemFont(ofSize: 12)
        return date
    }()

    lazy var weatherImageView: UIImageView = {
        let weatherImageView = UIImageView()
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.tintColor = .white
        return weatherImageView
    }()

    lazy var minTemperatureLabel: UILabel = {
        let minTemp = UILabel()
        minTemp.translatesAutoresizingMaskIntoConstraints = false
        minTemp.textColor = .white
        minTemp.textAlignment = .center
        minTemp.font = UIFont.boldSystemFont(ofSize: 24)
        return minTemp
    }()

    lazy var maxTemperatureLabel: UILabel = {
        let maxTemp = UILabel()
        maxTemp.translatesAutoresizingMaskIntoConstraints = false
        maxTemp.textColor = .white
        maxTemp.textAlignment = .center
        maxTemp.font = UIFont.boldSystemFont(ofSize: 24)
        return maxTemp
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 25
        backgroundColor = .accentSecondary.withAlphaComponent(0.7)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(date)
        addSubview(weatherImageView)
        addSubview(maxTemperatureLabel)
        addSubview(minTemperatureLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            date.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            date.centerYAnchor.constraint(equalTo: centerYAnchor),

            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -15),
            maxTemperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            minTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            minTemperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(with shortWeather: ShortWeatherModel) {
        date.text = shortWeather.day
        weatherImageView.image = UIImage(named: shortWeather.iconWeather ?? "")?.withRenderingMode(.alwaysTemplate)
        maxTemperatureLabel.text = "\(shortWeather.maxTemp ?? "-") °"
        minTemperatureLabel.text = "\(shortWeather.minTemp ?? "-") °"
    }
}
