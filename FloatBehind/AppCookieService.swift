//
//  AppCookieService.swift
//  FloatBehind
//
//  Created by katashin on 2016/03/15.
//  Copyright © 2016年 katashin. All rights reserved.
//

import Cocoa

class AppCookieSet: SequenceType {
  private let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
  
  func removeCookieForName(name: String) {
    for cookie in self {
      if cookie.name == name {
        storage.deleteCookie(cookie)
      }
    }
  }
  
  func generate() -> AnyGenerator<NSHTTPCookie> {
    guard let cookies = self.storage.cookiesForURL(URLConstants.app) else { return AnyGenerator() }
    
    let count = cookies.count
    var index = 0
    return anyGenerator {
      if index < count {
        return cookies[index++]
      } else {
        return nil
      }
    }
  }
}

// Cookie service for FloatBehind app server
class AppCookieService: NSObject {
  static let sharedService = AppCookieService()
  
  private let cookieSet = AppCookieSet()
  
  override private init() {}
  
  func removeCookieForName(name: String) {
    self.cookieSet.removeCookieForName(name)
  }
}
