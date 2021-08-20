//
//  TrackingEventsEnum.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import Foundation

public enum TrackType: String {
  case state
  case action
}

public enum TrackEvents: String {
  // Module Scan
  case scan = "ACOM:LASA-Scan"
  case scanProduct = "ACOM:LASA-Scan:Produto"
  case productDetails = "ACOM:LASA-Scan:Produto:Detalhes"

  // Live
  case pageView = "ACOM:hotsite:youtube-live"
  case playVideo = "ACOM:Video:Playing"
  case productSelected = "ACOM:LiveCarousel:ProductSelected"
  case addToCart
  case liveOpenChat
  case liveNPS = "quizz"
  case sendLike = "MobileApps:LiveLikes"
  
  case hotsiteLive = "ACOM:hotsite:aovivo"

  // Pre Live
  case preLivePageView
  case preLiveVideoPlay
  case preLiveSchedulePushNotification
  case preLiveAddToCalendar
  case preLiveOpenNextLives
  
  // After Live
  case afterLive = "ACOM:hotsite:aovivo:after"
  case afterLiveAddToCalendar
  case afterLiveSchedulePushNotification
  case afterLiveOpenNextLives

  // Next Lives
  case nextLivesPageView = "ACOM:Hotsite:youtube-live:proximas-lives"
  case nextLivesAddToCalendar = "ACOM:Hotsite:youtube-live:proximas-lives:adicionar-calendario"

  // Store Mode
  case storePageView = "ACOM:MODOLOJA-Home"
  case storeOpenBasket = "ModoLoja-Home-VerProdutos"
  case storeOpenBooklet = "O2O-ModoLoja-EncarteDasLojas"
  case storeOnScan = "O2O-ModoLoja-Scan"
  case storeOpenMap = "O2O-Home-Mapa"

  // Store Mode NPS
  case storeModeNPS = "ACOM:ModoLoja:NpsLoja"
  case sendNPS = "StoreModeNps"

  // Find a Store
  case findStoreView = "ACOM:StoreFinder:Mapa"
  case findStoreViewDenied = "ACOM:StoreFinder:SemPermissao"
  case findStore = "ACOM:AcheUmaLoja"

  // Offline Account
  case offlineAccountPerfil = "ACOM:MODOLOJA-MeuPerfil"
  case offlineAccountUsersInfo = "ACOM:MODOLOJA-DadosAtualizados"
  case offlineAccountModalNonexistent = "ACOM:OfflineAccount:ModalCadastroInexistente"
  case offlineAccountModalIncomplete = "ACOM:OfflineAccount:ModalCadastroIncompleto"
  case offlineAccountModalError = "ACOM:OfflineAccount:ModalErro"
  case offlineAccountHistoric = "ACOM:MODOLOJA-Historico"
  case offlineAccountTerms = "ACOM:MODOLOJA-TermoseCondicoes"

  // Offline Orders
  case offlineOrders = "ACOM:MODOLOJA-MinhasCompras"
  
  public var eventName: String {
    switch self {
      case .addToCart, .pageView, .liveOpenChat:
        return TrackEvents.pageView.rawValue
        
      case .preLivePageView,
           .preLiveVideoPlay,
           .preLiveSchedulePushNotification,
           .preLiveAddToCalendar,
           .preLiveOpenNextLives:
        return  TrackEvents.hotsiteLive.rawValue
        
      case .afterLive,
           .afterLiveAddToCalendar,
           .afterLiveSchedulePushNotification,
           .afterLiveOpenNextLives:
        return TrackEvents.afterLive.rawValue
      
      default:
        return self.rawValue
    }
  }

  // Default Parameters
  public var defaultParameters: [String: Any] {
    switch self {
      // Scan
      case .scan, .scanProduct, .productDetails:
        return ["tipoPagina": "LASA-Scan"]

      // Live
      case .playVideo, .productSelected, .sendLike:
        return [:]
        
      case .liveOpenChat:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "chat"
        ]
        
      case .addToCart:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar a cesta"
        ]
        
      case .pageView, .hotsiteLive:
        return ["pagetype": "Hotsite"]
        
      case .liveNPS:
        return ["platform": "iOS"]
        
      // Pre Live
      case .preLivePageView, .nextLivesPageView:
        return ["pagetype": "Hotsite"]
        
