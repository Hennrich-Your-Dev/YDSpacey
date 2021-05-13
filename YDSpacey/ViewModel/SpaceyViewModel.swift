//
//  SpaceyViewModel.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 14/04/21.
//

import Foundation

import YDExtensions
import YDB2WModels
import YDUtilities
import YDB2WServices

protocol SpaceyViewModelDelegate: AnyObject {
  var loading: Binder<Bool> { get }
  var error: Binder<String> { get }
  var spacey: Binder<YDB2WModels.YDSpacey?> { get }
  var componentsList: Binder<[YDSpaceyCommonStruct]> { get }
  var playerComponent: Binder<YDSpaceyComponentPlayer?> { get }

  var bannersOnList: [Int: YDSpaceyBannerConfig] { get set }
  var spaceyOrder: [String] { get }

  func getSpacey(withId id: String)
  func getComponentAndType(
    at indexPath: IndexPath
  ) -> (component: YDSpaceyCommonComponent?, type: YDSpaceyComponentsTypes.Types?)
}

class SpaceyViewModel {
  // Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let supportedTypes: [YDSpaceyComponentsTypes.Types]

  var loading: Binder<Bool> = Binder(false)
  var error: Binder<String> = Binder("")
  var spacey: Binder<YDB2WModels.YDSpacey?> = Binder(nil)
  var componentsList: Binder<[YDSpaceyCommonStruct]> = Binder([])
  var playerComponent: Binder<YDSpaceyComponentPlayer?> = Binder(nil)

  var bannersOnList: [Int: YDSpaceyBannerConfig] = [:]
  var spaceyOrder: [String] = []
  var spaceyId = ""

  // Init
  init(
    service: YDB2WServiceDelegate = YDB2WService(),
    supportedTypes: [YDSpaceyComponentsTypes.Types]
  ) {
    self.service = service
    self.supportedTypes = supportedTypes
  }

  // MARK: Actions
  func buildList(with spacey: YDB2WModels.YDSpacey) {
    var list: [YDSpaceyCommonStruct] = []
    var components: [YDSpaceyCommonStruct] = []

    if spaceyOrder.isEmpty {
      components = spacey.allComponents()
    } else {
      for property in spaceyOrder {
        if let obj = spacey[property] {
          components.append(obj)
        }
      }
    }

    for curr in components {
      guard let type = curr.component.type,
      supportedTypes.contains(type)
      else {
        continue
      }

      switch type {
        case .bannerCarrousel:
          list.append(curr)

        case .productCarrousel:
          list.append(curr)

        default:
          guard let children = curr.component.children
          else {
            continue
          }

          for component in children {
            if let data = buildData(from: component, parent: curr) {
              list.append(data)
            }
          }
      }
    }

    componentsList.value = list
    loading.value = false
  }

  func buildData(
    from component: YDSpaceyComponentsTypes,
    parent: YDSpaceyCommonStruct
  ) -> YDSpaceyCommonStruct? {
    if !supportedTypes.contains(component.componentType) { return nil }

    switch component {
      case .banner(let banner):
        let obj = extractData(from: banner)
        obj.children = [component]
        return YDSpaceyCommonStruct(id: obj.id, component: obj)

      case .bannerCarrousel:
        return parent

      case .grid(let grid):
        if grid.layout == .vertical,
           let children = grid.children {
          for curr in children {
            return buildData(from: curr, parent: parent)
          }
        } else {
          return nil
        }

      case .player(let player):
        playerComponent.value = player

      case .product:
        return parent

      case .title(let title):
        let obj = extractData(from: title)
        obj.children = [component]

        return YDSpaceyCommonStruct(id: obj.id, component: obj)

      default:
        return nil
    }

    return nil
  }
}

// MARK: Extract SpaceyCommonComponent
extension SpaceyViewModel {
  // Banner
  func extractData(from banner: YDSpaceyComponentBanner) -> YDSpaceyCommonComponent {
    return YDSpaceyCommonComponent(
      id: banner.id,
      children: [],
      type: banner.componentType
    )
  }

  // Title
  func extractData(from title: YDSpaceyComponentTitle) -> YDSpaceyCommonComponent {
    return YDSpaceyCommonComponent(
      id: title.id,
      children: [],
      type: title.componentType
    )
  }
}

