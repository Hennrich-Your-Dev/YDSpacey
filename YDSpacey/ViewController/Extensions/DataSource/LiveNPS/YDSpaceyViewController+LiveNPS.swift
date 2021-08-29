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
import YDUtilities

extension YDSpaceyViewController {
  private func sendNPS(_ nps: YDSpaceyComponentLiveNPSCard?) {
    guard let spaceyId = viewModel?.spaceyId else { return }

    let npsToStore = YDManagerLiveNPS(
      id: nps?.id,
      spaceyId: spaceyId,
      question: nps?.title,
      answer: nps?.storedValue
    )
    YDManager.LivesNPS.shared.add(npsToStore)

    let parameters = TrackEvents.liveNPS.parameters(body: [
      "userId": YDIntegrationHelper.shared.currentUser?.id ?? "",
      "liveId": spaceyId,
      "quizzId": nps?.quizzId ?? "",
      "title": nps?.title ?? "",
      "value": nps?.storedValue ?? ""
    ])

    self.viewModel?
      .sendMetricStuart(nameSpace: .lives, event: .liveNPS, parameters: parameters)
  }

  private func destroy(
    nps: YDSpaceyComponentLiveNPS,
    at indexPath: IndexPath
  ) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      self.viewModel?.componentsList
        .value.removeAll(where: { $0.component?.id == nps.id })
      self.collectionView.deleteItems(at: [indexPath])
    }
  }

  func dequeueLiveNPSCell(
    with component: YDSpaceyComponentLiveNPS,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: SpaceyCardViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

    cell.sendNPSCallback = sendNPS
    cell.destroyCallback = { [weak self] in
      guard let self = self else { return }
      self.destroy(nps: component, at: indexPath)
    }

    cell.configure(with: component.cards, spaceyId: viewModel?.spaceyId)
    return cell
  }
}
