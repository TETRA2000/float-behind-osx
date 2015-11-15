//
//  BehindWindowController.swift
//  FloatBehind
//
//  Created by katashin on 2015/11/15.
//  Copyright © 2015年 katashin. All rights reserved.
//

import Cocoa
import WebKit

class BehindWindowController: NSWindowController, WebFrameLoadDelegate {

  let appUrl: NSURL = NSURL(string: "http://localhost:9000/")!
  let previewController: PreviewWindowController = PreviewWindowController(windowNibName: "PreviewWindowController")

  @IBOutlet var webView: WebView!;

  override func windowDidLoad() {
    super.windowDidLoad()

    var rect: NSRect!
    let screens: [NSScreen] = NSScreen.screens()!

    for var i = 0; i < screens.count; i++ {
      let screen: NSScreen = screens[i]
      rect = screen.visibleFrame
    }

    // fill the window to screen size
    self.window?.setFrame(rect, display: true)

    // set the window behind all other windows
    self.window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DesktopIconWindowLevelKey)) + 1

    // should be transparent
    self.window?.backgroundColor = NSColor.clearColor()
    self.window?.opaque = false

    // WebView settings
    self.webView.frameLoadDelegate = self;
    self.webView.drawsBackground = false;
    let request = NSURLRequest(URL: self.appUrl)
    self.webView.mainFrame.loadRequest(request)
  }

  func requestPreviewCard(urlString: String) {
    print(urlString)
    if let url = NSURL(string: urlString) {
      self.previewController.loadRequest(NSURLRequest(URL: url))
      self.previewController.showWindow(nil)
    }
  }

  override class func isSelectorExcludedFromWebScript(aSelector: Selector) -> Bool {
    switch aSelector {
    case Selector("requestPreviewCard:"):
      return false
    default:
      return true
    }
  }

  // MARK: - WebFrameLoadDelegate
  func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
    if let _ = frame.findFrameNamed("_top") {
      sender.windowScriptObject.setValue(self, forKey: "Native")
    }
  }
}
