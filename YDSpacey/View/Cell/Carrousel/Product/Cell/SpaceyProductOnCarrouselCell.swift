//
//  SpaceyProductOnCarrouselCell.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 01/10/21.
//

import UIKit
import Cosmos
import YDExtensions
import YDB2WAssets
import YDB2WModels
import YDUtilities
import YDB2WComponents

class SpaceyProductOnCarrouselCell: UICollectionViewCell {
  // MARK: Properties
  var product: YDSpaceyProduct?
  var callbackProductTap: (() -> Void)?
  
  // MARK: Components
  let productImage = UIImageView()
  let productImageMaskImageView = UIView()
  let productTitleLabel = UILabel()
  let addProductButton = YDWireButton(withTitle: "adicionar à cesta")
  let priceInstallmentLabel = UILabel()
  let priceLabel = UILabel()
  let priceOneTimeLabel = UILabel()
  var productRate: CosmosView {
    let rateView = CosmosView()
    rateView.settings.emptyImage = Images.starGrey
    rateView.settings.filledImage = Images.starYellow
    rateView.settings.fillMode = .half
    rateView.settings.starMargin = 0
    rateView.settings.starSize = 12
    rateView.settings.totalStars = 5
    return rateView
  }
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    
    contentView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(onProductTap))
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life cycle
  override func prepareForReuse() {
    callbackProductTap = nil
    product = nil
    productImage.image = nil
    productTitleLabel.text = nil
    priceLabel.text = nil

    priceInstallmentLabel.text = nil
    priceInstallmentLabel.isHidden = false

    productRate.rating = 0
    productRate.text = ""
    productRate.isHidden = false
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.layer.applyShadow(alpha: 0.08, y: 6, blur: 20, spread: -1)
    contentView.layer.shadowPath = UIBezierPath(
      roundedRect: contentView.bounds,
      cornerRadius: 6
    ).cgPath
  }

  // MARK: Config
  func config(with product: YDSpaceyProduct) {
    self.product = product
    applyProduct()
  }
}

// MARK: Actions
extension SpaceyProductOnCarrouselCell {
  func onProductButtonAction() {
    guard let product = self.product else { return }

    product.onBasket.toggle()

    let parameters: [String: Any] = [
      "addToCard": product.onBasket,
      "productId": product.id ?? "",
      "sku": product.ean ?? "",
      "seller": product.partnerId ?? "",
      "skipServiceSelling": true,
      "openCartScreenAfterAdd": false
    ]

    NotificationCenter.default.post(
      name: YDConstants.Notification.SpaceyProductAddToCard,
      object: nil,
      userInfo: parameters
    )

    changeAddToCartButtonStyle(with: product)
  }
  
  @objc func onProductTap() {
    callbackProductTap?()
  }
  
  private func applyProduct() {
    guard let product = product else {
      return
    }

    productImage.setImage(product.images?.first)
    productImage.layer.cornerRadius = 6
    productImageMaskImageView.layer.cornerRadius = 6

    changeAddToCartButtonStyle(with: product)

    if let name = product.name {
      productTitleLabel.text = name
    }

    if let price = product.price {
      priceLabel.text = price
    }

    #warning("TODO")
    // achar parametro condinzente a "em 1x no cartão"
    priceOneTimeLabel.isHidden = true

    if let priceConditions = product.priceConditions {
      priceInstallmentLabel.text = priceConditions
      priceInstallmentLabel.isHidden = false
    } else {
      priceInstallmentLabel.isHidden = true
    }

    if let rating = product.rating,
       rating.reviews >= 1 {
      productRate.rating = rating.average
      productRate.text = "\(rating.reviews) \(rating.reviews > 1 ? "avaliações" : "avaliação")"
      productRate.isHidden = false

    } else {
      productRate.isHidden = true
    }

    if !product.productAvailable {
      setUnavailable()
    } else if product.onBasket {
      setOnBasket()
    } else {
      setAvailable()
    }
  }

  private func changeAddToCartButtonStyle(with product: YDSpaceyProduct) {
    product.onBasket ? setOnBasket() : setAvailable()
  }

  private func setAvailable() {
    addProductButton.setEnabled(true)
    addProductButton.setTitle("adicionar à cesta", for: .normal)
    addProductButton.setTitleColor(Zeplin.colorPrimaryLight, for: .normal)
    addProductButton.backgroundColor = Zeplin.white
    addProductButton.layer.borderColor = Zeplin.colorPrimaryLight.cgColor
  }

  private func setOnBasket() {
    addProductButton.backgroundColor = Zeplin.white
    addProductButton.layer.borderColor = Zeplin.grayLight.cgColor
    addProductButton.layer.borderColor = Zeplin.grayLight.cgColor

    addProductButton.setEnabled(false)
    addProductButton.setTitle("adicionado à cesta", for: .disabled)
    addProductButton.setTitleColor(Zeplin.grayLight, for: .disabled)
  }

  private func setUnavailable() {
    addProductButton.setEnabled(false)
    addProductButton.setTitle("produto indisponível", for: .disabled)
    addProductButton.setTitleColor(Zeplin.black, for: .disabled)

    addProductButton.layer.borderColor = Zeplin.grayDisabled.cgColor
    addProductButton.layer.borderColor = UIColor.clear.cgColor
    addProductButton.backgroundColor = Zeplin.grayDisabled
  }
}
