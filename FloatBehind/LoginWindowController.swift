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
}

class LoginWindowController: NSWindowController, WebFrameLoadDelegate {
  
  let loginUrl: NSURL = NSURL(string: "http://localhost.floatbehind.io:3000/oauth/slack")!
  let successUrl: NSURL = NSURL(string: "http://localhost.floatbehind.io:3000/")!
  
  var delegate: LoginWindowDelegate?;
  
  @IBOutlet var webView: WebView!
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    self.webView.frameLoadDelegate = self;
    
    let request = NSURLRequest(URL: self.loginUrl)
    self.webView.mainFrame.loadRequest(request)
  }
  
  // MARK: - WebFrameLoadDelegate
  func webView(sender: WebView!, didReceiveServerRedirectForProvisionalLoadForFrame frame: WebFrame!) {
    if frame.provisionalDataSource.request.URL?.path == self.successUrl.path {
      self.delegate?.loginWindowDidSuccessLogin(self.window!)
    }
  }
}
