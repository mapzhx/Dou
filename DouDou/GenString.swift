//
//  GenString.swift
//  DouDou
//
//  Created by mapengzhen on 2020/4/8.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import PathKit

public class GenString {
    static func getStringExpresses(path: Path) -> (strings: [StringsExpress], placeholders: [StringsExpress]) {
        var strings = [StringsExpress]()
        var placeholders = [StringsExpress]()

        guard let content = try? path.read(.utf8) else {
            return (strings, placeholders)
        }
        for localizeString in content.split(separator: "\n") {
            guard let express = GenString.getStringExpress(string: String(localizeString)) else {
                continue
            }
            var exist = false
            for tmp in strings {
                if tmp.name == express.name {
                    exist = true
                    break
                }
            }
            if exist {
                print("重复的key = \(express.name), value = \(express.hint)")
                continue
            }
            if express.placeHodlers.count > 0 {
                placeholders.append(express)
            } else {
                strings.append(express)
            }
        }
        return (strings, placeholders)
    }
}

private extension GenString {
    
    static func getStringExpress(string: String?) -> StringsExpress? {
        guard let string = string else {
            return nil
        }
        
        let components = string.split(separator: "=")
        if components.count != 2 {
            return nil
        }
        var name = String(components[0])
        let hint = String(components[1])
        name = name.trimmingCharacters(in: CharacterSet(charactersIn: "\"\" "))
        let placeHodlers = try? StringsExpress.PlaceholderType.placeholders(fromFormat: hint)
        return StringsExpress(name: name, hint: hint, placeHodlers: placeHodlers ?? [String]())
    }
    
}