      case .preLiveVideoPlay:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "play"
        ]
        
      case .preLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .preLiveAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .preLiveOpenNextLives:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "programacao completa",
          "eventLabel": "0"
        ]
        
      // After Live
      case .afterLive:
        return [:]
        
      case .afterLiveAddToCalendar:
        return [
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      case .afterLiveOpenNextLives:
        return [
          "category": "live",
          "action": "programacao completa"
        ]
        
      case .afterLiveSchedulePushNotification:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "adicionar calendario"
        ]
        
      // Next Lives
      case .nextLivesAddToCalendar:
        return [
          "pagetype": "Hotsite",
          "category": "live",
          "action": "agendamento"
        ]

      // Store
      case .storePageView, .storeOpenBasket, .storeOpenBooklet, .storeOnScan, .storeOpenMap:
        return ["tipoPagina": "O2O-modoloja"]

      // Store Mode NPS
      case .storeModeNPS:
        return ["pageType": "O2O-modoloja"]

      case .sendNPS:
        return [:]

      // Find a Store
      case .findStoreView, .findStoreViewDenied:
        return [:]

      case .findStore:
        return  ["pageType": "O2O-modoloja"]

      // Offline Account
      case .offlineAccountPerfil, .offlineAccountUsersInfo,
           .offlineAccountModalNonexistent, .offlineAccountModalIncomplete,
           .offlineAccountModalError, .offlineAccountHistoric, .offlineAccountTerms:
        return [:]

      // Offline Orders
      case .offlineOrders:
        return [:]
    }
  }

  // Parameters
  public func parameters(body: [String: Any]) -> [String: Any] {
    switch self {
      // Scan
      case .scan, .scanProduct, .productDetails:
        return [:]

      // Live
      case .pageView:
        let videoId = body["videoId"] as? String ?? ""

        return [
          "tipoPagina": "Hotsite",
          "&&pageName": "ACOM:Hotsite:youtube-live",
          "deepLinkUrl": "acom://navigation/hotsite/youtube-live?videoId=\(videoId)&autoplay=true",
          "slugPath": "/hotsite/youtube-live?videoId=\(videoId)&autoplay=true"
        ]

      case .playVideo:
        let videoId = body["videoId"] as? String ?? ""

        return ["videoId": videoId]

      case .addToCart:
        let productId = body["productId"] as? String ?? ""
        let sku = body["productEan"] as? String ?? ""
        let sellerId = body["sellerId"] as? String ?? ""
        let liveName = body["liveName"] as? String ?? ""

        return [
          "productId": productId,
          "sku": sku,
          "sellerId": sellerId,
          "eventLabel": liveName
        ]

      case .productSelected:
        let productId = body["productId"] as? String ?? ""
        let sku = body["productEan"] as? String ?? ""
        let sellerId = body["sellerId"] as? String ?? ""

        return [
          "productId": productId,
          "sku": sku,
          "sellerId": sellerId
        ]
        
      case .hotsiteLive:
        return [:]

      case .liveOpenChat:
        return [
          "eventLabel": body["liveName"] as? String ?? ""
        ]
        
      case .liveNPS:
        let userId = body["userId"] as? String ?? ""
        let liveId = body["liveId"] as? String ?? ""
        let cardId = body["cardId"] as? String ?? ""
        let title = body["title"] as? String ?? ""
        let answer = body["value"] as? String ?? ""

        return [
          "customerId": userId,
          "liveId": liveId,
          "quizzId": cardId,
          "question": title,
          "answer": answer
        ]

      case .sendLike:
        return [:]
        
      // PreLive
      case .preLivePageView, .preLiveOpenNextLives:
        return [:]
        
      case .preLiveVideoPlay, .preLiveSchedulePushNotification, .preLiveAddToCalendar:
        return ["eventLabel": body["liveName"] as? String ?? ""]
        
      // After Live
      case .afterLive:
        return [:]
        
      case .afterLiveAddToCalendar, .afterLiveSchedulePushNotification, .afterLiveOpenNextLives:
        return ["eventLabel": body["liveName"] as? String ?? ""]

      // Next Lives
      case .nextLivesPageView:
        return [:]

      case .nextLivesAddToCalendar:
        let liveName = body["liveName"] as? String ?? ""

        return [
          "category": "live",
          "action": "agendamento",
          "eventLabel": liveName
        ]

      // Store
      case .storePageView:
        let locationEnable = body["locationEnable"] as? Bool ?? false
        return ["locationEnable": locationEnable]

      case .storeOpenBasket, .storeOpenBooklet, .storeOnScan, .storeOpenMap, .sendNPS:
        return [:]

      case .storeModeNPS:
        if body.isEmpty { return [:] }

        let question = body["question"] ?? ""
        let value = body["value"] ?? ""
        let starType = body["starType"] as? Bool ?? false

        var parameters: [String: Any] = [
          "category": "modoloja",
          "action": question
        ]

        if starType {
          parameters["nota"] = value
        } else {
          parameters["label"] = value
        }

        return parameters

      // Find a Store
      case .findStoreView, .findStoreViewDenied:
        return [:]

      case .findStore:
        let action = body["action"] as? String ?? ""

        return [
          "category": "ache uma loja",
          "action": action,
          "label": "sucesso"
        ]

      // Offline Account
      case .offlineAccountPerfil, .offlineAccountUsersInfo,
           .offlineAccountModalNonexistent, .offlineAccountModalIncomplete,
           .offlineAccountModalError, .offlineAccountHistoric, .offlineAccountTerms:
        return [:]

      // Offline Orders
      case .offlineOrders:
        return [:]
    }
  }
}

public enum TrackEventsNameSpace: String {
  case lives
}
