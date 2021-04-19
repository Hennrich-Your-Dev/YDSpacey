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
    imageView.image = nil
    imageView.frame = .zero
    imageView.stopShimmer()
  }

  // MARK: Actions
  func config(
    withId bannerId: Int,
    viewModel: SpaceyViewModelDelegate?
  ) {
    self.viewModel = viewModel
    self.bannerId = bannerId

    if let rect = viewModel?.bannersOnList[bannerId]?.currentRect {
      // debugPrint("currentRect", rect)
      imageView.frame = rect
      imageView.image = viewModel?.bannersOnList[bannerId]?.imageComponent
      imageView.center = imageContainer.center
      updateLayout()
      return
    }

    imageView.startShimmer()
    imageView.setImage(viewModel?.bannersOnList[bannerId]?.image) { [weak self] success in
      guard let self = self else { return }
      self.imageView.stopShimmer()

      if success != nil {
        self.viewModel?.bannersOnList[bannerId]?.currentRect = self.imageView.frame
        self.viewModel?.bannersOnList[bannerId]?.imageComponent = self.imageView.image
      }

      self.updateLayout()
    }
  }

  func updateLayout() {
    print("imageView.frame.size.height", imageView.frame.size.height)
    imageViewHeightConstraint.constant = imageView.frame.size.height
    setNeedsLayout()
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
    imageView.contentMode = .scaleAspectFill

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 80)
    imageViewHeightConstraint.isActive = true

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
      imageContainer.heightAnchor.constraint(equalTo: imageView.heightAnchor)
    ])
  }
}
