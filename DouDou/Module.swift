//
//  Module.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/30.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import PathKit

struct Module {
    
    static var moduleNameRegular = try? NSRegularExpression(pattern: "(\'|\")Yach[a-zA-Z0-9]+(\'|\")", options: .caseInsensitive)
    
    static var modulePathRegular = try? NSRegularExpression(pattern: "\'\\.\\./.+\'", options: .caseInsensitive)

    /// 组件名称
    var name = ""
    
    /// 组件目录
    var path: Path?
    
    init(pod: String, basePath: Path) {
        if let nameResult = Module.moduleNameRegular?.firstMatch(in: pod, options: .reportCompletion, range: NSRange(location: 0, length: pod.count)) {
            var range = nameResult.range(at: 0)
            if range.length > 2 {
                range.location = range.location + 1
                range.length = range.length - 2
            }
            self.name = (pod as NSString).substring(with: range)
        }
        if let pathResult = Module.modulePathRegular?.firstMatch(in: pod, options: .reportCompletion, range: NSRange(location: 0, length: pod.count)) {
            var range = pathResult.range(at: 0)
            if range.length > 2 {
                range.location = range.location + 1
                range.length = range.length - 2
            }
            self.path = basePath + (pod as NSString).substring(with: range)
        }
    }
}
