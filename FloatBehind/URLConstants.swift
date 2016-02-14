//
//  Constants.swift
//  FloatBehind
//
//  Created by katashin on 2016/01/31.
//  Copyright © 2016年 katashin. All rights reserved.
//

#if LOCAL
  let host = "http://localhost.floatbehind.ninja:3000/"
#else
  let host = "https://floatbehind.ninja/"
#endif

import Cocoa

struct URLConstants {
  static let app = NSURL(string: host)!
  static let slackLogin = NSURL(string: "/oauth/slack", relativeToURL: URLConstants.app)!.absoluteURL
}
