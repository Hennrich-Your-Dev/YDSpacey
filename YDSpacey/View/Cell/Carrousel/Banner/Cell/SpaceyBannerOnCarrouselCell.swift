//
//  SpaceyBannerOnCarrouselCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels
import YDExtensions

class SpaceyBannerOnCarrouselCell: UICollectionViewCell {
  // MARK: Properties
  lazy var widthConstraint: NSLayoutConstraint = {
    let width = contentView.widthAnchor.constraint(equalToConstant: 0)
    return width
  }()

  // MARK: Components
  let imageView = UIImageView()

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    widthConstraint.constant = frame.size.width
    widthConstraint.isActive = true
    configureImageView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  // MARK: Actions
  func configure(with banner: YDSpaceyComponentBanner) {
    imageView.setImage(banner.bannerImage) { [weak self] result in
      guard let self = self else { return }
      if result == nil {
        self.widthConstraint.constant = 0
        self.layoutIfNeeded()
      } else {
        self.imageView.contentMode = .scaleAspectFill
      }
    }
  }
}

// MARK: Layouts
extension SpaceyBannerOnCarrouselCell {
  func configureImageView() {
    contentView.addSubview(imageView)
    imageView.contentMode = .scaleAspectFill
    imageView.backgroundColor = UIColor.Zeplin.grayNight
    imageView.layer.cornerRadius = 6
    imageView.layer.applyShadow()

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
