//
//  UIWindow-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/12/25.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
public extension UIWindow {
    public static func topViewController() -> UIViewController? {
        var top = UIApplication.shared.delegate?.window??.rootViewController
        //        var top = root
        while  top?.presentedViewController != nil  {
            top = top!.presentedViewController
        }
        
        return top
    }
    //自定义
    public static func  remideView(_ v: UIView, tapSpaceRemoveEnabled: Bool = true) -> UIView{
        let back = UIView.color(UIColor.black.withAlphaComponent(0.5))
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                back.frame = window.bounds
                window.addSubview(back)
                v.frame = CGRect.init(center: window.center, size: v.frame.size)
                back.addSubview(v)
                
            }
        }
        if tapSpaceRemoveEnabled == true {
            back.addGestureRecognizer(UITapGestureRecognizer.init(target: back, action: #selector(removeFromSuperview)))
            
        }
        return back
    }
    
    
    //MARK:- HUD
    public static func defaultWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    public static func progress(on: UIView, block: @escaping (MBProgressHUD) -> Void){
        let hud = MBProgressHUD.showAdded(to: on, animated: true)
        hud.mode = .determinate
        block(hud)
    }
    
    public static func remind(_ r:String, delay: TimeInterval = 1) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                let hud = MBProgressHUD.showAdded(to: window, animated: true)
                hud.mode = .text
                hud.label.text = r
                hud.label.numberOfLines = 0
                hud.label.center = CGPoint.init(x: hud.center.x, y: hud.center.y * 1.5)
                hud.label.sizeToFit()
                hud.hide(animated: true, afterDelay: delay)
                //            hud.show(animated: true)
            }
        }
        
    }
    
    public static func showActivityIndicator(){
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                let hud = MBProgressHUD.showAdded(to: window, animated: true)
                hud.mode = .indeterminate
                hud.tag = 10086
                
            }}}
    
    public static func hideActivityIndicator(){
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                if let hud = window.viewWithTag(10086) {
                    hud.removeFromSuperview()
                }
            }
        }
    }
    
    
    public static func customHUD(withView:UIView) -> MBProgressHUD? {
        if let window = UIApplication.shared.keyWindow {
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            //                hud.bezelView.isHidden = true
            hud.bezelView.style = .solidColor
            
            hud.bezelView.backgroundColor = UIColor.clear.withAlphaComponent(0)
            hud.bezelView.isUserInteractionEnabled = false
            //
            //                hud.backgroundView.color = UIColor.black.withAlphaComponent(0.4)
            hud.mode = .customView
            hud.customView = withView
            
            hud.animationType = .zoom
            hud.removeFromSuperViewOnHide = true
            
            //      点击空白处隐藏
            let tap = UITapGestureRecognizer.init(target: hud, action: #selector(hud.hide(animated:)))
            hud.backgroundView.addGestureRecognizer(tap)
            
            withView.isUserInteractionEnabled = true
            withView.addGestureRecognizer(UITapGestureRecognizer())
            
            
            
            return hud
        }
        return nil
    }
    
    
    
//    static func show(view: UIView,untilEvent: ControlEvent<Void>)-> MBProgressHUD? {
//        if let window = UIApplication.shared.keyWindow {
//            let hud = MBProgressHUD.showAdded(to: window, animated: true)
//            //                hud.backgroundView.frame = window.bounds
//            //                hud.bezelView.style = .solidColor
//            //                hud.bezelView.backgroundColor = UIColor.clear.withAlphaComponent(0)
//            //
//            //                hud.backgroundView.color = UIColor.black.withAlphaComponent(0.2)
//            //                hud.mode = .customView
//            //                hud.customView = view
//            hud.animationType = .zoom
//
//            //            Observable.just("").withLatestFrom(untilEvent).subscribe { (_) in
//            //                hud.hide(animated: true)
//            //            }.disposed(by: window.bag)
//
//            return hud
//        }
//        return nil
//    }
    
    
    public static func undoneRemind() {
        self.remind("持续开发中......")
    }
    
    public static func Alert(title:String,msg: String = "",okHandle:(() ->Void)?) ->Void {
        let alert:UIAlertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let cancle:UIAlertAction = UIAlertAction.init(title:  okHandle == nil ? "确定" : "取消", style: .cancel, handler: nil)
        
        if okHandle != nil {
            let hd:(UIAlertAction)->Void = { _ in
                okHandle?()
            }
            let ok:UIAlertAction = UIAlertAction.init(title: "确定", style: .default, handler: hd)
            alert.addAction(ok)}
        
        alert.addAction(cancle)
        
        
        let VC =  UIWindow.topViewController()
        VC!.present(alert, animated: true, completion: nil)
    }
}



