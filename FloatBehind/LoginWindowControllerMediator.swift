//
//  LoginWindowControllerMediator.swift
//  FloatBehind
//
//  Created by Takahiko Inayama on 2/3/16.
//  Copyright © 2016 katashin. All rights reserved.
//

import Cocoa

@objc protocol LoginDelegate {
  func didSuccessLogin();
  optional func didCancelLogin();
}

class WeakLoginDelegate {
  weak var value : LoginDelegate?

  init (value: LoginDelegate) {
    self.value = value
  }

  func get() -> LoginDelegate? {
    return value
  }
}

class LoginWindowControllerMediator: NSObject, LoginWindowDelegate {
  static var sharedInstance = LoginWindowControllerMediator()

  private var delegates: [WeakLoginDelegate] = [WeakLoginDelegate]()
  private var loginWindowController: LoginWindowController?

  private override init() {}

  func addDelegate(delegate: LoginDelegate) {
    assert(NSThread.isMainThread())
    delegates.append(WeakLoginDelegate(value: delegate))
  }

  func removeDelegate(delegate: LoginDelegate) {
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
      delegate.value?.didSuccessLogin()
    }

    loginWindowController?.window?.close()
    loginWindowController = nil
  }

  func loginWindowDidCancelLogin() {
    for delegate in delegates {
      delegate.value?.didSuccessLogin()
    }

    loginWindowController = nil
  }
}
