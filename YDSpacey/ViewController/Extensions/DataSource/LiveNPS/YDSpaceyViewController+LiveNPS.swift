//
//  YDSpaceyViewController+LiveNPS.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 05/07/21.
//

import UIKit
import YDB2WModels
import YDExtensions
import YDB2WIntegration

extension YDSpaceyViewController {
  func dequeueLiveNPSCell(
    with component: YDSpaceyCommonComponent,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyCardViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    guard let cards = component.children as? [YDSpaceyComponentLiveNPSCard]
    else {
      fatalError()
    }

    cell.configure(with: cards)

    cell.sendNPSCallback = { [weak self] nps in
      guard let self = self else { return }
      guard let spaceyId = self.viewModel?.spaceyId else { return }

      let parameters = TrackEvents.liveNPS.parameters(body: [
        "liveId": spaceyId,
        "cardId": nps?.id as Any,
        "title": nps?.title as Any,
        "value": nps?.storedValue as Any
      ])

      self.viewModel?.sendMetric(name: .liveNPS, type: .action, parameters: parameters)
    }

    cell.destroyCallback = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }

        self.viewModel?.componentsList
          .value.removeAll(where: { $0.component?.id == component.id })
        self.collectionView.reloadData()
      }
    }

    return cell
  }
}
