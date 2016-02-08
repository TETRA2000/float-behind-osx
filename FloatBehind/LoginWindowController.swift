//
//  LoginWindowController.swift
//  FloatBehind
//
//  Created by katashin on 2016/01/31.
//  Copyright © 2016年 katashin. All rights reserved.
//

import Cocoa
import WebKit

protocol LoginWindowDelegate {
  func loginWindowDidSuccessLogin(window: NSWindow);
  func loginWindowDidCancelLogin();
}

class LoginWindowController: NSWindowController, NSWindowDelegate, WebFrameLoadDelegate {

  var delegate: LoginWindowDelegate?;

  @IBOutlet var webView: WebView!

  override func windowDidLoad() {
    super.windowDidLoad()

    self.window?.delegate = self
    self.webView.frameLoadDelegate = self;

    let request = NSURLRequest(URL: URLConstants.slackLogin)
    self.webView.mainFrame.loadRequest(request)
  }

  // MARK: - WebFrameLoadDelegate
  func webView(sender: WebView!, didReceiveServerRedirectForProvisionalLoadForFrame frame: WebFrame!) {
    if frame.provisionalDataSource.request.URL == URLConstants.app {
      self.delegate?.loginWindowDidSuccessLogin(self.window!)
    }
  }
  // MARK: - NSWindowDelegate
  func windowWillClose(notification: NSNotification) {
    self.delegate?.loginWindowDidCancelLogin()
  }
}
