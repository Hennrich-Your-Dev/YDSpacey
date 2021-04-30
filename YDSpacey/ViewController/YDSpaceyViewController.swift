//
//  SpaceyViewController.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels

public class YDSpaceyViewController: UIViewController {
  // MARK: Properties
  var viewModel: SpaceyViewModelDelegate?
  public weak var delegate: YDSpaceyDelegate?
  public var largerHeader = false
  var numberOfShimmers = 0
  var bannerCellSize: CGFloat = 180

  // MARK: Components
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewLayout()
  )
  let shimmerTableView = UITableView()

  // MARK: Life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureLayout()
    configureBinds()
  }
}

// MARK: Actions
public extension YDSpaceyViewController {
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
public extension YDSpaceyViewController {
  func getSpacey(withId id: String) {
    viewModel?.getSpacey(withId: id)
  }
}
