//
//  YDSpaceyViewController+Grid.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 25/05/21.
//

import UIKit
import YDB2WModels

extension YDSpaceyViewController {
  func dequeueGridCell(
    with component: YDSpaceyComponentGrid,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyGridCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyGridCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyTitleCollectionViewCell")
    }

    cell.configure(with: component)
    return cell
  }
}
