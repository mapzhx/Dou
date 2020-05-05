//
//  FileSelector.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/8.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import PathKit

typealias FileSelectorCompletion = ((Path) -> Void)

public class FileSelector {
    static func open(dir: String?, title: String?, completion: FileSelectorCompletion?) {
        let panel = NSOpenPanel()
        panel.title = title ?? "选择开发目录"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "确定"
        panel.directoryURL = URL(string: dir ?? NSHomeDirectory())
        panel.begin { (modelReponse) in
            guard let result = panel.url?.path else {
                return
            }
            
            if modelReponse == .OK {
                completion?(Path(result))
            }
        }
    }
}
