//
//  SpaceyBannerCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit

import YDExtensions

class SpaceyBannerCollectionViewCell: UICollectionViewCell {
  // Components
  let imageContainer = UIView()
  let imageView = UIImageView()
  var imageViewHeightConstraint = NSLayoutConstraint()

  // Properties
  var viewModel: SpaceyViewModelDelegate?
  var bannerId = 0

  // Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.widthAnchor.constraint(equalToConstant: frame.size.width).isActive = true

    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.stopShimmer()
  }

  // MARK: Actions
  func config(
    withId bannerId: Int,
    withWidth width: CGFloat,
    viewModel: SpaceyViewModelDelegate?
  ) {
    self.viewModel = viewModel

    if let rect = viewModel?.bannersOnList[bannerId]?.currentRect {
      imageView.frame = rect
      updateLayout()
    }

    imageView.startShimmer()
    imageView.setImage(viewModel?.bannersOnList[bannerId]?.image) { [weak self] success in
      guard let self = self else { return }
      self.imageView.stopShimmer()

      if success != nil {
        self.viewModel?.bannersOnList[self.bannerId]?.currentRect = self.imageView.frame
      }

      self.updateLayout()
    }
  }

  func updateLayout() {
    imageViewHeightConstraint.constant = imageView.frame.size.height
  }
}

// MARK: Layout
extension SpaceyBannerCollectionViewCell {
  func configureLayout() {
    configureImageContainer()
    configureImageView()
  }

  func configureImageContainer() {
    contentView.addSubview(imageContainer)
    imageContainer.backgroundColor = UIColor.Zeplin.grayOpaque
    imageContainer.layer.cornerRadius = 6
    imageContainer.layer.applyShadow()

    imageContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
    ])
  }

  func configureImageView() {
    contentView.addSubview(imageView)
    imageView.backgroundColor = UIColor.Zeplin.grayOpaque
    imageView.layer.cornerRadius = 6

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 80)

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageViewHeightConstraint,
      imageContainer.heightAnchor.constraint(equalTo: imageView.heightAnchor)
    ])
  }
}
