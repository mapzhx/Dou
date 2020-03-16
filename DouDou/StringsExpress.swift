//
//  StringsExpress.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/15.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa

public struct StringsExpress {
    var hint = ""
    var name = ""
    
    init(name: String, hint: String) {
        self.name = name
        self.hint = hint
    }
}
