//
//  LoginWindowControllerMediator.swift
//  FloatBehind
//
//  Created by Takahiko Inayama on 2/3/16.
//  Copyright © 2016 katashin. All rights reserved.
//

import Cocoa

@objc protocol LoginMediatorDelegate {
  func loginMediatorDidSuccessLogin();
  optional func loginMediatorDidCancelLogin();
}

class WeakLoginDelegate {
  weak var value : LoginMediatorDelegate?

  init (value: LoginMediatorDelegate) {
    self.value = value
  }

  func get() -> LoginMediatorDelegate? {
    return value
  }
}

class LoginWindowControllerMediator: NSObject, LoginWindowDelegate {
  static let sharedInstance = LoginWindowControllerMediator()

  private var delegates: [WeakLoginDelegate] = [WeakLoginDelegate]()
  private var loginWindowController: LoginWindowController?

  private override init() {}

  func addDelegate(delegate: LoginMediatorDelegate) {
    assert(NSThread.isMainThread())
    delegates.append(WeakLoginDelegate(value: delegate))
  }

  func removeDelegate(delegate: LoginMediatorDelegate) {
    assert(NSThread.isMainThread())
    for var i = 0; i < delegates.count; i++ {
      let del = delegates[i]
      if delegate === del.get() {
        delegates.removeAtIndex(i)
        return
      }
    }
  }


  func login() {
    loginWindowController = LoginWindowController(windowNibName: "LoginWindowController")
    loginWindowController?.delegate = self
    loginWindowController?.showWindow(nil)
  }

  func loginWindowDidSuccessLogin(window: NSWindow) {
    for delegate in delegates {
      delegate.get()?.loginMediatorDidSuccessLogin()
    }

    loginWindowController?.window?.close()
    loginWindowController = nil
  }

  func loginWindowDidCancelLogin() {
    for delegate in delegates {
      delegate.get()?.loginMediatorDidCancelLogin?()
    }

    loginWindowController = nil
  }
}
