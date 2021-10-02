//
//  SpaceyProductCarrouselCollectionViewCell+Layouts.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import YDExtensions

extension SpaceyProductCarrouselCollectionViewCell {
  func configureUI() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    configureHeaderLabel()
    configureLivePulseView()
    configureCollectionView()
  }
}

// MARK: Header
extension SpaceyProductCarrouselCollectionViewCell {
  private func configureHeaderLabel() {
    contentView.addSubview(headerLabel)
    headerLabel.font = .boldSystemFont(ofSize: 24)
    headerLabel.textAlignment = .left
    headerLabel.numberOfLines = 2
    headerLabel.textColor = Zeplin.black
    
    headerLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
      headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      
      headerLabelHeightConstraint,
      headerLabelTrailingConstraint
    ])
  }
  
  private func configureLivePulseView() {
    contentView.addSubview(livePulseView)

    livePulseView.backgroundColor = Zeplin.redNight
    livePulseView.layer.cornerRadius = 8

    NSLayoutConstraint.activate([
      livePulseView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 9.5
      ),
      livePulseView.widthAnchor.constraint(equalToConstant: 46),
      livePulseView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -16
      )
    ])

    // Label
    let message = UILabel()
    livePulseView.addSubview(message)
    message.textColor = .white
    message.textAlignment = .center
    message.font = .systemFont(ofSize: 10)
    message.text = "ao vivo"

    NSLayoutConstraint.activate([
      message.centerXAnchor.constraint(equalTo: livePulseView.centerXAnchor),
      message.centerYAnchor.constraint(equalTo: livePulseView.centerYAnchor)
    ])
  }
}

// MARK: Collection View
extension SpaceyProductCarrouselCollectionViewCell {
  private func configureCollectionView() {
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 18),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: 204),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
    
    configureCollectionViewDataSource()
  }
  
  private func configureCollectionViewDataSource() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    layout.itemSize = CGSize(width: 300, height: 204)
    layout.minimumLineSpacing = 12
    
    collectionView.collectionViewLayout = layout
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    collectionView.register(SpaceyProductOnCarrouselCell.self)
    
    collectionView.register(
      SpaceyProductLoadingFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: SpaceyProductLoadingFooterView.identifier
    )
    
    collectionView.register(
      SpaceyProductLoadingFooterView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SpaceyProductLoadingFooterView.identifier
    )
  }
}
