//
//  JsonTool.swift
//  Jellyfish
//
//  Created by halo vv on 2018/10/24.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation

class JsonTool {
    static func json(fileName: String, type: String) -> [String: Any]? {
        if  let path = Bundle.main.path(forResource: fileName, ofType: type) {
            if let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return json!
                }
            }
        }
        return nil
    }
}

extension Dictionary where Key == String {
    func dic(_ k:String) -> [String: Any]? {
        if let dic = self[k] as? [String: Any] {
            return dic
        }
        return nil
    }
}

extension Array where Element == [String: AnyObject] {
    func  arr(idx:Int) -> [String: Any] {
        return self[idx]
    }
}