// MARK: Delegate
extension SpaceyViewModel: SpaceyViewModelDelegate {
  func getSpacey(withId id: String) {
    loading.value = true

    service.getSpacey(
      spaceyId: id
    ) { [weak self] (response: Result<YDB2WModels.YDSpacey, YDB2WServices.YDServiceError>) in
      guard let self = self else { return }
      switch response {
        case .success(let spacey):
          self.buildList(with: spacey)
          self.spacey.value = spacey
//          guard let spaceyMock = self.mock() else { return }
//          self.buildList(with: spaceyMock)
//          self.spacey.value = spaceyMock

        case .failure(let error):
          self.error.value = error.message
          self.loading.value = false
      }
    }
  }

  func getComponentAndType(
    at indexPath: IndexPath
  ) -> (component: YDSpaceyCommonComponent?, type: YDSpaceyComponentsTypes.Types?) {
    guard let parent = componentsList.value.at(indexPath.row),
          let type = parent.component.type
    else {
      return (nil, nil)
    }

    return (parent.component, type)
  }
}

// MARK: Mock
extension SpaceyViewModel {
  func mock() -> YDB2WModels.YDSpacey? {
    let dataString = """
    {
      "contenttop3": {
        "_id": "5f358ba5b6c365004830da11",
        "name": "[TESTE]  hotsite-live-teste-nativo-carousel",
        "position": "contenttop3",
        "component": {
          "_id": "5f358ba50f2c60002f8bdd07",
          "type": "live-carousel",
          "showcaseTitle": "produtos da live",
          "tag": "",
          "sortBy": "Mais Relevantes",
          "key": "",
          "title": "Nome da area",
          "children": [
            {
              "_id": "5fa9c6affb1f740024b476a9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1205606479",
              "type": "zion-product",
              "title": "1205606479",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476aa",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1830309411",
              "type": "zion-product",
              "title": "1830309411",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ab",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1257644055",
              "type": "zion-product",
              "title": "1257644055",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ac",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1755566070",
              "type": "zion-product",
              "title": "1755566070",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ad",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1222836680",
              "type": "zion-product",
              "title": "1222836680",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ae",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "589299518",
              "type": "zion-product",
              "title": "589299518",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476af",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2020556891",
              "type": "zion-product",
              "title": "2020556891",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1846868031",
              "type": "zion-product",
              "title": "1846868031",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b1",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1635437046",
              "type": "zion-product",
              "title": "1635437046",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b2",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2051476181",
              "type": "zion-product",
              "title": "2051476181",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b3",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1975479592",
              "type": "zion-product",
              "title": "1975479592",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b4",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2024373282",
              "type": "zion-product",
              "title": "2024373282",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b5",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1771446730",
              "type": "zion-product",
              "title": "1771446730",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b6",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1743251855",
              "type": "zion-product",
              "title": "1743251855",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b7",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1393452251",
              "type": "zion-product",
              "title": "1393452251",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b8",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1733137320",
              "type": "zion-product",
              "title": "1733137320",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1982228433",
              "type": "zion-product",
              "title": "1982228433",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ba",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1434089330",
              "type": "zion-product",
              "title": "1434089330",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bb",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1524318765",
              "type": "zion-product",
              "title": "1524318765",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bc",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2034709982",
              "type": "zion-product",
              "title": "2034709982",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bd",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "588887131",
              "type": "zion-product",
              "title": "588887131",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476be",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1911585011",
              "type": "zion-product",
              "title": "1911585011",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bf",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1846776241",
              "type": "zion-product",
              "title": "1846776241",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1913100680",
              "type": "zion-product",
              "title": "1913100680",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c1",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1862722269",
              "type": "zion-product",
              "title": "1862722269",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c2",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1911813889",
              "type": "zion-product",
              "title": "1911813889",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c3",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1836750098",
              "type": "zion-product",
              "title": "1836750098",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c4",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1915415853",
              "type": "zion-product",
              "title": "1915415853",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c5",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1225212223",
              "type": "zion-product",
              "title": "1225212223",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c6",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1693694577",
              "type": "zion-product",
              "title": "1693694577",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c7",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2005839121",
              "type": "zion-product",
              "title": "2005839121",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c8",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1904602426",
              "type": "zion-product",
              "title": "1904602426",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1393452251",
              "type": "zion-product",
              "title": "1393452251",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ca",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1610734888",
              "type": "zion-product",
              "title": "1610734888",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cb",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1956503770",
              "type": "zion-product",
              "title": "1956503770",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cc",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1235277135",
              "type": "zion-product",
              "title": "1235277135",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cd",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1755526078",
              "type": "zion-product",
              "title": "1755526078",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ce",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1831046608",
              "type": "zion-product",
              "title": "1831046608",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cf",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1222602787",
              "type": "zion-product",
              "title": "1222602787",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476d0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1635443075",
              "type": "zion-product",
              "title": "1635443075",
              "children": []
            }
          ],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "recmaintop3": {
        "_id": "5f358ba5b6c365004830da11",
        "name": "[TESTE]  hotsite-live-teste-nativo-carousel",
        "position": "recmaintop3",
        "component": {
          "_id": "5f358ba50f2c60002f8bdd07",
          "type": "live-carousel",
          "showcaseTitle": "produtos da live",
          "tag": "",
          "sortBy": "Mais Relevantes",
          "key": "",
          "title": "Nome da area",
          "children": [
            {
              "_id": "5fa9c6affb1f740024b476a9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1205606479",
              "type": "zion-product",
              "title": "1205606479",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476aa",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1830309411",
              "type": "zion-product",
              "title": "1830309411",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ab",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1257644055",
              "type": "zion-product",
              "title": "1257644055",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ac",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1755566070",
              "type": "zion-product",
              "title": "1755566070",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ad",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1222836680",
              "type": "zion-product",
              "title": "1222836680",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ae",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "589299518",
              "type": "zion-product",
              "title": "589299518",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476af",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2020556891",
              "type": "zion-product",
              "title": "2020556891",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1846868031",
              "type": "zion-product",
              "title": "1846868031",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b1",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1635437046",
              "type": "zion-product",
              "title": "1635437046",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b2",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2051476181",
              "type": "zion-product",
              "title": "2051476181",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b3",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1975479592",
              "type": "zion-product",
              "title": "1975479592",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b4",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2024373282",
              "type": "zion-product",
              "title": "2024373282",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b5",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1771446730",
              "type": "zion-product",
              "title": "1771446730",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b6",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1743251855",
              "type": "zion-product",
              "title": "1743251855",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b7",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1393452251",
              "type": "zion-product",
              "title": "1393452251",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b8",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1733137320",
              "type": "zion-product",
              "title": "1733137320",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476b9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1982228433",
              "type": "zion-product",
              "title": "1982228433",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ba",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1434089330",
              "type": "zion-product",
              "title": "1434089330",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bb",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1524318765",
              "type": "zion-product",
              "title": "1524318765",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bc",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2034709982",
              "type": "zion-product",
              "title": "2034709982",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bd",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "588887131",
              "type": "zion-product",
              "title": "588887131",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476be",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1911585011",
              "type": "zion-product",
              "title": "1911585011",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476bf",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1846776241",
              "type": "zion-product",
              "title": "1846776241",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1913100680",
              "type": "zion-product",
              "title": "1913100680",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c1",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1862722269",
              "type": "zion-product",
              "title": "1862722269",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c2",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1911813889",
              "type": "zion-product",
              "title": "1911813889",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c3",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1836750098",
              "type": "zion-product",
              "title": "1836750098",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c4",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1915415853",
              "type": "zion-product",
              "title": "1915415853",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c5",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1225212223",
              "type": "zion-product",
              "title": "1225212223",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c6",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1693694577",
              "type": "zion-product",
              "title": "1693694577",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c7",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "2005839121",
              "type": "zion-product",
              "title": "2005839121",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c8",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1904602426",
              "type": "zion-product",
              "title": "1904602426",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476c9",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1393452251",
              "type": "zion-product",
              "title": "1393452251",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ca",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1610734888",
              "type": "zion-product",
              "title": "1610734888",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cb",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1956503770",
              "type": "zion-product",
              "title": "1956503770",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cc",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1235277135",
              "type": "zion-product",
              "title": "1235277135",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cd",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1755526078",
              "type": "zion-product",
              "title": "1755526078",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476ce",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1831046608",
              "type": "zion-product",
              "title": "1831046608",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476cf",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1222602787",
              "type": "zion-product",
              "title": "1222602787",
              "children": []
            },
            {
              "_id": "5fa9c6affb1f740024b476d0",
              "featuredOfferText": "",
              "featuredOfferType": "nenhum",
              "price_apponly": "False",
              "crmkey": "",
              "spaceyQS": [],
              "options": "",
              "themeText": "dark",
              "backgroundColor": "",
              "backgroundImage": "",
              "href": "",
              "tag": "",
              "finalDate": "",
              "pitType": "ID",
              "productId": "1635443075",
              "type": "zion-product",
              "title": "1635443075",
              "children": []
            }
          ],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "hotsiteconfig": {
        "_id": "5f358956e6ad000035a833e4",
        "name": "[TESTE] hotsite-live-teste-nativo",
        "position": "hotsiteconfig",
        "component": {
          "_id": "5f3589560764780036ba15aa",
          "showCategories": "sim",
          "options": "",
          "sellerId": "",
          "content": "",
          "gridTag": "",
          "categoryId": "",
          "showBrandCardInstallment": "",
          "amePromoted": "",
          "hotsiteTitle": "live teste",
          "type": "zion-hotsite",
          "title": "Nome da area",
          "children": [],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "maintop2": {
        "_id": "5f35a032a186b300313bcfdb",
        "name": "[TESTE]  hotsite-live-teste-nativo-banner",
        "position": "maintop2",
        "component": {
          "_id": "5f35a031c8323d0053cc827c",
          "type": "zion-grid",
          "size": "Pequeno",
          "key1": "",
          "key2": "",
          "key3": "",
          "key4": "",
          "hr": "",
          "columnTitle": "",
          "xs": "Padrão",
          "sm": "Padrão",
          "md": "Padrão",
          "lg": "Padrão",
          "textAlign": "Esquerda",
          "options": "Espaçamento Externo, Espaçamento Lateral App, Bordas Arredondadas - App",
          "title": "Nome da area",
          "children": [
            {
              "_id": "5f35a59ebf01f7002fd71435",
              "small": "https://images-americanas.b2w.io/spacey/acom/2021/01/26/destaque_produto_live_kibon.png",
              "medium": "",
              "big": "",
              "large": "",
              "extralarge": "",
              "backgroundColor": "",
              "defaultSize": "small",
              "alternateText": "teste",
              "linkUrl": "acom://produto/132762411",
              "target": "Abrir na mesma aba",
              "idProduto": "",
              "tag": "",
              "hotsite": "",
              "linha": "",
              "departamento": "",
              "crmkey": "",
              "opa": "",
              "showBalloons": "não",
              "balloonsTitle": "",
              "balloonsDescription": "",
              "meta": {
                "small": {
                  "height": 108,
                  "width": 648
                }
              },
              "type": "zion-image",
              "title": "imagem 1",
              "children": []
            },
            {
              "_id": "5f35a59ebf01f7002fd71436",
              "balloonsDescription": "",
              "balloonsTitle": "",
              "showBalloons": "não",
              "opa": "",
              "crmkey": "",
              "departamento": "",
              "linha": "",
              "hotsite": "",
              "tag": "",
              "idProduto": "",
              "target": "Abrir na mesma aba",
              "linkUrl": "acom://produto/36216194",
              "alternateText": "teste",
              "defaultSize": "small",
              "backgroundColor": "",
              "extralarge": "",
              "large": "",
              "big": "",
              "medium": "",
              "small": "https://images-americanas.b2w.io/spacey/acom/2020/08/13/banner4_HS-LIVE_CAMILA_03_mobile.webp",
              "meta": {
                "small": {
                  "height": 108,
                  "width": 648
                }
              },
              "type": "zion-image",
              "title": "imagem 2",
              "children": []
            }
          ],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "maintop3": {
        "_id": "5f35a214868506002a32cbb2",
        "name": "[TESTE]  hotsite-live-teste-nativo-cupom",
        "position": "maintop3",
        "component": {
          "_id": "5f35a21459adde0048effe49",
          "type": "cross-cupom",
          "coupon": "live10",
          "meta": {
            "image": {
              "width": 432,
              "height": 162
            }
          },
          "image": "https://images-americanas.b2w.io/spacey/acom/2020/08/13/niver20__banner3_cashback.png",
          "imageMobile": "",
          "imageLink": "",
          "backgroundColor": "#d5d3d3",
          "infoText": "Válido para primeira compra.",
          "infoTextColor": "#5d5b5b",
          "infoLink": "",
          "isFirstLaunch": "não",
          "modalTopImageUrl": "",
          "modalBottomImageUrl": "",
          "title": "live10",
          "children": [],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "maintop1": {
        "_id": "5f35a6915d0c34006db66aa7",
        "name": "[TESTE]  hotsite-live-teste-nativo-video",
        "position": "maintop1",
        "component": {
          "_id": "5f35a691ba7305002f7655ed",
          "type": "zion-grid",
          "size": "Pequeno",
          "key1": "",
          "key2": "",
          "key3": "",
          "key4": "",
          "hr": "",
          "columnTitle": "",
          "xs": "Padrão",
          "sm": "Padrão",
          "md": "Padrão",
          "lg": "Padrão",
          "textAlign": "Esquerda",
          "options": "",
          "title": "Nome da area",
          "children": [
            {
              "_id": "5f35a691ba7305002f7655f2",
              "videoURL": "https://www.youtube.com/watch?v=5fKY31ETOVY",
              "size": "LARGE",
              "type": "zion-video",
              "title": "video teste",
              "children": []
            }
          ],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "reccontenttop1": {
        "_id": "5f35a032a186b300313bcfdb",
        "name": "[TESTE]  hotsite-live-teste-nativo-banner",
        "position": "maintop2",
        "component": {
          "_id": "5f35a031c8323d0053cc827c",
          "type": "zion-grid",
          "size": "Pequeno",
          "key1": "",
          "key2": "",
          "key3": "",
          "key4": "",
          "hr": "",
          "columnTitle": "",
          "xs": "Padrão",
          "sm": "Padrão",
          "md": "Padrão",
          "lg": "Padrão",
          "textAlign": "Esquerda",
          "options": "Espaçamento Externo, Espaçamento Lateral App, Bordas Arredondadas - App",
          "title": "Nome da area",
          "children": [
            {
              "_id": "5f35a59ebf01f7002fd71435",
              "small": "https://images-americanas.b2w.io/spacey/acom/2020/08/13/banner4_HS-LIVE_CAMILA_02_mobile.webp",
              "medium": "",
              "big": "",
              "large": "",
              "extralarge": "",
              "backgroundColor": "",
              "defaultSize": "small",
              "alternateText": "teste",
              "linkUrl": "acom://produto/132762411",
              "target": "Abrir na mesma aba",
              "idProduto": "",
              "tag": "",
              "hotsite": "",
              "linha": "",
              "departamento": "",
              "crmkey": "",
              "opa": "",
              "showBalloons": "não",
              "balloonsTitle": "",
              "balloonsDescription": "",
              "meta": {
                "small": {
                  "height": 108,
                  "width": 648
                }
              },
              "type": "zion-image",
              "title": "imagem 1",
              "children": []
            },
            {
              "_id": "5f35a59ebf01f7002fd71436",
              "balloonsDescription": "",
              "balloonsTitle": "",
              "showBalloons": "não",
              "opa": "",
              "crmkey": "",
              "departamento": "",
              "linha": "",
              "hotsite": "",
              "tag": "",
              "idProduto": "",
              "target": "Abrir na mesma aba",
              "linkUrl": "acom://produto/36216194",
              "alternateText": "teste",
              "defaultSize": "small",
              "backgroundColor": "",
              "extralarge": "",
              "large": "",
              "big": "",
              "medium": "",
              "small": "https://images-americanas.b2w.io/spacey/acom/2020/08/13/banner4_HS-LIVE_CAMILA_03_mobile.webp",
              "meta": {
                "small": {
                  "height": 108,
                  "width": 648
                }
              },
              "type": "zion-image",
              "title": "imagem 2",
              "children": []
            }
          ],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "contenttop2": {
        "_id": "5f35a214868506002a32cbb2",
        "name": "[TESTE]  hotsite-live-teste-nativo-cupom",
        "position": "maintop3",
        "component": {
          "_id": "5f35a21459adde0048effe49",
          "type": "cross-cupom",
          "coupon": "live10",
          "meta": {
            "image": {
              "width": 432,
              "height": 162
            }
          },
          "image": "https://images-americanas.b2w.io/spacey/acom/2020/08/13/niver20__banner3_cashback.png",
          "imageMobile": "",
          "imageLink": "",
          "backgroundColor": "#d5d3d3",
          "infoText": "Válido para primeira compra.",
          "infoTextColor": "#5d5b5b",
          "infoLink": "",
          "isFirstLaunch": "não",
          "modalTopImageUrl": "",
          "modalBottomImageUrl": "",
          "title": "live10",
          "children": [],
          "__v": 0
        },
        "segmentation_match": "",
        "region_match": []
      },
      "debug": {
        "component": {
          "type": "debug"
        },
        "time": "2020-12-04T16:00:58.914Z",
        "length": 5
      }
    }
    """.data(using: .utf8)

    guard let data = dataString,
          let spacey = try? JSONDecoder().decode(YDB2WModels.YDSpacey.self, from: data)
    else {
      return nil
    }

    return spacey
  }
}
