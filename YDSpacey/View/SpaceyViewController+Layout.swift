//
//  SpaceyViewController+Layout.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDExtensions

extension YDSpaceyViewController {
  func configureLayout() {
    view.backgroundColor = UIColor.Zeplin.grayOpaque

    configureCollectionView()
    configureShimmerView()
  }

  func configureCollectionView() {
    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true

    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = CGSize(width: view.frame.width, height: 50)
    layout.minimumLineSpacing = 20
    layout.sectionInset = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: view.safeAreaInsets.bottom + 20,
      right: 0
    )

    collectionView.collectionViewLayout = layout

    // Register Cells
    collectionView.register(
      SpaceyBannerCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyBannerCollectionViewCell.identifier
    )

    collectionView.register(
      SpaceyTitleCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyTitleCollectionViewCell.identifier
    )

    collectionView.register(
      SpaceyStarCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyStarCollectionViewCell.identifier
    )

    collectionView.register(
      SpaceyOptionsListCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyOptionsListCollectionViewCell.identifier
    )

    collectionView.register(
      SpaceyGridCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyGridCollectionViewCell.identifier
    )

    // Register Header / Footer
    collectionView.register(
      EmptyCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: EmptyCollectionReusableView.identifier
    )

    collectionView.register(
      EmptyCollectionReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: EmptyCollectionReusableView.identifier
    )
  }

  func configureShimmerView() {
    view.addSubview(shimmerTableView)

    shimmerTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shimmerTableView.topAnchor.constraint(equalTo: view.topAnchor),
      shimmerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      shimmerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      shimmerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    shimmerTableView.dataSource = self
    shimmerTableView.delegate = self
    shimmerTableView.separatorStyle = .none

    // Register Cell
    shimmerTableView.register(
      SpaceyBannerShimmerTableViewCell.self,
      forCellReuseIdentifier: SpaceyBannerShimmerTableViewCell.identifier
    )

    numberOfShimmers = Int((view.frame.size.height / bannerCellSize).rounded(.up))
  }
}

// MARK: Flow Delegate
extension YDSpaceyViewController: UICollectionViewDelegateFlowLayout {
  // Header Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: 0, height: largerHeader ? 40 : 20)
  }
}
