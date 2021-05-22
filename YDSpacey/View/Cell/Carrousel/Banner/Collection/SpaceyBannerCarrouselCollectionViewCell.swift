//
//  SpaceyBannerCarrouselCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels

class SpaceyBannerCarrouselCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var viewModel: YDSpaceyViewModelDelegate?
  var carrouselId: Int = 0
  var previousItemsCount = 0
  var currentFrame: CGRect = .zero

  var collectionViewOffset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      collectionView.contentOffset.x = newValue
    }
  }

  // MARK: Components
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalToConstant: frame.size.width),
      contentView.heightAnchor.constraint(equalToConstant: 180)
    ])

    currentFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: 180)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(
    with carrouselId: Int,
    viewModel: YDSpaceyViewModelDelegate?
  ) {
    self.carrouselId = carrouselId
    self.viewModel = viewModel

    collectionView.reloadData()

    if let component = viewModel?.componentsList
        .value.at(carrouselId)?.component as? YDSpaceyComponentCarrouselBanner,
      let currentX = component.currentRectList {
      collectionViewOffset = currentX
    }
  }
}

// MARK: Layouts
extension SpaceyBannerCarrouselCollectionViewCell {
  func configureLayout() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    configureCollectionView()
  }

  func configureCollectionView() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 12
    flowLayout.estimatedItemSize = CGSize(
      width: currentFrame.size.width * 0.79,
      height: currentFrame.size.height
    )
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    collectionView.collectionViewLayout = flowLayout
    collectionView.dataSource = self

    // Register Cell
    collectionView.register(
      SpaceyBannerOnCarrouselCell.self,
      forCellWithReuseIdentifier: SpaceyBannerOnCarrouselCell.identifier
    )
  }
}
