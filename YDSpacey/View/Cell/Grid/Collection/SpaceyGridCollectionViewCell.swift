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
    translatesAutoresizingMaskIntoConstraints = false
    widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true
    configureCollectionView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    heightConstraint.constant = collectionView.contentSize.height
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentGrid) {
    items = component.children
    collectionView.reloadData()
  }
}

// MARK: Layout
extension SpaceyGridCollectionViewCell {
  func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
    heightConstraint.isActive = true
  }
}
