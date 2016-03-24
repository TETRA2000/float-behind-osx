//
//  AppCookieService.swift
//  FloatBehind
//
//  Created by katashin on 2016/03/15.
//  Copyright © 2016年 katashin. All rights reserved.
//

import Cocoa

// Cookie service for FloatBehind app server
class AppCookieService: NSObject {
  static let sharedService = AppCookieService()
  
  override private init() {}
  
  func removeCookieForName(name: String) {
    let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    guard let cookies: [NSHTTPCookie] = cookieStorage.cookiesForURL(URLConstants.app) else { return }
    
    cookies
      .filter { c in c.name == name }
      .forEach { c in cookieStorage.deleteCookie(c) }
  }
}
