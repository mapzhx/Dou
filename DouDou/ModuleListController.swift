//
//  ModuleListController.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/30.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import SnapKit

let ModuleViewItemIdentifier = "ModuleViewItem"

class ModuleListController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var project: Project? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var modules: [Module] {
        return project?.modules ?? [Module]()
    }
    
    /// Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(NSNib(nibNamed: ModuleViewItemIdentifier, bundle: .main), forItemWithIdentifier: NSUserInterfaceItemIdentifier(ModuleViewItemIdentifier))
    }
    
    /// NSCollectionViewDataSource Method
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        var item: ModuleViewItem?
        if let moduleItem = collectionView.item(at: indexPath) as? ModuleViewItem {
            item = moduleItem
        } else {
            item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(ModuleViewItemIdentifier), for: indexPath) as? ModuleViewItem
        }
        item?.module = modules[indexPath.item]
        item?.moduleView.localizeHandler = { [weak self] in
            ProjectLoader.shared.makeLocalize(for: self?.modules[indexPath.item])
        }
        return item ?? ModuleViewItem(nibName: ModuleViewItemIdentifier, bundle: .main)
    }
}
