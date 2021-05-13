//
//  SpaceyBannerCarrouselCollectionViewCell+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDExtensions
import YDB2WModels

extension SpaceyBannerCarrouselCollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let carrousel = viewModel?.componentsList
            .value.at(carrouselId)?.component
    else {
      return 0
    }

    return carrousel.children?.count ?? 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard viewModel?.componentsList
    .value.at(carrouselId) != nil,
          let component = viewModel?.componentsList
            .value[carrouselId].component as? YDSpaceyComponentCarrouselBanner,
          let children = component.children,
          case .banner(let banner) = children.at(indexPath.row),
          let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyBannerOnCarrouselCell.identifier,
              for: indexPath
            ) as? SpaceyBannerOnCarrouselCell
    else {
      return UICollectionViewCell()
    }

    cell.configure(with: banner)
    return cell
  }
}
