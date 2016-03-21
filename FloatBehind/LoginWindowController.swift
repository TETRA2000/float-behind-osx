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
  func loginWindowDidCancelLogin(window: NSWindow);
}

class LoginWindowController: NSWindowController, WebFrameLoadDelegate {

  var delegate: LoginWindowDelegate?;

  @IBOutlet var webView: WebView!
  var windowCloseButton: NSButton!

  override func windowDidLoad() {
    super.windowDidLoad()

    self.webView.frameLoadDelegate = self;

    let request = NSURLRequest(URL: URLConstants.slackLogin)
    self.webView.mainFrame.loadRequest(request)
    
    self.windowCloseButton = self.window?.standardWindowButton(.CloseButton)
    self.windowCloseButton.target = self
    self.windowCloseButton.action = "clickWindowCloseButton:"
  }
  
  func clickWindowCloseButton(sender: NSButton) {
    self.close()
    self.delegate?.loginWindowDidCancelLogin(self.window!)
  }

  // MARK: - WebFrameLoadDelegate
  func webView(sender: WebView!, didReceiveServerRedirectForProvisionalLoadForFrame frame: WebFrame!) {
    if frame.provisionalDataSource.request.URL == URLConstants.app {
      frame.stopLoading()
      self.delegate?.loginWindowDidSuccessLogin(self.window!)
    }
  }
}
