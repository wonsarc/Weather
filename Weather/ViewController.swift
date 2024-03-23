//
//  ViewController.swift
//  Weather
//
//  Created by Artem Krasnov on 20.03.2024.
//

import UIKit

class ViewController: UIViewController {

    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let screenWidth = UIScreen.main.bounds.width
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(screenWidth), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 34, bottom: 17, trailing: 34)

                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(screenWidth), heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: group)
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 34, bottom: 0, trailing: 34)

                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(screenWidth), heightDimension: .fractionalHeight(0.5))
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
        backgroundImageView.image = UIImage(named: "Snow")
        return backgroundImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        configureCollectionView()
        configureDataSource()


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
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexPath.section == 0 ? CurrentWeatherCell.reuseIdent : ShortWeatherCell.reuseIdent, for: indexPath)
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([0], toSection: 0)
        snapshot.appendItems(Array(1...7), toSection: 1)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
