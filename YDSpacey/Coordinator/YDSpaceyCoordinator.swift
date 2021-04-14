//
//  YDSpaceyCoordinator.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import Foundation

public typealias YDSpacey = YDSpaceyCoordinator

public class YDSpaceyCoordinator {
  // MARK: Init
  public init() {}

  // MARK: Actions
  func start() -> SpaceyViewController {
    let viewModel = SpaceyViewModel()
    let vc = SpaceyViewController()

    vc.viewModel = viewModel

    return vc
  }
}
