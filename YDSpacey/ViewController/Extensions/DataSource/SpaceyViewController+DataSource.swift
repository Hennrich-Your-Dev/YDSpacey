//
//  SpaceyViewController+DataSource.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import UIKit

import YDB2WModels
import YDExtensions

// MARK: Data Source
extension YDSpaceyViewController: UICollectionViewDataSource {
  // How many items
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel?.componentsList.value.count ?? 0
  }

  // Dequeue Cell
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    return dequeueCell(at: indexPath)
  }

  // Header & Footer
  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
      case UICollectionView.elementKindSectionHeader:
        let headerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: EmptyCollectionReusableView.identifier,
          for: indexPath
        )
        return headerView

      case UICollectionView.elementKindSectionFooter:
        let footerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: EmptyCollectionReusableView.identifier,
          for: indexPath
        )
        return footerView

      default:
        fatalError("Header Section")
    }
  }
}

// MARK: Actions
extension YDSpaceyViewController {
  func dequeueCell(at indexPath: IndexPath) -> UICollectionViewCell {
    guard let itemAndType = getItemAndType(at: indexPath) else {
      return UICollectionViewCell()
    }

    switch itemAndType.type {
    case .player:
      return UICollectionViewCell()
    case .product:
//      return dequeueProductCell(at: indexPath)
      return UICollectionViewCell()
    case .banner:
      return dequeueBannerCell(withBanner: itemAndType.type, at: indexPath)
    }
  }
}

// MARK: Carrousel Products
extension YDSpaceyViewController {
  func getProductsIds(at row: Int, onCompletion: @escaping ([String]) -> Void) {
//    viewModel?.getProductsIds(at: row, onCompletion: onCompletion)
  }

//  func dequeueProductCell(at indexPath: IndexPath) -> UICollectionViewCell {
//    guard let cell = collectionView.dequeueReusableCell(
//      withReuseIdentifier: YDLiveProductContainerCollectionViewCell.identifier,
//      for: indexPath) as? YDLiveProductContainerCollectionViewCell,
//          let component = getItemAndType(at: indexPath),
//          let viewModel = viewModel
//      else {
//        return UICollectionViewCell()
//    }
//
//    cell.widthConstraint.constant = collectionView.frame.size.width
//    cell.layoutIfNeeded()
//
//    getProductsIds(at: indexPath.row) { ids in
//      if viewModel.carrouselProducts[indexPath.row] == nil {
//        let carrouselContainer = YDSpaceyProductCarrouselContainer(
//          id: indexPath.row,
//          items: [],
//          ids: [],
//          pageNumber: -1,
//          currentRectList: nil
//        )
//        viewModel.carrouselProducts[indexPath.row] = carrouselContainer
//      }
//
//      let productsIds = ids.inBatches(ofSize: viewModel.productsBatchesSize)
//      viewModel.carrouselProducts[indexPath.row]?.ids = productsIds
//
//      cell.config(
//        with: indexPath.row,
//        headerTitle: component.item.component.showcaseTitle,
//        viewModel: viewModel
//      )
//    }
//
//    return cell
//  }
}

// MARK: Banner
extension YDSpaceyViewController {
  func dequeueBannerCell(
    withBanner bannerComponent: YDSpaceyComponentsTypes,
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SpaceyBannerCollectionViewCell.identifier,
      for: indexPath) as? SpaceyBannerCollectionViewCell,
      let banner = bannerComponent.get() as? YDSpaceyComponentBanner
      else {
        return UICollectionViewCell()
    }

    if viewModel?.bannersOnList[indexPath.row] == nil {
      viewModel?.bannersOnList[indexPath.row] = YDSpaceyBannerConfig(
        image: banner.bannerImage ?? "",
        bannerId: banner.deepLink ?? ""
      )
    }

    cell.config(
      withId: indexPath.row,
      viewModel: viewModel
    )
    return cell
  }
}

// MARK: Shimmer UITableView Data Source
extension YDSpaceyViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfShimmers
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: SpaceyBannerShimmerTableViewCell.identifier
    ) as? SpaceyBannerShimmerTableViewCell
    else {
      return UITableViewCell()
    }
    cell.config()

    return cell
  }
}

// MARK: Shimmer UITableView Delegate
extension YDSpaceyViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 96
  }

  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 28
  }

  public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 28
  }

  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }

  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }
}
