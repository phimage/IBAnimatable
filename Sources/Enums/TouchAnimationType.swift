//
//  TouchAnimationType.swift
//  IBAnimatable
//
//  Created by 4D on 19/04/2018.
//  Copyright © 2018 IBAnimatable. All rights reserved.
//

import Foundation

import UIKit

/**
 Predefined Touch Animation Type
 */

public indirect enum TouchAnimationType {
  case activityIndicator(ActivityIndicatorType)
  case animation(AnimationType)
  case mask(MaskType)
  case removeTitle
  case none
}

// WANTED
// Collapse / Expand animation
// Shake
// Remove title add title (if activity indicator


extension TouchAnimationType: IBEnum {
  
  public init(string: String?) {
    guard let string = string else {
      self = .none
      return
    }
    
    let (name, params) = TouchAnimationType.extractNameAndParams(from: string)
    
    switch name {
    case "activityIndicator":
      guard let type = ActivityIndicatorType(string: params[safe: 0]) else {
          self = .none
          return
      }
      if case ActivityIndicatorType.none = type {
          self = .none
          return
      }
      self = .activityIndicator(type)
    case "animation":
      let type = AnimationType(string: params[safe: 0])
      if case AnimationType.none = type {
        self = .none
        return
      }
      self = .animation(.none)
    case "mask":
      let type = MaskType(string: params[safe: 0])
      if case MaskType.none = type {
        self = .none
        return
      }
      self = .mask(.none)
    default:
      self = .none
    }
  }
  
}
