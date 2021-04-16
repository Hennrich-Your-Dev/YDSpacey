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
  var bannersOnList: [Int: YDSpaceyBannerConfig] { get set }
  var spaceyOrder: [String] { get }

  func getSpacey(withId id: String)
}

class SpaceyViewModel {
  // Properties
  lazy var logger = Logger.forClass(Self.self)
  let service: YDB2WServiceDelegate

  var loading: Binder<Bool> = Binder(false)
  var error: Binder<String> = Binder("")
  var spacey: Binder<YDB2WModels.YDSpacey?> = Binder(nil)
  var componentsList: Binder<[YDSpaceyCommonStruct]> = Binder([])
  var bannersOnList: [Int: YDSpaceyBannerConfig] = [:]
  var spaceyOrder: [String] = []
  var spaceyId = ""

  // Init
  init(service: YDB2WServiceDelegate = YDB2WService()) {
    self.service = service
  }

  // Actions
  func buildList(with spacey: YDB2WModels.YDSpacey) {
    var list: [YDSpaceyCommonStruct] = []

    if spaceyOrder.isEmpty {
      list = spacey.allComponents()
      //
    } else {
      //
      for property in spaceyOrder {
        if let obj = spacey[property],
           let componentType = obj.component.children?.first?.get() {

          if componentType as? YDSpaceyComponentPlayer != nil {
            continue
          }

          if componentType as? YDSpaceyComponentProduct != nil {
            list.append(obj)
            continue
          }

          if let children = obj.component.children {
            children.forEach { curr in
              let component = YDSpaceyCommonComponent(
                id: obj.id,
                children: [curr],
                type: obj.component.type,
                showcaseTitle: obj.component.showcaseTitle
              )

              let container = YDSpaceyCommonStruct(id: obj.id, component: component)
              list.append(container)
            }

          } else {
            list.append(obj)
          }
        }
      }
    }

    componentsList.value = list
    loading.value = false
  }
}

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

        case .failure(let error):
          self.error.value = error.message
          self.loading.value = false
      }
    }
  }
}
