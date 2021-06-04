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
  var viewModel: YDSpaceyViewModelDelegate?
  public weak var delegate: YDSpaceyDelegate?
  public var largerHeader = false
  var numberOfShimmers = 0
  var bannerCellSize: CGFloat = 180
  var textViewIndex = 0
  public var collectionContentHeight: CGFloat = 0 {
    didSet {
      delegate?.onChange(contentHeightSize: collectionContentHeight)
    }
  }

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

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardDidShow),
      name: UIResponder.keyboardDidShowNotification, object: nil
    )
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionContentHeight = collectionView.contentSize.height
  }
}

// MARK: Actions
public extension YDSpaceyViewController {
  @objc func keyboardDidShow() {
//    guard let cell = collectionView.cellForItem(
//      at: IndexPath(row: textViewIndex, section: 0)
//    ) else { return }
//
//    let point = collectionView.convert(cell.frame.origin, to: collectionView)
//    collectionView.contentOffset = point
  }
}

// MARK: Public Actions
public extension YDSpaceyViewController {
  func getSpacey(withId id: String, customApi: String? = nil) {
    viewModel?.getSpacey(withId: id, customApi: customApi)
  }

  func getList() -> [YDSpaceyCommonStruct] {
    return viewModel?.componentsList.value ?? []
  }

  func set(list: [YDSpaceyCommonStruct]) {
    viewModel?.componentsList.value = list
    collectionView.reloadData()
  }
}
