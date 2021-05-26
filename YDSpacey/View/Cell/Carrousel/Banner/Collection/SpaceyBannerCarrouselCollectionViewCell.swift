//
//  SpaceyBannerCarrouselCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels
import YDExtensions

class SpaceyBannerCarrouselCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var viewModel: YDSpaceyViewModelDelegate?
  var carrouselId: Int = 0
  var previousItemsCount = 0

  var collectionViewOffset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      collectionView.contentOffset.x = newValue
    }
  }

  // MARK: Components
  lazy var width: NSLayoutConstraint = {
      let width = contentView.widthAnchor
        .constraint(equalToConstant: bounds.size.width)
      width.isActive = true
      return width
  }()

  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
//  lazy var heightConstraint: NSLayoutConstraint = {
//    collectionView.heightAnchor.constraint(equalToConstant: 50)
//  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

//    translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      contentView.widthAnchor.constraint(
//        equalToConstant: UIScreen.main.bounds.width
//      ),
//      contentView.heightAnchor.constraint(equalToConstant: 137),
//
//      contentView.topAnchor.constraint(equalTo: topAnchor),
//      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
//      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//    ])

//    translatesAutoresizingMaskIntoConstraints = false
//    contentView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      widthAnchor.constraint(equalToConstant: frame.size.width)
//    ])
//    contentView.bindFrame(toView: self)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func systemLayoutSizeFitting(
    _ targetSize: CGSize,
    withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
    verticalFittingPriority: UILayoutPriority
  ) -> CGSize {
    width.constant = bounds.size.width
    return contentView.systemLayoutSizeFitting(
      CGSize(width: targetSize.width, height: 1)
    )
  }

  // MARK: Configure
  func configure(
    with carrouselId: Int,
    viewModel: YDSpaceyViewModelDelegate?
  ) {
    guard let component = viewModel?.componentsList
            .value.at(carrouselId)?.component as? YDSpaceyComponentCarrouselBanner
    else {
      return
    }

    self.carrouselId = carrouselId
    self.viewModel = viewModel

    configureCollectionViewLayout(maxItemsOnScreen: component.itemsToShowOnScreen)

    collectionView.reloadData()

    if let currentX = component.currentRectList {
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
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])

    collectionView.dataSource = self

    // Register Cell
    collectionView.register(
      SpaceyBannerOnCarrouselCell.self,
      forCellWithReuseIdentifier: SpaceyBannerOnCarrouselCell.identifier
    )
  }

  func configureCollectionViewLayout(maxItemsOnScreen: Double) {
    let screenPadding: CGFloat = 16
    let convertedToFloat = CGFloat(maxItemsOnScreen)
    let itemSize = (frame.size.width / convertedToFloat).rounded(.up)

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = screenPadding

    flowLayout.itemSize = CGSize(
      width: itemSize,
      height: itemSize
    )

    flowLayout.sectionInset = UIEdgeInsets(
      top: 0,
      left: screenPadding,
      bottom: 0,
      right: screenPadding
    )

    collectionView.collectionViewLayout = flowLayout
    flowLayout.invalidateLayout()
    collectionView.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
  }
}
