//
//  SpaceyViewController+Options.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 20/05/21.
//

import UIKit

import YDB2WModels

extension YDSpaceyViewController {
  func dequeueGradeCell(
    with component: YDSpaceyComponentNPSQuestion,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView
            .dequeueReusableCell(
              withReuseIdentifier: SpaceyGradeListCollectionViewCell.identifier,
              for: indexPath
            ) as? SpaceyGradeListCollectionViewCell
    else {
      fatalError("dequeueReusableCell SpaceyGradeListCollectionViewCell")
    }

    cell.configure(with: component)
    cell.callback = { [weak self] options in
      guard let self = self else { return }
      guard let component = self.viewModel?.componentsList
              .value.at(indexPath.row)?.component as? YDSpaceyComponentNPSQuestion,
            component.answerType == .grade
      else {
        return
      }

      if let component = self.viewModel?.componentsList
          .value[indexPath.row].component as? YDSpaceyComponentNPSQuestion {
        component.childrenAnswers = options

        component.storedValue = options.first(where: { $0.selected })?.answerText
      }
    }
    return cell
  }
}
