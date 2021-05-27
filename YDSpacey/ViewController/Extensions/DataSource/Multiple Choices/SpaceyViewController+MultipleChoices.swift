//
//  SpaceyViewController+MultipleChoices.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 26/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueMultipleChoicesCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyMultipleChoicesListCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyMultipleChoicesListCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyMultipleChoicesListCollectionViewCell")
    }

    cell.configure(with: component)
    cell.callback = { [weak self] choices in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .multiple
      else {
        return
      }

      if let component = self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion {
        component.childrenAnswers = choices

        component.storedValue = choices.first(where: { $0.selected })?.answerText
      }
    }
    return cell
  }
}
