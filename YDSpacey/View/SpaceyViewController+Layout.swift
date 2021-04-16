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
  }

  func configureCollectionView() {
    view.addSubview(collectionView)

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

    collectionView.collectionViewLayout = layout

    // Register Cells
    collectionView.register(
      SpaceyBannerCollectionViewCell.self,
      forCellWithReuseIdentifier: SpaceyBannerCollectionViewCell.identifier
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
}

// MARK: Flow Delegate
extension YDSpaceyViewController: UICollectionViewDelegateFlowLayout {
  // Space between items
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }

  // Header Size
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: 0, height: largerHeader ? 40 : 20)
  }

  // Section Insets
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0) + 20,
      right: 0
    )
  }
}
