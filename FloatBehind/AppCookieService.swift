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
  
  func cookieForName(name: String) -> NSHTTPCookie? {
    return self.filter({ c in c.name == name }).first
  }
  
  func removeCookieForName(name: String) {
    for cookie: NSHTTPCookie in self {
      if cookie.name == name {
        storage.deleteCookie(cookie)
      }
    }
  }
  
  func generate() -> AnyGenerator<NSHTTPCookie> {
    let cookies: [NSHTTPCookie] = self.storage.cookiesForURL(URLConstants.app) ?? []
    
    var index = 0
    return AnyGenerator<NSHTTPCookie> {
      if index < cookies.count {
        let result = cookies[index]
        index += 1
        return result
      }
      
      return nil
    }
  }
}

// Cookie service for FloatBehind app server
class AppCookieService: NSObject {
  static let sharedService = AppCookieService()
  
  private let cookieSet = AppCookieSet()
  
  override private init() {}
  
  func valueForName(name: String) -> String? {
    return self.cookieSet.cookieForName(name)?.value
  }
  
  func removeCookieForName(name: String) {
    self.cookieSet.removeCookieForName(name)
  }
}
