//
//  AppDelegate.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/14.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openDocument(_ sender: NSMenuItem) {
        ProjectLoader.selectProjectPath()
    }
    
}

