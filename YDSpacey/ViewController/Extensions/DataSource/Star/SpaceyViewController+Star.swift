//
//  SpaceyViewController+Star.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueStarCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyStarCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyStarCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyTitleCollectionViewCell")
    }

    cell.configure(with: component)
    cell.callback = { [weak self] starNumber in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .star
      else {
        return
      }

      (
        self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion
      )?.storedValue = starNumber
    }
    return cell
  }
}
