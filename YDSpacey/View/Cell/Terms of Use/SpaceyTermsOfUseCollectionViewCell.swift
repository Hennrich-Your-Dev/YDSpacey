//
//  SpaceyTermsOfUseCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 04/06/21.
//

import UIKit
import RichTextView
import YDB2WModels
import YDExtensions

class SpaceyTermsOfUseCollectionViewCell: UICollectionViewCell {
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  let richTextComponent = RichTextView(frame: .zero)

  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

  // MARK: Configure
  func configure(with component: YDSpaceyComponentTermsOfUse) {
    guard let text = component.contentJson else { return }

    richTextComponent.update(
      input: text,
      latexParser: LatexParser(),
      font: .systemFont(ofSize: 16),
      textColor: Zeplin.black,
      latexTextBaselineOffset: 0,
      interactiveTextColor: .blue,
      customAdditionalAttributes: nil,
      completion: nil
    )
  }
}

// MARK: UI
extension SpaceyTermsOfUseCollectionViewCell {
  private func configure() {
    contentView.addSubview(richTextComponent)
    richTextComponent.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      richTextComponent.topAnchor.constraint(equalTo: contentView.topAnchor),
      richTextComponent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      richTextComponent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      richTextComponent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
