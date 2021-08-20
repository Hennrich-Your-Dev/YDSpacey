//
//  TrackingDelegate.swift
//  YDIntegration
//
//  Created by Douglas Hennrich on 27/10/20.
//  Copyright © 2020 YourDev. All rights reserved.
//

import Foundation

public protocol YDIntegrationHelperTrackingDelegate {
  func trackAdobeAction(actionName: String, parameters: [String: Any]?)
  func trackGAEvent(actionName: String, parameters: [String: Any]?)

  func trackAdobeState(stateName: String, parameters: [String: Any]?)
  func trackGAScreen(stateName: String, parameters: [String: Any]?)

  func trackFacebookEvent(eventName: String, parameters: [String: Any]?)
  func trackFirebaseEvent(eventName: String, parameters: [String: Any]?)
  func trackNewRelicEvent(eventName: String, parameters: [String: Any]?)
  func trackStuartEvent(namespace: String, eventName: String, parameters: [String: Any]?)
}
