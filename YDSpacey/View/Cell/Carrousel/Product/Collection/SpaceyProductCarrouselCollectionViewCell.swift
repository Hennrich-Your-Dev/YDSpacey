//
//  SpaceyProductCarrouselCollectionViewCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 30/09/21.
//

import UIKit
import YDExtensions
import YDUtilities
import YDB2WModels

class SpaceyProductCarrouselCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  var viewModel: YDSpaceyViewModelDelegate?
  var carrouselId: Int = 0
  var previousItemsCount = 0
  
  var isLoading = false
  var canLoadMore = true
  var loadingView: SpaceyProductLoadingFooterView?
  
  var collectionViewOffset: CGFloat {
    get {
      return collectionView.contentOffset.x
    }
    set {
      collectionView.contentOffset.x = newValue
    }
  }
  
  let headerHeightConstant: CGFloat = 28
  let livePulseViewHeightConstant: CGFloat = 16
  
  var callbackProductTap: ((_ productId: String?) -> Void)?
  
  // MARK: Components
  lazy var width: NSLayoutConstraint = {
    let width = contentView.widthAnchor
      .constraint(equalToConstant: bounds.size.width)
    width.isActive = true
    return width
  }()
  
  let headerLabel = UILabel()
  lazy var headerLabelHeightConstraint: NSLayoutConstraint = {
    let height = headerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
    height.isActive = true
    return height
  }()
  lazy var headerLabelTrailingConstraint: NSLayoutConstraint = {
    let padding = headerLabel.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -16
    )
    return padding
  }()
  
  let livePulseView = UIView()
  lazy var livePulseViewHeightConstraint: NSLayoutConstraint = {
    let height = livePulseView.heightAnchor.constraint(equalToConstant: livePulseViewHeightConstant)
    height.isActive = true
    return height
  }()
  
  let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  override func prepareForReuse() {
    NotificationCenter.default.removeObserver(self)
    viewModel = nil
    previousItemsCount = 0
    canLoadMore = false
    collectionView.reloadData()
    livePulseView.isHidden = false
    livePulseView.stopPulsating()
    headerLabelHeightConstraint.constant = headerHeightConstant
    livePulseViewHeightConstraint.constant = livePulseViewHeightConstant
    headerLabelTrailingConstraint.constant = -16
    super.prepareForReuse()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: Config
  func config(
    with carrouselId: Int,
    headerTitle: String?,
    viewModel: YDSpaceyViewModelDelegate?,
    hasLivePulsing: Bool = false
  ) {
    self.carrouselId = carrouselId
    headerLabel.text = headerTitle
    collectionView.reloadData()

    let list = viewModel?.carrouselProducts[carrouselId]?.items ?? []
    
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      if list.isEmpty {
        layout.sectionInset = UIEdgeInsets(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0
        )
      } else {
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
      }
      
      layout.invalidateLayout()
    }

    collectionViewOffset = viewModel?.carrouselProducts[carrouselId]?.currentRectList ?? 0
    self.viewModel = viewModel
    loadMoreProducts()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onAddToCart),
      name: YDConstants.Notification.SpaceyProductAddToCard,
      object: nil
    )
    
    if headerTitle?.isEmpty ?? true {
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.livePulseView.isHidden = true
        self.headerLabelHeightConstraint.constant = 0
        self.livePulseViewHeightConstraint.constant = 0
      }
      return
    }

    guard hasLivePulsing else { return }
    
    headerLabelTrailingConstraint.constant = -66

    livePulseView.startPulsating()
    livePulseView.isHidden = false
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(startPulsatingView),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(startPulsatingView),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }
  
  func loadMoreProducts() {
    isLoading = true
    previousItemsCount = viewModel?.carrouselProducts[carrouselId]?.items.count ?? 0
    viewModel?.carrouselProducts[carrouselId]?.pageNumber += 1
    
    guard let currentBatchIds = viewModel?.carrouselProducts[carrouselId]?
            .ids.at(viewModel?.carrouselProducts[carrouselId]?.pageNumber ?? 0)
    else {
      DispatchQueue.main.async {
        self.canLoadMore = false
        self.isLoading = false
        self.collectionView.reloadData()
      }
      return
    }

    DispatchQueue.global().async { [weak self] in
      self?.viewModel?.getProducts(
        ofIds: currentBatchIds
      ) { result in
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          
          if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            layout.invalidateLayout()
          }

          switch result {
            case .success(let products):
              self.onLoadMoreSuccess(products: products)

            case .failure(let error):
              print(error.message)
              self.canLoadMore = true
              self.isLoading = false
          }
        }
      }
    }
  }
  
  func onLoadMoreSuccess(products: [YDSpaceyProduct]) {
    viewModel?.carrouselProducts[carrouselId]?.items.append(contentsOf: products)

    if (viewModel?.carrouselProducts[carrouselId]?.items.count ?? 0) > previousItemsCount {
      canLoadMore = true
    }

    previousItemsCount = viewModel?.carrouselProducts[carrouselId]?.items.count ?? 0
    isLoading = false

    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.collectionView.reloadData()
    }
  }
}

