//
//  SpaceyViewController+Delegate.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 16/04/21.
//

import UIKit
import YDB2WModels

public protocol YDSpaceyDelegate: AnyObject {
  func onPlayerComponentID(_ videoId: String?)
  func onComponentsList(_ list: [YDSpaceyCommonStruct])
  func scrollViewDidScroll(_ scrollView: UIScrollView)
  func onChange(size: CGSize)
  func registerCustomCells(_ collectionView: UICollectionView)
}
