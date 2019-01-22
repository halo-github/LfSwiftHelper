//
//  LfStatus.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/8.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit

//通过状态栏图标获取网络状态，电池以及相关状态

class LfStatus {
    static func netStrength() -> Int {
//        if UIApplication.shared.isStatusBarHidden == false { return 0}
        var strength: Int = 0
        let statusBar:UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        
        if isX   {
            
//            print(statusBar.subviews,statusBar.subviews[0])
            statusBar.subviews[0].subviews[1].subviews.forEach { (view) in
                view.subviews.forEach({ (sub) in
//                    print(sub)
                    let newClass: AnyClass? = NSClassFromString("_UIStatusBarWifiSignalView")
                    if sub.isKind(of: newClass!) {
//                        print(sub.getProperty(),sub.getIvars(),sub)
                        if let stren = sub.value(forKeyPath: "_numberOfActiveBars") as? Int {
                            strength = stren
                        }
                    }
                })
                
            }

        } else {
            if let foregoundView = statusBar.value(forKey: "foregroundView") as? UIView {
                foregoundView.subviews.forEach { (view) in
                    print(view)
                    if view.isKind(of: (NSClassFromString("UIStatusBarDataNetworkItemView")?.class())!) {
                        if let wifiStrengthBars = view.value(forKey: "_wifiStrengthBars") as? Int {
                            strength = wifiStrengthBars
                        }
                    }
                }
            }
        }
        
        return strength      
    }
    
    static func batteryLevel() -> Int {
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        return Int(level*100)
    }
    
    static func foregoundView () -> Any {
        var statusBar:UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if isX == true {
            statusBar = statusBar.value(forKey: "statusBar") as! UIView
        }
        let foregoundView:UIView = statusBar.value(forKey: "foregroundView") as! UIView
        return foregoundView
    }
    
    func findUIStatusBarWifiSignalView(from: UIView)  {
        from.subviews.forEach { (view) in
            findUIStatusBarWifiSignalView(from: view)
        }
    }
}
