//
//  SpaceyViewController+Banner.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueBannerCell(
    withBanner banner: YDSpaceyComponentBanner,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SpaceyBannerCollectionViewCell.identifier,
            for: indexPath) as? SpaceyBannerCollectionViewCell
    else {
      return UICollectionViewCell()
    }

    if viewModel?.bannersOnList[indexPath.row] == nil {
      viewModel?.bannersOnList[indexPath.row] = YDSpaceyBannerConfig(
        image: banner.bannerImage ?? "",
        bannerId: banner.deepLink ?? ""
      )
    }

    cell.config(
      withId: indexPath.row,
      viewModel: viewModel
    )
    return cell
  }
}
