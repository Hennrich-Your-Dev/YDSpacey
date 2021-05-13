//
//  YDSpaceyViewController+ProductsCarrousel.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 13/05/21.
//

import UIKit

import YDB2WModels

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
