//
//  File.swift
//  Jellyfish
//
//  Created by halo vv on 2018/11/22.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
extension DispatchQueue {
    private static var oneToken: [String] = [String]()
    static func once(once: String, block:()->Void) {
        //     保证被 objc_sync_enter 和 objc_sync_exit 包裹的代码可以有序同步地执行
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if oneToken.contains(once) { return }
        oneToken.append(once)
        block()
    }
}
