//
//  SandboxPath.swift
//  Jellyfish
//
//  Created by liufeng on 2018/7/18.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit

public let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
public let libPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first


public let bundleVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
public func appStoreVersion(ID: String, updateHandler: @escaping (Bool) -> Void ){    
    let url = URL.init(string: "http://itunes.apple.com/lookup?id=\(appID)")
    let request = NSMutableURLRequest.init(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, err in
            if err == nil {
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dic = json as! [String: Any]
                let arr = dic["results"] as! [[String: Any]]
                let result = arr.first
                let version = result!["version"] as! String
                let needUpdate = version.compare(bundleVersion)
                updateHandler(needUpdate.rawValue > 0)          // 1 >       0 =      -1 <
            }
        }.resume()
    
    }
