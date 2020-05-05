//
//  NSAlert+Dou.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/8.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa

public extension NSAlert {
    static func show(error: NSError, buttons: [String]?, icon: NSImage) {
        let alert = NSAlert(error: error)
        alert.alertStyle = NSAlert.Style.informational
        alert.icon = NSImage.init(named: NSImage.networkName)
        for button in buttons ?? [String]() {
            alert.addButton(withTitle: button)
        }
        
        alert.messageText = "\(error.code)"
        alert.informativeText = error.description
        alert.runModal()
        
        if let window = NSApp.windows.last {
            alert.beginSheetModal(for: window, completionHandler: { res in
                
            })
        }
    }
}
