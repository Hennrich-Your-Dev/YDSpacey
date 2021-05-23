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

public protocol YDSpaceyViewModelDelegate: AnyObject {
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
  ) -> (
    component: YDSpaceyComponentDelegate?,
    type: YDSpaceyComponentsTypes.Types?
  )
}

public class YDSpaceyViewModel {
  // Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let supportedTypes: [YDSpaceyComponentsTypes.Types]
  let supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum]

  public var loading: Binder<Bool> = Binder(false)
  public var error: Binder<String> = Binder("")
  public var spacey: Binder<YDB2WModels.YDSpacey?> = Binder(nil)
  public var componentsList: Binder<[YDSpaceyCommonStruct]> = Binder([])
  public var playerComponent: Binder<YDSpaceyComponentPlayer?> = Binder(nil)

  public var bannersOnList: [Int: YDSpaceyBannerConfig] = [:]
  public var spaceyOrder: [String] = []
  var spaceyId = ""

  // Init
  public init(
    service: YDB2WServiceDelegate = YDB2WService(),
    supportedTypes: [YDSpaceyComponentsTypes.Types],
    supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum] = []
  ) {
    self.service = service
    self.supportedTypes = supportedTypes
    self.supportedNPSAnswersTypes = supportedNPSAnswersTypes
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
      guard let type = curr.component?.type,
        supportedTypes.contains(type),
        let children = curr.component?.children
      else {
        continue
      }

      switch type {
        case .bannerCarrousel:
          list.append(curr)

        case .productCarrousel:
          list.append(curr)

        default:
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
        for curr in grid.children {
          return buildData(from: curr, parent: parent)
        }

      case .player(let player):
        playerComponent.value = player

      case .product:
        return parent

      case .title(let title):
        let obj = extractData(from: title)
        obj.children = [component]

        return YDSpaceyCommonStruct(id: obj.id, component: obj)

      case .nps(let nps):
        for curr in nps.children {
          return buildData(from: curr, parent: parent)
        }

      case .npsQuestion(let nps):
        if supportedNPSAnswersTypes.isEmpty {
          return YDSpaceyCommonStruct(id: nps.id, component: nps)
        } else {
          if supportedNPSAnswersTypes.contains(nps.answerType) {
            return YDSpaceyCommonStruct(id: nps.id, component: nps)
          }
        }

      default:
        return nil
    }

    return nil
  }
}

// MARK: Extract SpaceyCommonComponent
public extension YDSpaceyViewModel {
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

  // NPS Question
//  func extractData(from npsQuestion: YDSpaceyComponentNPSQuestion) -> YDSpaceyComponentNPSQuestion {
//
//  }
}

// MARK: Delegate
extension YDSpaceyViewModel: YDSpaceyViewModelDelegate {
  public func getSpacey(withId id: String) {
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

  public func getComponentAndType(
    at indexPath: IndexPath
  ) -> (
    component: YDSpaceyComponentDelegate?,
    type: YDSpaceyComponentsTypes.Types?
  ) {
    guard let parent = componentsList.value.at(indexPath.row),
          let type = parent.component?.type
    else {
      return (nil, nil)
    }
    return (parent.component, type)
  }
}

// MARK: Mock
public extension YDSpaceyViewModel {
  func mock() -> YDB2WModels.YDSpacey? {
    let bundle = Bundle(for: Self.self)
    guard let file = getLocalFile(bundle, fileName: "mock", fileType: "json"),
          let spacey = try? JSONDecoder().decode(YDB2WModels.YDSpacey.self, from: file)
      else {
      return nil
    }

    return spacey
  }
}
