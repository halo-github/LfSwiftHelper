//
//  NetTool.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/23.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import CoreTelephony
import RxSwift
import Reachability
class NetTool {
    static let shared = NetTool()
//    static let internetOb = Reachability.forInternetConnection()
    
    var netTasks:[BlockOperation] = [BlockOperation]()
    var wifiTasks: [BlockOperation] = [BlockOperation]()
    
    var semaphore = DispatchSemaphore.init(value: 1)
    
    static func watchNetAuthorize() {
        self.NetworkAuthorizeHandler(resticted: {
            DispatchQueue.main.async {
                UIWindow.Alert(title: "权限限制", msg: "前往     设置 - \(appName)      选择WLAN与蜂窝移动网络", okHandle: nil)
            }
            
        }, notRestricted: {
            
        }) {
        }
    }
   
    
      func watchInternetStatus() {
        let reachability = Reachability.forInternetConnection()
        reachability?.reachableBlock = { _  in
            for _ in 0..<self.netTasks.count {
                DispatchQueue.global().async {
                    self.semaphore.wait()
                    let operation = self.netTasks.removeFirst()
                    self.semaphore.signal()
                    operation.start()
                }
            }
        }
        reachability?.startNotifier()
    }
   // 如果网络通畅，立即执行，否则加入到队列，等待执行
    func addNetTask(block: @escaping VoidHandler) {
        if NetTool.checkInternetConnection() != 0 {
            block()
        } else {
            UIWindow.remind("internet 不可用")
//            UIWindow.Alert(title: "internet 不可用", okHandle: nil)
            self.netTasks.append(BlockOperation.init(block: block))
        }
    }
    
    static func checkInternetConnection() -> Int?{
        return Reachability.forInternetConnection()?.currentReachabilityStatus().rawValue
    }
    
    
    
    
    static func NetworkAuthorizeHandler(resticted: @escaping VoidHandler, notRestricted: @escaping VoidHandler, unKnown: @escaping VoidHandler) {
        let ctData = CTCellularData()
        ctData.cellularDataRestrictionDidUpdateNotifier = { state in
//            print(" netstate: \(state)")
            switch state {
            
            case .restrictedStateUnknown:
                print("restrictedStateUnknown")
                unKnown()
                
            case .restricted:
                print("restricted")
                resticted()
                
            case .notRestricted:
                print("notRestricted")
                notRestricted()
                
            }
        }
    }
}

extension URLRequest {
    
    enum RequestMothod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case head = "HEAD"
    }
    
    static func request(urlStr: String, paras: [String: String]) -> URLRequest{
        let body = paras.map{"\($0)=\($1)"}.joined(separator: "&")
        var request = URLRequest.init(url: URL.init(string: urlStr)!)
            request.httpMethod = "POST"
            request.httpBody = body.data(using: .utf8)
        return request
    }
    
    
    static func method(_ r: RequestMothod, url: URL, paras: [String: Any] = [:]) -> URLRequest {
        var request = URLRequest.init(url: url)
            request.httpMethod = r.rawValue
        
        if r == RequestMothod.post {
            let body = paras.map{"\($0)=\($1)"}.joined(separator: "&")
            request.httpBody = body.data(using: .utf8)
        }
        return request
    }
}
