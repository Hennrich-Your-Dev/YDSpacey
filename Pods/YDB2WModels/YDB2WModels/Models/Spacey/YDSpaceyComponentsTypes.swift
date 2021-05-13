//
//  YDSpaceyComponentsTypes.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 14/04/21.
//

import Foundation

public enum YDSpaceyComponentsTypes: Decodable {
  case banner(YDSpaceyComponentBanner)
  case bannerCarrousel(YDSpaceyComponentCarrouselBanner)
  case grid(YDSpaceyComponentGrid)
  case nextLive(YDSpaceyComponentNextLive)
  case player(YDSpaceyComponentPlayer)
  case product(YDSpaceyComponentProduct)
  case productCarrousel(YDSpaceyComponentCarrouselProduct)
  case title(YDSpaceyComponentTitle)

  enum CodingKeys: String, CodingKey {
    case type
  }

  public var componentType: `Types` {
    switch self {
      case .banner:
        return .banner

      case .bannerCarrousel:
        return .bannerCarrousel

      case .grid:
        return .grid

      case .nextLive:
        return .nextLive

      case .player:
        return .player

      case .product:
        return .product

      case .productCarrousel:
        return .productCarrousel

      case .title:
        return .title
    }
  }

  // Components Types
  public enum `Types`: String, Decodable {
    case banner = "zion-image"
    case bannerCarrousel = "zion-image-carousel"
    case grid = "zion-grid"
    case nextLive = "live-schedule-item"
    case player = "zion-video"
    case product = "zion-product"
    case productCarrousel = "live-carousel"
    case title = "zion-title"
  }

  // MARK: Init
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(Types.self, forKey: .type)
    let singleValueContainer = try decoder.singleValueContainer()

    switch type {
      case .banner:
        self = .banner(try singleValueContainer.decode(YDSpaceyComponentBanner.self))

      case .bannerCarrousel:
        self = .bannerCarrousel(
          try singleValueContainer.decode(YDSpaceyComponentCarrouselBanner.self)
        )

      case .grid:
        self = .grid(try singleValueContainer.decode(YDSpaceyComponentGrid.self))

      case .nextLive:
        self = .nextLive(try singleValueContainer.decode(YDSpaceyComponentNextLive.self))

      case .player:
        self = .player(try singleValueContainer.decode(YDSpaceyComponentPlayer.self))

      case .product:
        self = .product(try singleValueContainer.decode(YDSpaceyComponentProduct.self))

      case .productCarrousel:
        self = .productCarrousel(
          try singleValueContainer.decode(YDSpaceyComponentCarrouselProduct.self)
        )

      case .title:
        self = .title(try singleValueContainer.decode(YDSpaceyComponentTitle.self))
    }
  }

  public init(banner: YDSpaceyComponentBanner) {
    self = .banner(banner)
  }

  public init(bannerCarrousel: YDSpaceyComponentCarrouselBanner) {
    self = .bannerCarrousel(bannerCarrousel)
  }

  public init(grid: YDSpaceyComponentGrid) {
    self = .grid(grid)
  }

  public init(nextLive: YDSpaceyComponentNextLive) {
    self = .nextLive(nextLive)
  }

  public init(player: YDSpaceyComponentPlayer) {
    self = .player(player)
  }

  public init(product: YDSpaceyComponentProduct) {
    self = .product(product)
  }

  public init(productCarrousel: YDSpaceyComponentCarrouselProduct) {
    self = .productCarrousel(productCarrousel)
  }

  public init(title: YDSpaceyComponentTitle) {
    self = .title(title)
  }

  // MARK: Actions
  public func get() -> Any {
    switch self {
      case .banner(let banner):
        return banner

      case .bannerCarrousel(let carrousel):
        return carrousel

      case .grid(let grid):
        return grid

      case .nextLive(let nextLive):
        return nextLive

      case .player(let player):
        return player

      case .product(let product):
        return product

      case .productCarrousel(let carrousel):
        return carrousel

      case .title(let title):
        return title
    }
  }
}

extension YDSpaceyComponentsTypes: Equatable {
  // To be able to use [].contains(type)
  public static func == (lhs: YDSpaceyComponentsTypes, rhs: YDSpaceyComponentsTypes) -> Bool {
    if case .banner = lhs,
       case .banner = rhs {
      return true
    }

    if case .bannerCarrousel = lhs,
       case .bannerCarrousel = rhs {
      return true
    }

    if case .grid = lhs,
       case .grid = rhs {
      return true
    }

    if case .nextLive = lhs,
       case .nextLive = rhs {
      return true
    }

    if case .player = lhs,
       case .player = rhs {
      return true
    }

    if case .product = lhs,
       case .product = rhs {
      return true
    }

    if case .productCarrousel = lhs,
       case .productCarrousel = rhs {
      return true
    }

    if case .title = lhs,
       case .title = rhs {
      return true
    }

    return false
  }
}
