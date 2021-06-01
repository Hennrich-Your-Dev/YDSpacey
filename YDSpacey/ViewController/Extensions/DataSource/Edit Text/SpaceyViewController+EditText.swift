//
//  SpaceyViewController+EditText.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/06/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueEditTextCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyEditTextCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyEditTextCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyEditTextCollectionViewCell")
    }

    cell.configure(with: component)
    cell.callback = { [weak self] answer in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .textView
      else {
        return
      }

      (
        self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion
      )?.storedValue = answer
    }
    return cell
  }
}
