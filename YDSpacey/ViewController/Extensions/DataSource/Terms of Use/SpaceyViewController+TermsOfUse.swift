//
//  SpaceyViewController+TermsOfUse.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 04/06/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueTermsOfUseCell(
    with component: YDSpaceyComponentTermsOfUse,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyTermsOfUseCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyTermsOfUseCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyTermsOfUseCollectionViewCell")
    }

    cell.configure(with: component)
    return cell
  }
}
