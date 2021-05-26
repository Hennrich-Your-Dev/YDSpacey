//
//  SpaceyViewController+BannerCarrousel.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 12/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueBannerCarrouselCell(
    withCarrousel carrousel: YDSpaceyComponentCarrouselBanner,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SpaceyBannerCarrouselCollectionViewCell.identifier,
      for: indexPath
    ) as? SpaceyBannerCarrouselCollectionViewCell
    else {
      return UICollectionViewCell()
    }

    cell.configure(
      with: indexPath.row,
      viewModel: viewModel
    )
    return cell
  }
}
