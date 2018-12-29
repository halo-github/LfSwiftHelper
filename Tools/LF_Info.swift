//
//  LF_info.swift
//  Jellyfish
//
//  Created by halo vv on 2018/10/31.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto    
import SystemConfiguration.CaptiveNetwork
class LF_Info {
    static let regionCode = NSLocale.current.regionCode!                      //手机设置的国家代号
    static let langCode = NSLocale.current.languageCode!                           //本地语言
    static let uuidStr = UIDevice.current.identifierForVendor?.uuidString          //手机uuid
    static let model = UIDevice.current.model                                      //iPhone，iPad。。。
//    static let localModel = UIDevice.current.localizedModel
    static let screenScale = UIScreen.main.scale
    static let systemVersion = UIDevice.current.systemVersion   // 版本号
    
    //网络信息：网关，ssid（wifi名称）
    
    static func netInfo() -> String{

        var wifi: String = ""
        if let cfArr = CNCopySupportedInterfaces() {
//            print("网关：\(cfArr)")
            if let ptr = CFArrayGetValueAtIndex(cfArr, 0) {

                if let cfStr = unsafeBitCast(ptr, to: CFString.self) as? CFString {
                    if let dic = CFBridgingRetain(CNCopyCurrentNetworkInfo(cfStr)) {
                        print(dic)
                    }
                    if let  dic = CNCopyCurrentNetworkInfo(cfStr) {
                        print(dic)
                        let key = Unmanaged.passRetained("SSID" as NSString).toOpaque()

                        let ssid = CFDictionaryGetValue(dic, key)
                        let name = Unmanaged<NSString>.fromOpaque(ssid!)
                        wifi = name.takeUnretainedValue() as String
                    }
//

                }
            }


        }
        return wifi
        
    }
}
