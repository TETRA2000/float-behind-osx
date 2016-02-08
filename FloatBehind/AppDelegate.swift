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

  @IBOutlet weak var statusMenu: NSMenu!

  var statusItem: NSStatusItem!
  var windowController: BehindWindowController = BehindWindowController(windowNibName: "BehindWindowController")

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let ud = NSUserDefaults.standardUserDefaults()
    ud.setObject(true, forKey: "WebKitDeveloperExtras")
    ud.synchronize()
    self.windowController.showWindow(nil)

    self.setupStatusItem()
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  func setupStatusItem() {
    let systemStatusBar = NSStatusBar.systemStatusBar()
    self.statusItem = systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
    self.statusItem.highlightMode = true
    self.statusItem.image = NSImage(named: "StatusBarIconTemplate")
    self.statusItem.menu = self.statusMenu
  }

  @IBAction func clickLoginItem(sender: NSMenuItem) {
    LoginWindowControllerMediator.sharedInstance.login()
  }

  @IBAction func clickOverIcons(sender: NSMenuItem) {
    self.windowController.window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DesktopIconWindowLevelKey)) + 1
  }

  @IBAction func clickBehindIcons(sender: NSMenuItem) {
    self.windowController.window?.level = Int(CGWindowLevelForKey(CGWindowLevelKey.DesktopIconWindowLevelKey)) - 1
  }

  @IBAction func clickQuitItem(sender: NSMenuItem) {
    NSApplication.sharedApplication().terminate(self)
  }
}

