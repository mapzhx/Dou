//
//  ModuleView.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/30.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import Hue
import SnapKit

typealias ModuleViewDidSelectLocalize = (() -> Void)

class ModuleView: NSView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet var detailTextView: NSTextView!
    
    var localizeHandler: ModuleViewDidSelectLocalize?
    
    func setupSubviews() {
        titleLabel.textColor = NSColor(hex: "FFFFFF")
        titleLabel.backgroundColor = NSColor.clear
        
        detailTextView.textColor = NSColor(hex: "FFFFFF")
        detailTextView.backgroundColor = NSColor.clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layout() {
        super.layout()
        
    }
    
    var selected = false {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    var mouseEnteredFlag = false {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if self.trackingAreas.count == 0 {
            let trackArea = NSTrackingArea(rect: dirtyRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .enabledDuringMouseDrag], owner: self, userInfo: nil)
            self.addTrackingArea(trackArea)
        }
        
        // Drawing code here.
        let roundRect = NSRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 10)
        let path = NSBezierPath(roundedRect: roundRect, xRadius: 4, yRadius: 4)
        (selected ? NSColor(hex: "03DAC6") : NSColor.clear).setStroke()
        path.stroke()
        
        (mouseEnteredFlag ? NSColor(hex: "BB86FC") : NSColor(hex: "121212")).setFill()
        path.fill()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        mouseEnteredFlag = false
        
        moduleMenu.cancelTracking()
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        mouseEnteredFlag = true
    }
    
    @objc
    func localize() {
        localizeHandler?()
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
//        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 1.5) {
//            NSCursor.setHiddenUntilMouseMoves(true)
//        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        NSMenu.popUpContextMenu(moduleMenu, with: event, for: self)
    }
    
    
    lazy var moduleMenu: NSMenu = {
        let menu = NSMenu(title: "选择操作")
        menu.addItem(NSMenuItem(title: "本地化", action: #selector(ModuleView.localize), keyEquivalent: ""))
        return menu
    }()
}
