//
//  YDSpaceyCoordinator.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

public typealias YDSpacey = YDSpaceyCoordinator

public class YDSpaceyCoordinator {
  // MARK: Init
  public init() {}

  // MARK: Actions
  public func start() -> YDSpaceyViewController {
    let viewModel = SpaceyViewModel()
    let vc = YDSpaceyViewController()

    vc.viewModel = viewModel

    return vc
  }
}
