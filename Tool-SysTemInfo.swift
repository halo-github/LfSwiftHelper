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
public class LF_Info {
    public static let regionCode = NSLocale.current.regionCode!                      //手机设置的国家代号
    public static let langCode = NSLocale.current.languageCode!                           //本地语言
    public static let uuidStr = UIDevice.current.identifierForVendor?.uuidString          //手机uuid
    public static let model = UIDevice.current.model                                      //iPhone，iPad。。。
//    static let localModel = UIDevice.current.localizedModel
    public static let screenScale = UIScreen.main.scale
    public static let systemVersion = UIDevice.current.systemVersion   // 版本号
    
    //网络信息：网关，ssid（wifi名称）
    
    public static func wifiSSID() -> String{

        var wifi: String = ""
        //网关数组
        if let cfArr = CNCopySupportedInterfaces() {
//            print("网关：\(cfArr)")
            if let ptr = CFArrayGetValueAtIndex(cfArr, 0) {
                
                if let cfStr = unsafeBitCast(ptr, to: CFString.self) as? CFString {
//  CNCopyCurrentNetworkInfo在iOS 12+， 需要将 access Wifi infomation 打开
                    if let  dic = CNCopyCurrentNetworkInfo(cfStr) {
//                        print(dic)
                        let key = Unmanaged.passRetained("SSID" as NSString).toOpaque()

                        let ssid = CFDictionaryGetValue(dic, key)
                        let name = Unmanaged<NSString>.fromOpaque(ssid!)
                        wifi = name.takeUnretainedValue() as String
//                        print(wifi)
                    }
//

                }
            }


        }
        return wifi
        
    }
}
