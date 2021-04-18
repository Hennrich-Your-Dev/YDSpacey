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

//    print("viewModel?.bannersOnList[bannerId]?.currentRect", viewModel?.bannersOnList[bannerId]?.currentRect)
    if let rect = viewModel?.bannersOnList[bannerId]?.currentRect {
      imageView.frame = rect
      updateLayout()
    }

    var tempRect = imageContainer.frame

    imageView.startShimmer()
    imageView.setImage(viewModel?.bannersOnList[bannerId]?.image) { [weak self] success in
      guard let self = self else { return }
      self.imageView.stopShimmer()

      if success != nil {
        tempRect.size.height = self.imageView.frame.size.height
        self.viewModel?.bannersOnList[self.bannerId]?.currentRect = tempRect
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
      imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
      imageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
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
      imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
      imageViewHeightConstraint,
      imageContainer.heightAnchor.constraint(equalTo: imageView.heightAnchor)
    ])
  }
}
