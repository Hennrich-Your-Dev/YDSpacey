//
//  SpaceyOptionCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels

class SpaceyOptionCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let container = UIView()
  let optionLabel = UILabel()

  // MARK: Properties
  let selectedBackgroundColor = Zeplin.grayLight
  let unselectedBackgroundColor = Zeplin.grayOpaque
  let selectedLabelColor = Zeplin.white
  let unselectedLabelColor = Zeplin.grayLight

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    configureLayout()
    configureOptionLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(with option: YDSpaceyComponentNPSQuestionAnswer) {
    optionLabel.text = option.answerText
    setStyle(option.selected)
  }

  func setStyle(_ selected: Bool) {
    container.backgroundColor = selected ?
      selectedBackgroundColor : unselectedBackgroundColor

    optionLabel.textColor = selected ?
      selectedLabelColor : unselectedLabelColor
  }
}

// MARK: Layout
extension SpaceyOptionCollectionViewCell {
  func configureLayout() {
    heightAnchor.constraint(equalToConstant: 40).isActive = true

    configureContainer()
    configureOptionLabel()
  }

  func configureContainer() {
    contentView.addSubview(container)
    container.backgroundColor = unselectedBackgroundColor
    container.layer.cornerRadius = 20

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.heightAnchor.constraint(equalToConstant: 40),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }

  func configureOptionLabel() {
    container.addSubview(optionLabel)
    optionLabel.font = .systemFont(ofSize: 14)
    optionLabel.textColor = unselectedLabelColor
    optionLabel.textAlignment = .center

    optionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      optionLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      optionLabel.leadingAnchor.constraint(
        equalTo: container.leadingAnchor,
        constant: 22
      ),
      optionLabel.trailingAnchor.constraint(
        equalTo: container.trailingAnchor,
        constant: -22
      )
    ])
  }
}
