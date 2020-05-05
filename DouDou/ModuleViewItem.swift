//
//  ModuleViewItem.swift
//  DouDou
//
//  Created by mapengzhen on 2020/5/4.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import SnapKit

class ModuleViewItem: NSCollectionViewItem {
    
    var moduleView: ModuleView {
        return self.view as! ModuleView
    }

    var module: Module? {
        didSet {
            if let title = self.module?.name {
                moduleView.titleLabel.stringValue = title
            }
            if let path = self.module?.path?.string {
                 moduleView.detailTextView.string = path
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
             moduleView.selected = self.isSelected
        }
    }
    
    func refreshModuleView() {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
