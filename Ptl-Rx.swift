//
//  ViewMoelProtocol.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/29.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxSwift

public protocol RXProtocol {
    associatedtype Input
    associatedtype Output
    
    var input: Input {get set }
    var output: Output {get set }
}


//
let BASEURL = "https://image.baidu.com/search/acjson"
public protocol Lf_RxNetProtocol: RXProtocol where Output == PublishSubject<[String : Any]>, Input == [String : String] {
    
    
}

public extension Lf_RxNetProtocol {
    public func netPost(url: URL, paras: [String: String]) {
        
        var request = URLRequest.init(url: url)
            request.httpMethod = "POST"
            request.httpBody = dicToHttpBody(dic: paras).data(using: .utf8)
        
        
        }
    
}

public func dicToHttpBody(dic: [String: String]) -> String{
    return dic.map{"\($0)=\($1)"}.joined(separator: "&")
}




