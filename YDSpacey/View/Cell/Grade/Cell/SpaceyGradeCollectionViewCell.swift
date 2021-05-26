//
//  SpaceyGradeCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 26/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels

class SpaceyGradeCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  let container = UIView()
  let gradeLabel = UILabel()

  // MARK: Properties
  private let selectedBackgroundColor = UIColor(
    red: 102 / 255,
    green: 102 / 255,
    blue: 102 / 255,
    alpha: 1
  )
  private let selectedLabelColor = UIColor(
    red: 255 / 255,
    green: 255 / 255,
    blue: 255 / 255,
    alpha: 1
  )

  private let unselectedBackgroundColor = UIColor(
    red: 235 / 255,
    green: 235 / 255,
    blue: 235 / 255,
    alpha: 1
  )
  private let unselectedLabelColor = UIColor(
    red: 112 / 255,
    green: 112 / 255,
    blue: 112 / 255,
    alpha: 1
  )

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
    configuregradeLabel()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  func configure(with option: YDSpaceyComponentNPSQuestionAnswer) {
    gradeLabel.text = option.answerText
    setStyle(option.selected)
  }

  func setStyle(_ selected: Bool) {
    container.backgroundColor = selected ?
      selectedBackgroundColor : unselectedBackgroundColor

    gradeLabel.textColor = selected ?
      selectedLabelColor : unselectedLabelColor
  }
}

// MARK: Layout
extension SpaceyGradeCollectionViewCell {
  func configureLayout() {
    configureContainer()
    configuregradeLabel()
  }

  func configureContainer() {
    contentView.addSubview(container)
    container.backgroundColor = unselectedBackgroundColor
    container.layer.cornerRadius = 8

    container.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: contentView.topAnchor),
      container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  func configuregradeLabel() {
    container.addSubview(gradeLabel)
    gradeLabel.font = .systemFont(ofSize: 14)
    gradeLabel.textColor = unselectedLabelColor
    gradeLabel.textAlignment = .center

    gradeLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      gradeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
      gradeLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor)
    ])
  }
}
