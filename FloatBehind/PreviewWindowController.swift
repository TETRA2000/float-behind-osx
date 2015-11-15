//
//  PreviewWindowController.swift
//  FloatBehind
//
//  Created by katashin on 2015/11/15.
//  Copyright © 2015年 katashin. All rights reserved.
//

import Cocoa
import WebKit

class PreviewWindowController: NSWindowController {

  @IBOutlet var panel: NSPanel!
  @IBOutlet var webView: WebView!

  var request: NSURLRequest?

  override func windowDidLoad() {
    super.windowDidLoad()

    self.window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DockWindowLevelKey)) + 1

    if let request = self.request {
      self.loadRequest(request)
    }
  }

  func loadRequest(request: NSURLRequest) {
    self.request = request;

    let frame = self.webView?.mainFrame
    frame?.stopLoading()
    frame?.loadRequest(request)
  }
}
