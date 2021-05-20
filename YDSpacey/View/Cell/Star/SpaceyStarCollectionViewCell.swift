//
//  SpaceyStarCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels

class SpaceyStarCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let starComponent = SpaceyStarComponentView()

  // MARK: Properties
  var starNumber: Double {
    get {
      starComponent.starNumber
    }
    set {
      starComponent.starNumber = newValue
    }
  }
  var callback: ((_ starNumber: Double) -> Void)? {
    didSet {
      starComponent.callback = callback
    }
  }

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalToConstant: frame.size.width),
      contentView.heightAnchor.constraint(equalToConstant: 60)
    ])

    configureStarComponent()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(with component: YDSpaceyComponentNPSQuestion) {
    starComponent.configure(with: component)
  }
}

// MARK: Layout
extension SpaceyStarCollectionViewCell {
  func configureStarComponent() {
    contentView.addSubview(starComponent)

    NSLayoutConstraint.activate([
      starComponent.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      starComponent.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      starComponent.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
}
