//
//  SpaceyViewController+Title.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueTitleCell(
    withTitle title: YDSpaceyComponentTitle,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyTitleCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyTitleCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyTitleCollectionViewCell")
    }

    cell.configure(withTitle: title.contentTitle)
    return cell
  }
}
