//
//  AppDelegate.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/14.
//  Copyright © 2020 mapengzhen. All rights reserved.
// https://stencil.fuller.li/en/latest/builtins.html#built-in-tags

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
//        FileAuth.shared.start()
//        DouAuthHelper.shared.didFinishLaunch()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func openProject(_ sender: NSMenuItem) {
        
        ProjectLoader.shared.openYachProject(title: nil) { (project) in
            if let controller = NSApp.mainWindow?.contentViewController as? ModuleListController {
                controller.project = project
            }
        }
    }
}

