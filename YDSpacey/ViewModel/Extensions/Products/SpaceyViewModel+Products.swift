//
//  SpaceyViewModel+Products.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 30/09/21.
//

import Foundation
import YDB2WModels
import YDB2WServices

// MARK: Product Delegate
public protocol YDSpaceyViewModelProductDelegate: AnyObject {
  func selectProductOnCarrousel(_ product: YDSpaceyProduct)
  func addProductToCart(_ product: YDSpaceyProduct, with parameters: [String : Any])
}

extension YDSpaceyViewModel {
  public func getProductsIds(
    at: Int,
    onCompletion: @escaping ([ (id: String, sellerId: String) ]) -> Void
  ) {
    guard let componentChildrens = componentsList.value.at(at)?.component?.children else {
      return
    }

    var ids: [ (id: String, sellerId: String) ] = []

    componentChildrens.forEach { curr in
      if case .product(let product) = curr {
        ids.append((id: product.productId, sellerId: product.sellerId ?? ""))
      }
    }

    onCompletion(ids)
  }
  
  public func getProducts(
    ofIds ids: [ (id: String, sellerId: String) ],
    onCompletion completion: @escaping (Result<[YDSpaceyProduct], YDServiceError>) -> Void
  ) {
    var products: [YDSpaceyProduct] = []

    let group = DispatchGroup()

    for curr in ids {
      group.enter()
      
      service.getProduct(ofIds: curr) { response in
        group.leave()
        switch response {
          case .success(let product):
            let avaliation = YDSpaceyProductRating(
              average: product.rating ?? 0,
              recommendations: 0,
              reviews: product.numReviews ?? 0
            )

            let liveProduct = YDSpaceyProduct(
              description: product.description,
              id: product.productId,
              images: product.images,
              name: product.name,
              price: product.price,
              priceConditions: product.priceConditions,
              ean: product.ean,
              rating: avaliation,
              partnerId: product.partnerId,
              stock: product.stock
            )

            products.append(liveProduct)

          case .failure(let error):
            print("@@@@@", error.message)
        }
      }
    }

    group.wait()
    completion(.success(products))
  }
  
  public func selectProductOnCarrousel(_ product: YDSpaceyProduct) {
    productDelegate?.selectProductOnCarrousel(product)
  }
  
  public func addProductToCart(_ product: YDSpaceyProduct, with parameters: [String : Any]) {
    productDelegate?.addProductToCart(product, with: parameters)
  }
}
