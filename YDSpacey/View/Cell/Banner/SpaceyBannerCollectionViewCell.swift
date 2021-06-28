//
//  SpaceyBannerCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import Kingfisher

class SpaceyBannerCollectionViewCell: UICollectionViewCell {
  // Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let imageContainer = UIView()
  let imageView = UIImageView()
  lazy var imageViewHeightConstraint: NSLayoutConstraint = {
    return imageView.heightAnchor.constraint(equalToConstant: 80)
  }()

  // Properties
  var viewModel: YDSpaceyViewModelDelegate?
  var bannerId = 0
  var needsToUpdateCallback: (() -> Void)?

  // Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false

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
    imageViewHeightConstraint.constant = 80
    needsToUpdateCallback = nil
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

//  override func layoutSubviews() {
//    super.layoutSubviews()
//    imageContainer.layer.shadowPath = UIBezierPath(
//      roundedRect: imageContainer.bounds,
//      cornerRadius: 6
//    ).cgPath
//  }

  // MARK: Actions
  func config(
    withId bannerId: Int,
    viewModel: YDSpaceyViewModelDelegate?
  ) {
    self.viewModel = viewModel
    self.bannerId = bannerId

    imageView.startShimmer()
    imageView.setImage(
      viewModel?.bannersOnList[bannerId]?.image
    ) { [weak self] success in
      guard let self = self else { return }
      self.onImageCallback(success)
    }
  }

  func config(with component: YDSpaceyComponentBanner) {
    imageView.startShimmer()
    imageView.setImage(component.bannerImage) { [weak self] success in
      guard let self = self else { return }
      self.onImageCallback(success, fromGrid: true)
    }
  }

  func onImageCallback(_ success: RetrieveImageResult?, fromGrid: Bool = false) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.imageView.stopShimmer()

      if success != nil {
        guard let image = self.imageView.image else { return }

        let width = self.width.constant
        let padding: CGFloat = 32
        let ratio = (width - padding) / CGFloat(image.size.width)

        let onScreenBannerHeight = Int(
          CGFloat(image.size.height) * ratio
        )

        self.imageView.frame.size = CGSize(
          width: width,
          height: CGFloat(onScreenBannerHeight)
        )

        if !fromGrid {
          self.viewModel?.bannersOnList[self.bannerId]?
            .imageComponent = self.imageView.image
        }
      } else {
        self.imageContainer.isHidden = true
        self.imageView.frame.size = .zero
      }

      self.updateLayout()
    }
  }

  func updateLayout() {
    imageViewHeightConstraint.constant = imageView.frame.size.height
    setNeedsLayout()
    needsToUpdateCallback?()
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
    imageContainer.addSubview(imageView)
    imageView.backgroundColor = UIColor.Zeplin.grayOpaque
    imageView.layer.cornerRadius = 6
    imageView.contentMode = .scaleAspectFill

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewHeightConstraint.isActive = true

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
      imageView.trailingAnchor
        .constraint(equalTo: imageContainer.trailingAnchor)
    ])
  }
}
