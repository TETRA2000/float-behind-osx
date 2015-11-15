//
//  AppDelegate.swift
//  FloatBehind
//
//  Created by katashin on 2015/11/15.
//  Copyright © 2015年 katashin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var windowController: BehindWindowController = BehindWindowController(windowNibName: "BehindWindowController")

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let ud = NSUserDefaults.standardUserDefaults()
    ud.setObject(true, forKey: "WebKitDeveloperExtras")
    ud.synchronize()
    self.windowController.showWindow(nil)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
}

