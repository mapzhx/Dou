//
//  ProjectLoader.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/15.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import PathKit
import Stencil

typealias ProjectLoaderCompletion = ((Project) -> Void)

public class ProjectLoader {
    static let shared = ProjectLoader()
    
    static let RenderEnv = Environment(loader: FileSystemLoader(bundle: [Bundle.main]))
    
    static let DouUserSelectPathKey = "DouUserSelectPathKey"

    static var selectedPath: String? {
        return UserDefaults.standard.string(forKey: DouUserSelectPathKey)
    }
    
    var project: Project? {
        if let path = ProjectLoader.selectedPath {
            return Project(name: "Yach", path: Path(path))
        }
        return nil
    }
    
    func openYachProject(title: String?, completion: ProjectLoaderCompletion?) {
        FileSelector.open(dir: ProjectLoader.selectedPath, title: title) { (path) in
            UserDefaults.standard.set(path.string, forKey: ProjectLoader.DouUserSelectPathKey)
            let project = Project(name: "Yach", path: path)
            completion?(project)
        }
    }
    
    func gemLocalize(path: Path?) {
        guard let path = path else {
            return
        }
        
        if !path.isReadable {
            FileSelector.open(dir: path.string, title: "点击确定") { [weak self] (_) in
                self?.makeLocalizeFile(path: path)
            }
            return
        }
        makeLocalizeFile(path: path)
    }
    
    func makeLocalizeFile(path: Path) {
        if path.isFile, path.extension != "strings" {
            NSAlert.show(error: NSError(code: .typeError, message: "需要选择目录或者strings文件"), buttons: ["OK"], icon: NSImage(named: NSImage.networkName) ?? NSImage())
            return
        }
        
        let iterator = path.iterateChildren().makeIterator()
        while let nextPath = iterator.next() {
            if nextPath.isFile == false {
                continue
            }
            if !nextPath.string.contains("zh-Hans.lproj") {
                continue
            }
            if nextPath.extension != "strings" {
                continue
            }
            if !nextPath.lastComponentWithoutExtension.hasPrefix("Yach") {
                continue
            }
            
            let moduleName = Path(nextPath.lastComponentWithoutExtension)
            let className = moduleName.string + "Localized"
            
            let context: [String: Any] = [
                "models": GenString.getStringExpresses(path: nextPath).strings,
                "placeholders": GenString.getStringExpresses(path: nextPath).placeholders,
                "moduleName": moduleName,
                "className": className,
            ]
            var parentDir = nextPath.parent()
            if parentDir.extension == "lproj" {
                parentDir = parentDir.parent()
            }
            if parentDir.lastComponentWithoutExtension == "Resource" || parentDir.lastComponentWithoutExtension == "Resources" {
                parentDir = parentDir.parent()
            }
            
            parentDir = Path(parentDir.string + "/Strings");
            if !parentDir.exists {
                try? parentDir.mkdir()
            }
            let hPath = parentDir + Path(nextPath.lastComponentWithoutExtension + "Localized.h")
            let mPath = parentDir + Path(nextPath.lastComponentWithoutExtension + "Localized.m")
            let sPath = parentDir + Path(nextPath.lastComponentWithoutExtension + "Localized.swift")
            
            //                    if hPath.exists == false {
            //                        try? hPath.mkpath()
            //                    }
            if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringH, context: context) {
                try? hPath.write(renderString, encoding: .utf8)
            }
            
            if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringM, context: context) {
                try? mPath.write(renderString, encoding: .utf8)
            }
            
            //                if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringS, context: context) {
            //                    try? sPath.write(renderString, encoding: .utf8)
            //                }
        }
    }
}
