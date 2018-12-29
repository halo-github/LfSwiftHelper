//
//  URLSession-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/10/24.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxSwift


extension Reactive where Base: URLSession {
    func waitJson(request: URLRequest, options: JSONSerialization.ReadingOptions = [], jsonHandler: @escaping AnyHandler, errHandler:@escaping AnyHandler = {_ in}, bag:DisposeBag) {
        UIWindow.showActivityIndicator()
        self.response(request: request).subscribe(onNext: { resp, data  in
            UIWindow.hideActivityIndicator()
            
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if 200..<300 ~= resp.statusCode {
                    jsonHandler(json)
                } else {
                        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let str = String.init(data: jsonData ?? Data() , encoding: .utf8)
                    print("错误：\(str)")
                    errHandler(json)
                }
            }
        }, onError: { (e) in
            UIWindow.hideActivityIndicator()
            print(e.localizedDescription)
            UIWindow.remind("请检查网络连接")
        }).disposed(by: bag)
    }
}
