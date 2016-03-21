//
//  LoginService.swift
//  FloatBehind
//
//  Created by Takahiko Inayama on 2/3/16.
//  Copyright © 2016 katashin. All rights reserved.
//

import Cocoa
import SwiftHTTP
import JSONJoy

protocol LoginServiceDelegate: class {
  func loginService(loginService: LoginService, didChangeLoggedIn loggedIn: Bool)
}

class WeakLoginServiceDelegate {
  private weak var value: LoginServiceDelegate?
  
  init (value: LoginServiceDelegate) {
    self.value = value
  }
  
  func get() -> LoginServiceDelegate? {
    return value
  }
}

class LoginServiceDelegateSet {
  private var delegates: [WeakLoginServiceDelegate] = []
  
  func add(delegate: LoginServiceDelegate) {
    self.delegates.append(WeakLoginServiceDelegate(value: delegate))
  }
  
  func remove(delegate: LoginServiceDelegate) {
    self.delegates = self.delegates.filter {
      (container: WeakLoginServiceDelegate) -> Bool in
      let d: LoginServiceDelegate? = container.get()
      return d != nil && d! !== delegate
    }
  }
  
  func forEach(fn: (LoginServiceDelegate) -> Void) {
    self.delegates = self.delegates.filter { $0.get() != nil }
    self.delegates
      .map { $0.get()! }
      .forEach(fn)
  }
}

class LoginService: NSObject, LoginWindowDelegate {
  static let sharedService = LoginService()
  
  var delegates = LoginServiceDelegateSet()
  
  var loggedIn: Bool = false {
    didSet {
      if !self.loggedIn {
        self.account = nil
      }
      
      if oldValue != self.loggedIn {
        self.delegates.forEach { $0.loginService(self, didChangeLoggedIn: self.loggedIn) }
      }
    }
  }
  var account: Account?

  var loginWindowController: NSWindowController {
    let loginWindowController = LoginWindowController(windowNibName: "LoginWindowController")
    loginWindowController.delegate = self
    return loginWindowController
  }

  private override init() {}
  
  func addDelegate(delegate: LoginServiceDelegate) {
    self.delegates.add(delegate)
  }

  func removeDelegate(delegate: LoginServiceDelegate) {
    self.delegates.remove(delegate)
  }

  func logout() {
    AppCookieService.sharedService.removeCookieForName("sid")
    self.loggedIn = false
  }
  
  func fetchAccount() {
    let opt = try! HTTP.GET(URLConstants.me.absoluteString)
    
    opt.start { response in
      dispatch_async(dispatch_get_main_queue(), {
        if response.error != nil {
          self.loggedIn = false
          return
        }

        let sessionID = AppCookieService.sharedService.valueForName("sid")!
        self.account = try! Account(sessionID: sessionID, decoder: JSONDecoder(response.data)["result"])
        self.loggedIn = true
      })
    }
  }
  
  // MARK: - LoginWindowDelegate
  func loginWindowDidSuccessLogin(window: NSWindow) {
    self.fetchAccount()
  }
  
  func loginWindowDidCancelLogin(window: NSWindow) {
    self.loggedIn = false
  }
}
