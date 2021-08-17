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
import YDB2WIntegration

public protocol YDSpaceyViewModelDelegate: AnyObject {
  var loading: Binder<Bool> { get }
  var error: Binder<String> { get }
  var spacey: Binder<YDB2WModels.YDSpacey?> { get }
  var spaceyId: String { get }
  
  var nextLiveDelegate: YDSpaceyViewModelNextLiveDelegate? { get set }
  
  var componentsList: Binder<[YDSpaceyCommonStruct]> { get set }
  var playerComponent: Binder<YDSpaceyComponentPlayer?> { get }
  var firstNextLive: Binder<YDSpaceyComponentNextLive?> { get }

  var bannersOnList: [Int: YDSpaceyBannerConfig] { get set }
  var spaceyOrder: [String] { get }
  var spaceyNPSPreviewQuantity: Int { get }

  func getSpacey(withId id: String, customApi: String?)
  func getComponentAndType(
    at indexPath: IndexPath
  ) -> (
    component: YDSpaceyComponentDelegate?,
    type: YDSpaceyComponentsTypes.Types?
  )
  func sendMetric(name: TrackEvents, type: TrackType, parameters: [String: Any])
  
  func openNextLives()
  func saveNextLiveOnCalendar(
    live: YDSpaceyComponentNextLive,
    onCompletion completion: @escaping (_ success: Bool) -> Void
  )
}

public class YDSpaceyViewModel {
  // Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate
  let supportedTypes: [YDSpaceyComponentsTypes.Types]
  let supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum]
  
  public weak var nextLiveDelegate: YDSpaceyViewModelNextLiveDelegate?

  public var loading: Binder<Bool> = Binder(false)
  public var error: Binder<String> = Binder("")
  public var spacey: Binder<YDB2WModels.YDSpacey?> = Binder(nil)
  public var componentsList: Binder<[YDSpaceyCommonStruct]> = Binder([])
  public var playerComponent: Binder<YDSpaceyComponentPlayer?> = Binder(nil)
  public var firstNextLive: Binder<YDSpaceyComponentNextLive?> = Binder(nil)

  public var bannersOnList: [Int: YDSpaceyBannerConfig] = [:]
  public var spaceyOrder: [String] = []
  public var spaceyId = ""
  public var spaceyNPSPreviewQuantity = 0

  // Init
  public init(
    service: YDB2WServiceDelegate = YDB2WService(),
    supportedTypes: [YDSpaceyComponentsTypes.Types]?,
    supportedNPSAnswersTypes: [YDSpaceyComponentNPSQuestion.AnswerTypeEnum]?
  ) {
    self.service = service
    self.supportedTypes = supportedTypes ?? YDSpaceyComponentsTypes.Types.allCases
    self.supportedNPSAnswersTypes = supportedNPSAnswersTypes ?? YDSpaceyComponentNPSQuestion.AnswerTypeEnum.allCases
    
    if let spaceyOrder = YDIntegrationHelper.shared
        .getFeature(featureName: YDConfigKeys.spaceyService.rawValue)?
        .extras?[YDConfigProperty.liveSpaceyOrder.rawValue] as? [String] {
      self.spaceyOrder = spaceyOrder
    }
  }

  // MARK: Actions
  func buildList(with spacey: YDB2WModels.YDSpacey) {
    var list: [YDSpaceyCommonStruct] = []
    var components: [YDSpaceyCommonStruct] = []

    if spaceyOrder.isEmpty {
      components = spacey.allComponents()
    } else {
      var tempList: [[String: YDSpaceyCommonStruct]] = []
      for property in spaceyOrder {
        if let obj = spacey[property] {
          tempList.append([property: obj])
        }
      }

      let filteredList = spacey.items.filter { curr in
        return !tempList.contains(where: { $0.keys.first == curr.key })
      }.compactMap { $0.value }

      components = tempList.map { $0.values.first }.compactMap { $0 }
      for curr in filteredList {
        components.append(curr)
      }
    }

    for curr in components {
      guard let type = curr.component?.type,
        supportedTypes.contains(type),
        let children = curr.component?.children
      else {
        continue
      }

      if type == .nps,
         let npsComponent = curr.component as? YDSpaceyComponentNPS,
         let quantity = npsComponent.previewQuantity {
        self.spaceyNPSPreviewQuantity = quantity
      }

      switch type {
        case .bannerCarrousel:
          list.append(curr)

        case .productCarrousel:
          list.append(curr)

          #warning("Stand by")
//        case .grid:
//          curr.component?.children = conformSupportedTimesInside(children: children)
//          if (curr.component?.children ?? []).isEmpty {
//            continue
//          } else {
//            list.append(curr)
//          }

        case .liveNPS:
          list.append(curr)

        case .termsOfUse:
          list.append(curr)

        case .custom:
          list.append(curr)

        case .nextLiveParent:
          if let component = curr.component?.children
              .first?.get() as? YDSpaceyComponentNextLive {
            firstNextLive.value = component
          } else {
            firstNextLive.value = nil
          }
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

  func conformSupportedTypesInside(
    children: [YDSpaceyComponentsTypes]
  ) -> [YDSpaceyComponentsTypes] {
    return children.filter {
      if supportedTypes.contains($0.componentType) {
        if $0.componentType == .player,
           let player = $0.get() as? YDSpaceyComponentPlayer {
          playerComponent.value = player
          return false
        } else if $0.componentType == .grid,
                  let grid = $0.get() as? YDSpaceyComponentGrid {
          grid.children = conformSupportedTypesInside(children: grid.children)
          return true
        } else {
          return true
        }
      }

      return false
    }
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

      case .player(let player):
        playerComponent.value = player

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

      case .npsEditText(let nps):
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
}

// MARK: Delegate
extension YDSpaceyViewModel: YDSpaceyViewModelDelegate {
  public func getSpacey(withId id: String, customApi: String? = nil) {
    loading.value = true
    spaceyId = id

    service.getSpacey(
      spaceyId: id,
      customApi: customApi
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

  public func sendMetric(name: TrackEvents, type: TrackType, parameters: [String: Any]) {
    YDIntegrationHelper.shared
      .trackEvent(withName: name, ofType: type, withParameters: parameters)
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
