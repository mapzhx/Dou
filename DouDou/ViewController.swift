//
//  ViewController.swift
//  DouDou
//
//  Created by mapengzhen on 2020/3/14.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import Stencil
import PathKit

class ViewController: NSViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let window = NSApplication.shared.mainWindow {
            window.center()
            window.becomeFirstResponder()
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func chooseDir(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.title = "选择开发目录"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.prompt = "确定"
        panel.directoryURL = URL.init(string: NSHomeDirectory())
        panel.begin { (modelReponse) in
            guard let result = panel.url?.path else {
                return
            }

            if modelReponse == .OK {
                let resultPath = Path(result)
                let iterator = resultPath.iterateChildren().makeIterator()
                while let path = iterator.next() {
                    if path.isFile == false {
                        continue
                    }
                    if path.extension != "strings" {
                        continue
                    }
                    let moduleName = Path(path.lastComponentWithoutExtension)
                    let className = moduleName.string + "Localized"
                    
                    let context: [String: Any] = [
                      "models": [
                        StringsExpress(name: "WdddRwwwTwww", hint: "上次说的刺刀送点吃的上传到"),
                        StringsExpress(name: "JkkkOpppGyyy", hint: "充电呢才能到家你吃的"),
                      ],
                      "moduleName": moduleName,
                      "className": className,
                    ]
                    let parentDir = path.parent()
                    let hPath = parentDir + Path(path.lastComponentWithoutExtension + ".h")
                    let mPath = parentDir + Path(path.lastComponentWithoutExtension + ".m")
                    let sPath = parentDir + Path(path.lastComponentWithoutExtension + ".swift")

//                    if hPath.exists == false {
//                        try? hPath.mkpath()
//                    }
                    if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringH, context: context) {
                        try? hPath.write(renderString, encoding: .utf8)
                    }
                    
                    if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringM, context: context) {
                        try? mPath.write(renderString, encoding: .utf8)
                    }
                    
                    if let renderString = try? ProjectLoader.RenderEnv.renderTemplate(name: .stringS, context: context) {
                        try? sPath.write(renderString, encoding: .utf8)
                    }
                    
                }
            }
        }
    }
    
}

private extension ViewController {
    
}
