//
//  HUB.swift
//  星火钱包
//
//  Created by 刘峰 on 2018/2/5.
//  Copyright © 2018年 xeenho. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD
//MARK:- Alert
extension UIAlertController {
    static func Alert(title:String,msg: String = "",okHandle:(() ->Void)?) ->Void {
        let alert:UIAlertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let cancle:UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let hd:(UIAlertAction)->Void = { _ in
            okHandle?()
        }
        
        let ok:UIAlertAction = UIAlertAction.init(title: "确定", style: .default, handler: hd)
        alert.addAction(ok)
        alert.addAction(cancle)
        
        
        let VC =  UIWindow.topViewController()
        VC!.present(alert, animated: true, completion: nil)
    }
}







func DEBUGRemind(_ r:String, delay: TimeInterval = 1) {
    #if DEBUG
        UIWindow.remind(r)
    #endif
}

//func print(_ t: Any..., file: String = #file, method: String = #function, line: Int = #line)  {
//    #if DEBUG
//    let fileName = (file as NSString).pathComponents.last
//    let firstName = fileName?.components(separatedBy: ".").first
//    print("\(firstName!).\(method)(\(line)):------")
////    t.forEach { (item) in
////        print(item)
////    }
////
//     dump(t)
//    print("-----\(firstName!).\(method)")
//    
//    
//   
//    #endif
//}

extension MBProgressHUD {
    func hideWhenTapSpace() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.hide(animated:)))
        self.backgroundView.addGestureRecognizer(tap)
        if self.customView != nil {
//        self.customView!.isUserInteractionEnabled = true
//        self.customView!.addGestureRecognizer(UITapGestureRecognizer())
        }
    }
}

