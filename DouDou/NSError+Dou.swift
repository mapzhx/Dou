//
//  NSError+Dou.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/8.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa

let FileErrorDomain = "FileErrorDomain"

public extension NSError {
    
    enum DouErrorCode: Int {
        case typeError
        case notFound
        case auth
    }
    
    convenience init(code: DouErrorCode, message: String?) {
        self.init(domain: FileErrorDomain, code: code.rawValue, userInfo: ["message": message ?? "Unkonwn"])
    }
}

