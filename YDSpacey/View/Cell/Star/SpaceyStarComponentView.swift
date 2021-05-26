//
//  SpaceyStarComponentView.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import Cosmos
import YDExtensions
import YDB2WAssets
import YDB2WModels

public class SpaceyStarComponentView: UIView {
  // MARK: Components
  let titleLabel = UILabel()
  public let cosmosView = CosmosView()

  // MARK: Properties
  public var starNumber: Double {
    get {
      cosmosView.rating
    }
    set {
      cosmosView.rating = newValue
    }
  }
  public var callback: ((_ starNumber: Double) -> Void)?

  // MARK: Init
  public init() {
    super.init(frame: .zero)
    configureLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Configure
  public func configure(with component: YDSpaceyComponentNPSQuestion) {
    guard let maxStars = component.maxStars else { return }
    titleLabel.text = component.question
    cosmosView.settings.totalStars = maxStars
    cosmosView.didFinishTouchingCosmos = callback
  }
}

// MARK: Layout
extension SpaceyStarComponentView {
  func configureLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    heightAnchor.constraint(equalToConstant: 60).isActive = true

    configureTitle()
    configureCosmosView()
  }

  func configureTitle() {
    addSubview(titleLabel)
    titleLabel.font = .systemFont(ofSize: 14)
    titleLabel.textColor = Zeplin.black
    titleLabel.textAlignment = .left

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: 16)
    ])
  }

  func configureCosmosView() {
    addSubview(cosmosView)
    cosmosView.settings = createCosmosSettings()
    cosmosView.rating = 0

    cosmosView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cosmosView.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: 12
      ),
      cosmosView.centerXAnchor.constraint(equalTo: centerXAnchor),
      cosmosView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  func createCosmosSettings() -> CosmosSettings {
    var settings = CosmosSettings()
    settings.emptyImage = Images.starGrey
    settings.filledImage = Images.starYellow
    settings.fillMode = .full
    settings.starMargin = 5
    settings.starSize = 32
    settings.totalStars = 5
    return settings
  }
}
