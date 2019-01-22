//
//  URLRequest-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/10/22.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
public extension URLRequest {
    public mutating func addBody(paras:[String: Any]) {
        if let data = try? JSONSerialization.data(withJSONObject: paras, options: []) {
        self.httpBody = data
        self.httpMethod = "POST"
        }
    }
}





public extension ControlEvent  {
    public func requestJson(_ r:@escaping ()->URLRequest,completion: @escaping AnyHandler, bag: DisposeBag) {
        self.subscribe{_ in
            URLSession.shared.rx.json(request: r()).subscribe(onNext: { (json) in
                completion(json)
            }, onError: { (e) in
                print(e.localizedDescription)
            }).disposed(by: bag)
        }.disposed(by: bag)
    }
}

