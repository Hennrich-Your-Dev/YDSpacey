//
//  SpaceyViewController+Binds.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit

public extension SpaceyViewController {
  func configureBinds() {
    viewModel?.loading.bind { [weak self] isLoading in
      guard let self = self else { return }
      //
    }

    viewModel?.componentsList.bind { [weak self] list in
      guard let self = self else { return }

      self.collectionView.reloadData()

      // Invalidate layout to fix auto sizing cell height bug
      let time: Double = Double(list.count)

      Timer.scheduledTimer(
        withTimeInterval: 0.4 * time,
        repeats: false
      ) { _ in
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.collectionView.collectionViewLayout.invalidateLayout()
        }
      }
    }

//    viewModel?.error.bind { [weak self] _ in
//      self?.showHideErrorView()
//    }
//
//    viewModel?.hotsite.bind { [weak self] hotsite in
//      guard let self = self,
//            let viewModel = self.viewModel,
//            let hotsite = hotsite,
//            let playerInfo = hotsite.allComponents()
//              .first(where: { $0.component.children?.first?.get() as? YDLComponentPlayer != nil })?
//              .component.children?.first?.get() as? YDLComponentPlayer,
//            let videoId = playerInfo.videoId
//      else {
//        return
//      }
//
//      if viewModel.canCreateLiveCountView {
//        self.createLiveCountView()
//      }
//
//      // Analytics
//      let parameters = YDB2WIntegration.TrackEvents
//        .playVideo.parameters(body: ["videoId": videoId])
//      YDIntegrationHelper.shared.trackEvent(withName: .pageView, ofType: .state, withParameters: parameters)
//
//      // Instance Player
//      let playerConfig = YDPlayerConfiguration(withVideoId: videoId)
//      YDPlayerView.init(with: playerConfig, parent: self.playerView)
//
//      self.playerView.subviews.forEach { curr in
//        if let player = curr as? YDPlayerView {
//          player.delegate = self
//        }
//      }
//
//      // TODO:
//      // Verificar lógica com B2W ->
//      // ID deve vir do spacey ou do config?
//       self.chatViewModel?.chatId = videoId
//    }
  }
}
