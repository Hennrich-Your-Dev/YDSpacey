//
//  SpaceyGridCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 25/05/21.
//

import UIKit
import YDB2WModels
import YDExtensions

class SpaceyGridCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var items: [YDSpaceyComponentsTypes] = []

  // MARK: Components
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  lazy var heightConstraint: NSLayoutConstraint = {
    collectionView.heightAnchor.constraint(equalToConstant: 50)
  }()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    layer.masksToBounds = false
    clipsToBounds = false
    contentView.clipsToBounds = false
    contentView.layer.masksToBounds = false
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
    configureCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    heightConstraint.constant = collectionView.collectionViewLayout
      .collectionViewContentSize.height
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentGrid) {
    if let numberOfColumns = component.numberOfColumns {
      configureCollectionViewLayout(numberOfColumns: numberOfColumns)
    }

    items = component.children
    collectionView.reloadData()
    collectionView.setNeedsLayout()
  }
}

// MARK: Layout
extension SpaceyGridCollectionViewCell {
  func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    configureCollectionViewLayout(numberOfColumns: 1)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
    heightConstraint.isActive = true

    // Register Cells
    YDSpaceyHelper.registerCells(in: collectionView, for: .grid)
  }

  func configureCollectionViewLayout(numberOfColumns: Int) {
    collectionView.collectionViewLayout = YDSpaceyHelper.configureCollectionLayout(
      numberOfColumns: numberOfColumns,
      inside: contentView
    )

    collectionView.collectionViewLayout.invalidateLayout()
  }
}
