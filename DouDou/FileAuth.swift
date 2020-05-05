//
//  FileAuth.swift
//  DouDou
//
//  Created by mapengzhen on 2020/5/4.
//  Copyright © 2020 mapengzhen. All rights reserved.
//

import Cocoa
import Security
import ServiceManagement
import PathKit
import Foundation

@objc protocol DouAuthHelperProtocol {
    func getVersion(_ reply: @escaping (String) -> Void)
    func authTest(_ authData: Data, reply: @escaping (String) -> Void)
}

public class FileAuth {
    let AuthHelperServiceName = "com.tal.yach.dou.auth"
    let AuthHelperVersion     = "1.0.1"
    
    static let shared = FileAuth()
    
    var authRef: AuthorizationRef?
    
    init() {
        let status = AuthorizationCreate(nil, nil, AuthorizationFlags(), &authRef)
        if status != errAuthorizationSuccess {
            authRef = nil
        }
    }
    
    func start() {
        guard let authRef = authRef else {
            return
        }
        
        connectAuthHelper({ success in
            if success {
                self.connected()
            } else {
                self.installHelper()
                self.connectAuthHelper({
                    sucess in
                    self.connected()
                    if sucess {
                        print("Installed")
                    } else {
                        print("Fatal!  Could not install Helper!")
                    }
                })
            }
        })
    }
    
    func connectAuthHelper(_ callback: @escaping (Bool) -> Void) {
        let xpc = NSXPCConnection(machServiceName: AuthHelperServiceName, options: .privileged)
        xpc.remoteObjectInterface = NSXPCInterface(with: DouAuthHelperProtocol.self)
        xpc.resume()

        let helper = xpc.remoteObjectProxyWithErrorHandler({ _ in
            callback(false)
        }) as! DouAuthHelperProtocol
        
        helper.getVersion({ [weak self] (version) in
            print("get version => \(version), pid=\(xpc.processIdentifier)")
            callback(version as String == self?.AuthHelperVersion)
        })
    }
    
    func installHelper() {
        var item = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value: nil, flags: 0)
        var rights = AuthorizationRights(count: 1, items: &item)
        let flags = AuthorizationFlags([.interactionAllowed, .extendRights])

        let status = AuthorizationCopyRights(authRef!, &rights, nil, flags, nil)
        if (status != errAuthorizationSuccess) {
            print("AuthorizationCopyRights failed.")
            return;
        }

        var error: Unmanaged<CFError>!
        let success = SMJobBless(kSMDomainSystemLaunchd, AuthHelperServiceName as CFString, authRef!, &error)
        if !success {
            print("SMJobBless failed: \(error!)")
        }

        print("SMJobBless suceeded")
        getVersion()
    }

    func getVersion() {
        let xpc = NSXPCConnection(machServiceName: AuthHelperServiceName, options: .privileged)
        xpc.remoteObjectInterface = NSXPCInterface(with: DouAuthHelperProtocol.self)
        xpc.invalidationHandler = {
            print("XPC invalidated...!")
        }
        xpc.resume()
        
        let proxy = xpc.remoteObjectProxyWithErrorHandler({ err in
            print("xpc error =>\(err)")
        }) as! DouAuthHelperProtocol
        
        proxy.getVersion({ str in
            print("get version => \(str), pid=\(xpc.processIdentifier)")
        })
    }
    
    func connected() {
        print("Hello!")
        
        let xpc = NSXPCConnection(machServiceName: AuthHelperServiceName, options: .privileged)
        xpc.remoteObjectInterface = NSXPCInterface(with: DouAuthHelperProtocol.self)
        xpc.invalidationHandler = { print("XPC invalidated...!") }
        xpc.resume()
        print(xpc)
        
        let proxy = xpc.remoteObjectProxyWithErrorHandler({
            err in
            print("xpc error =>\(err)")
        }) as! DouAuthHelperProtocol

        var form = AuthorizationExternalForm()
        let status = AuthorizationMakeExternalForm(authRef!, &form)
        if status != errAuthorizationSuccess {
            print("AuthorizationMakeExternalForm failed.")
            return;
        }

        proxy.authTest(NSData(bytes: &form.bytes, length: MemoryLayout.size(ofValue: form.bytes)) as Data) { (reply) in
            print("auth reply: \(reply)")
        }
    }
    
    static func changeFileAllowWrited(isAllow: Bool, filePath: Path) {
//        Process
//        let pipe = NSPiPe()
        let task = Process()
        task.launchPath = "/bin/chmod"
        task.arguments = [
            "-R",
            isAllow ? "777" : "555",
            filePath.string,
        ]
        task.standardInput = Pipe()
        task.launch()
        task.waitUntilExit()
    }
    
//    + (void)changeFileAllowWrited:(BOOL)isAllow filePath:(NSString *)filePath
//    {
//        //777:rwx, r=4，w=2，x=1 所有人具有所有权限
//        //555:3个管理者都具有5权限
//        NSPipe *pipe = [NSPipe pipe];
//        NSArray *args = @[@"-R", @"555", filePath];
//        if (isAllow)
//        {
//            args = @[@"-R", @"777", filePath];
//        }
//        NSTask *task = [[NSTask alloc]init];
//        task.launchPath = @"/bin/chmod";
//        task.arguments = args;
//        task.standardInput = pipe;
//        [task launch];
//        [task waitUntilExit];
//    }
}
