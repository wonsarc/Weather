//
//  ViewController.swift
//  Weather
//
//  Created by Artem Krasnov on 20.03.2024.
//

import UIKit

class ViewController: UIViewController {
    var profileImageListViewObserver: NSObjectProtocol?

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
