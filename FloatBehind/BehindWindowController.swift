//
//  BehindWindowController.swift
//  FloatBehind
//
//  Created by katashin on 2015/11/15.
//  Copyright © 2015年 katashin. All rights reserved.
//

import Cocoa
import WebKit

class BehindWindowController: NSWindowController, NSWindowDelegate, WebFrameLoadDelegate, LoginMediatorDelegate {

  var previewController: PreviewWindowController!

  @IBOutlet var webView: WebView!;

  override func windowDidLoad() {
    super.windowDidLoad()
    
    guard let window = self.window else {
        return;
    }
    
    window.delegate = self

    fitWindowToScreen(window)

    // set the window behind all other windows
    window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DesktopIconWindowLevelKey)) + 1

    // should be transparent
    window.backgroundColor = NSColor.clearColor()
    window.opaque = false

    // WebView settings
    self.webView.frameLoadDelegate = self;
    self.webView.drawsBackground = false;
    let request = NSURLRequest(URL: URLConstants.app)
    self.webView.mainFrame.loadRequest(request)

    LoginWindowControllerMediator.sharedInstance.addDelegate(self)
  }

  func requestPreviewCard(urlString: String) {
    print(urlString)
    if let url = NSURL(string: urlString) {
      self.previewController = PreviewWindowController(windowNibName: "PreviewWindowController")
      self.previewController.showWindow(nil)
      self.previewController.loadRequest(NSURLRequest(URL: url))
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

  private func fitWindowToScreen(window: NSWindow) {
    guard let rect = NSScreen.mainScreen()?.visibleFrame else {
        return;
    }

    // fill the window to screen size
    self.window?.setFrame(rect, display: true)
  }

  // MARL: - NSWindowDelegate
  func windowDidChangeScreen(notification: NSNotification) {
    if let window = self.window {
      fitWindowToScreen(window)
    }
  }

  // MARK: - LoginMediatorDelegate
  func loginMediatorDidSuccessLogin() {
    self.webView.reload(nil)
  }

  // MARK: - WebFrameLoadDelegate
  func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
    if let _ = frame.findFrameNamed("_top") {
      sender.windowScriptObject.setValue(self, forKey: "Native")
    }
  }

  func webView(sender: WebView!, didStartProvisionalLoadForFrame frame: WebFrame!) {
    // prevent the main webview to load unexpected pages
    if frame.provisionalDataSource.request.URL != URLConstants.app {
      frame.stopLoading()
    }
  }
}
