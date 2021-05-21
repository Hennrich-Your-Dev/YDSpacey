//
//  YDSpaceyCoordinator.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WIntegration
import YDB2WModels

public typealias YDSpacey = YDSpaceyCoordinator

public class YDSpaceyCoordinator {
  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start(
    supportedTypes: [YDSpaceyComponentsTypes.Types],
    supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum] = []
  ) -> YDSpaceyViewController {
    //
    let viewModel = SpaceyViewModel(
      supportedTypes: supportedTypes,
      supportedNPSAnswersTypes: supportedNPSAnswersTypes
    )

    if let spaceyOrder = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.spaceyService.rawValue)?
        .extras?[YDConfigProperty.liveSpaceyOrder.rawValue] as? [String] {
      viewModel.spaceyOrder = spaceyOrder
    }

    let vc = YDSpaceyViewController()

    vc.viewModel = viewModel
    return vc
  }
}
