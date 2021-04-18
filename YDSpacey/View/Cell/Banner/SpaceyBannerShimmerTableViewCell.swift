//
//  SpaceyBannerShimmerTableViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 18/04/21.
//

import UIKit

import YDExtensions

class SpaceyBannerShimmerTableViewCell: UITableViewCell {
  // Components
  let containerView = UIView()

  // Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureLayout()
    containerView.startShimmer()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Layout
extension SpaceyBannerShimmerTableViewCell {
  func configureLayout() {
    selectionStyle = .none

    contentView.addSubview(containerView)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 6
    containerView.layer.applyShadow()

    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 12
      ),
      containerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: 16
      ),
      containerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      ),
      containerView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -12
      )
    ])
  }
}
