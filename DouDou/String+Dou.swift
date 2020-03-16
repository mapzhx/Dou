//
//  Environment+Dou.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/15.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Stencil
import PathKit

public extension String {
    /// .h 模板
    static var stringH: String = {
        let path = Bundle.main.path(forResource: "GenStringH", ofType: "stencil") ?? ""
        return path
    }()
    
    /// .m 模板
    static var stringM: String = {
        let path = Bundle.main.path(forResource: "GenStringM", ofType: "stencil") ?? ""
        return path
    }()

    /// swift 模板
    static var stringS: String = {
        let path = Bundle.main.path(forResource: "GenStringSwift", ofType: "stencil") ?? ""
        return path
    }()
}
