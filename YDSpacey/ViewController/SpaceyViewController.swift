//
//  SpaceyViewController.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels

public class SpaceyViewController: UICollectionViewController {
  // MARK: Properties
  var viewModel: SpaceyViewModelDelegate?
  public weak var delegate: SpaceyDelegate?
  public var largerHeader = false

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureBinds()
  }
}

// MARK: Actions
extension SpaceyViewController {
  // Get current item component and type
  func getItemAndType(
    at indexPath: IndexPath
  ) -> (item: YDSpaceyCommonStruct, type: YDSpaceyComponentsTypes)? {
    guard let item = viewModel?.componentsList.value.at(indexPath.row),
          let type = item.component.children?.first
    else {
      return nil
    }
    return (item, type)
  }
}

// MARK: Public Actions
public extension SpaceyViewController {
  func getSpacey(withId id: String) {
    viewModel?.getSpacey(withId: id)
  }
}