// MARK: Observers
extension SpaceyProductCarrouselCollectionViewCell {
  @objc func startPulsatingView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.livePulseView.startPulsating()
      self.livePulseView.layer.cornerRadius = 8
    }
  }

  @objc func stopPulsatingView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.livePulseView.stopPulsating()
      self.livePulseView.layer.cornerRadius = 8
    }
  }

  @objc func onAddToCart(_ notification: Notification) {
    guard let parameters = notification.userInfo as? [String: Any],
          let onBasket = parameters["addToCard"] as? Bool,
          let productId = parameters["productId"] as? String,
          let currentProduct = viewModel?.carrouselProducts[carrouselId]?.items.first(where: { $0.id == productId })
    else {
      return
    }

    currentProduct.onBasket = onBasket

    if onBasket {
      viewModel?.addProductToCart(currentProduct)
    }
  }
}

// MARK: View extension
fileprivate extension UIView {
  func startPulsating() {
    let layerAnim = CALayer()
    layerAnim.frame = self.bounds
    layerAnim.backgroundColor = Zeplin.redNight.cgColor
    layerAnim.cornerRadius = 8

    let layerAnim2 = CALayer()
    layerAnim2.frame = self.bounds
    layerAnim2.backgroundColor = Zeplin.redNight.cgColor
    layerAnim2.cornerRadius = 8

    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.fromValue = 0.4
    fadeOut.toValue = 0
    fadeOut.duration = 1.5

    let radiusAnim = CABasicAnimation(keyPath: "cornerRadius")
    radiusAnim.fromValue = 8
    radiusAnim.toValue = [8, 12, 16]
    radiusAnim.duration = 1.5

    let expandScale = CABasicAnimation()
    expandScale.keyPath = "transform"
    expandScale.valueFunction = CAValueFunction(name: CAValueFunctionName.scale)
    expandScale.fromValue = [1, 1, 1]
    expandScale.toValue = [1.5, 2, 1.5]
    expandScale.duration = 1.5

    let fadeAndScale = CAAnimationGroup()
    fadeAndScale.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale.duration = 1.5
    fadeAndScale.repeatCount = .infinity
    fadeAndScale.beginTime = CACurrentMediaTime()

    let fadeAndScale2 = CAAnimationGroup()
    fadeAndScale2.animations = [fadeOut, radiusAnim, expandScale]
    fadeAndScale2.duration = 1.5
    fadeAndScale2.repeatCount = .infinity
    fadeAndScale2.beginTime = CACurrentMediaTime() + 0.5

    layerAnim.add(fadeAndScale, forKey: "pulsatingAnimation")
    layerAnim2.add(fadeAndScale2, forKey: "pulsatingAnimation2")

    self.layer.insertSublayer(layerAnim, at: 0)
    self.layer.insertSublayer(layerAnim2, at: 0)
  }

  func stopPulsating() {
    layer.removeAnimation(forKey: "pulsatingAnimation")
    layer.removeAnimation(forKey: "pulsatingAnimation2")
    layer.sublayers?.first(where: { $0.name == "pulsatingAnimation" })?.removeFromSuperlayer()
    layer.sublayers?.first(where: { $0.name == "pulsatingAnimation2" })?.removeFromSuperlayer()
  }
}
