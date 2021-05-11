//
//  YDSpaceyCoordinator.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels

public typealias YDSpacey = YDSpaceyCoordinator

public class YDSpaceyCoordinator {
  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start(supportedTypes: [YDSpaceyComponentsTypes.Types]) -> YDSpaceyViewController {
    let viewModel = SpaceyViewModel(supportedTypes: supportedTypes)
    let vc = YDSpaceyViewController()

    vc.viewModel = viewModel
    return vc
  }
}
