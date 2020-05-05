//
//  Project.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/30.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import PathKit

struct Project {
    
    // \bpod '[a-zA-Z0-9]+',\s*:path\s*=>\s*.+
    static var localModuleRegular = try? NSRegularExpression(pattern: "pod\\s*(\'|\")Yach[a-zA-Z0-9]+(\'|\"),\\s*:path\\s*=>\\s*.+", options: .caseInsensitive)
    
    /// 项目名称
    var name = ""
    
    /// 项目地址
    var path: Path?
    
    /// 项目包括的组件
    var modules = [Module]()
    
    init(name: String, path: Path) {
        self.name = name
        self.path = path
        let mainPath = path + "Yach"
        let podfilePath = path + "Yach/Podfile"
        if let content = try? podfilePath.read(.utf8) {
            Project.localModuleRegular?.enumerateMatches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.count)) { (result, flags, stop) in
                if let range0 = result?.range(at: 0) {
                    let module = Module(pod: (content as NSString).substring(with: range0), basePath: mainPath)
                    self.modules.append(module)
                }
            }
        }
    }
}
