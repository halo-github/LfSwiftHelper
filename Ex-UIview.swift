//
//  UIView-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/7/27.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

let SYSVERSION = Double(UIDevice.current.systemVersion)!   //系统版本

//根据手机朝向 获取宽高
var statusbarOrientation = UIApplication.shared.statusBarOrientation
var MAINWIDTH = UIScreen.main.bounds.width
var MAINHEIGHT = UIScreen.main.bounds.height

let isPad = UIDevice.current.model == "iPad"
let padScale = isPad == true ? MAINWIDTH / 667 : 1

let isX: Bool =  max(MAINWIDTH, MAINHEIGHT) >= 812 ? true: false

//已知手机头朝右 获取安全边距
//let safeLeft: CGFloat = isX ? 34 : 0
//let safeRight: CGFloat = isX ? 24 : 0
//let safeWidth: CGFloat = MAINWIDTH - safeLeft - safeRight


//以6的尺寸为标准
let scale6 = MAINHEIGHT/375



func W6(w:CGFloat) -> CGFloat {
    return scale6*w
}
func H6(h:CGFloat) -> CGFloat {
    return scale6*h
}

enum Device:CGFloat {      //机型
    case type4 = 480
    case type5 = 568
    case type6 = 667
    case type6P = 736
    case typeX = 812
}

var XStatubarExtraHeight:CGFloat {
    return  MAINHEIGHT == 812  ? 24 : 0
}

var NAVIBARHEIGHT:CGFloat  {        //导航栏
    if MAINHEIGHT == 812 {
        return 88
    }
    return 64
    
}

//extension CGPoint: Numeric {
//    public typealias Magnitude = <#type#>
//
//    public typealias IntegerLiteralType = <#type#>
//
//
//}

extension CGPoint {
    
    static func  +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func  -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    func distance(to: CGPoint) -> CGFloat {
        return sqrt((self.x - to.x) * (self.x - to.x) + (self.y - to.y) * (self.y - to.y))
    }
    //屏幕上的相对坐标 （左上-右下）
    func coordinate(to: CGPoint) -> CGPoint{
        return CGPoint.init(x: self.x - to.x, y: self.y - to.y)
    }
    
    // 数学坐标系 （左下-右上）
    func anotherCoordinate(to: CGPoint) -> CGPoint {
        return CGPoint.init(x: self.x - to.x, y: to.y - self.y)
    }
    
    func  point(distance: CGFloat, angles: CGFloat) -> CGPoint {
        return CGPoint.init(x: self.x + distance * sin(angles), y: distance * cos(angles))
    }
    func rate(_ r: CGFloat) -> CGPoint {
        return CGPoint.init(x: self.x * r, y: self.y * r)
    }
}


extension CGRect {
    static func Xinit(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat,isTop:Bool = false) -> CGRect {
        return self.init(x: x * scale6, y: y * scale6, width: width * scale6, height: height * scale6)
    }
    
    init (center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width/2, y: center.y - size.height/2), size: CGSize(width: size.width, height: size.height));
    }
}


//MARK:-为view提供内存管理
extension UIView {
    static var bagKey = 123
    
    var bag:DisposeBag {
        guard let bag = objc_getAssociatedObject(self, &UIView.bagKey) else {
            let bag = DisposeBag()
//            print("new bag", bag)
            objc_setAssociatedObject(self, &UIView.bagKey, bag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return bag
        }
//        print("old bag", bag)
        return bag as! DisposeBag
    }
}
//MARK:- UIView frame属性
extension UIView {
    //    var maxHeight: CGFloat {
    //        var maxHeight: CGFloat = 0
    //        maxHeight = self.subviews.reduce(maxHeight) { (new, view) -> CGFloat in
    //            max(view.y() + view.height(), new)
    //        }
    //        return maxHeight + XHspace
    //    }
    //    var maxWidth: CGFloat {
    //        var maxWidth: CGFloat = 0
    //        maxWidth = self.subviews.reduce(maxWidth) { (new, view) -> CGFloat in
    //            max(view.x() + view.width(), new)
    //        }
    //        return maxHeight + XHspace
    //    }
    func resize<T:UIView>(newSize: CGSize) -> T {
        self.frame.size = newSize
        return self as! T
    }
    
    static func color(_ c: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = c
        return view
    }
    
    
    
    func lf_addTo(sup:UIView, x: CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) {
        self.frame = CGRect.Xinit(x: x, y: y, width: width, height: height)
        sup.addSubview(self)
    }
    
    class func W6(w:CGFloat) -> CGFloat {
        return MAINWIDTH/375*w
    }
    
    class func Y6(y:CGFloat) -> CGFloat {
        if MAINHEIGHT == Device.typeX.rawValue {
            return y+24
        } else {
            return y
        }
    }
    
    
    
    
    
    func set(x:CGFloat) -> Void {
        self.frame = CGRect.Xinit(x: x, y: self.y(), width: self.width(), height: self.height())
    }
    func set(y:CGFloat) -> Void {
        self.frame = CGRect.Xinit(x: self.x(), y: y, width: self.width(), height: self.height())
    }
    func set(width:CGFloat) -> Void {
        self.frame = CGRect.Xinit(x: self.x(), y: self.y(), width: width, height: self.height())
    }
    func set(height:CGFloat) -> Void {
        self.frame = CGRect.Xinit(x: self.x(), y: self.y(), width: self.width(), height: height)
    }
    func set(size:CGSize) -> Void {
        self.frame = CGRect.Xinit(x: self.x(), y: self.y(), width: size.width, height: size.height)
    }
    
//    func set(center:CGPoint) -> Void {
//    }
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    func size() -> CGSize {
        return self.frame.size
    }
    func width() -> CGFloat {
        return self.size().width
    }
    func height() -> CGFloat {
        return self.size().height
    }
    
    
    func addBorder(width: CGFloat, color: UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func removeBorder()  {
        self.layer.borderWidth = 0
    }
    
    //    底部线条
    func addBottomLine(space: CGFloat = 0) -> Void {
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        line.alpha = 0.3
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalToSuperview().offset(-space)
            make.bottom.equalToSuperview()
            
            make.bottom.equalToSuperview()
        }
    }
}

func scale6(_ f:CGFloat) -> CGFloat {
    return f * scale6
}

extension UIView {
    
    static func white() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func defaultRadius(radiusScale: CGFloat = 0.5)  {
        self.superview?.layoutIfNeeded()
        self.layer.cornerRadius = min(self.width(), self.height()) * radiusScale
        self.layer.masksToBounds = true
    }
    
    static func maskView(frame: CGRect = CGRect.init(x: 0, y: 0, width: MAINWIDTH, height: MAINHEIGHT), alpha: CGFloat = 0.8) -> UIView {
        let view = UIView.init(frame: frame)
            view.backgroundColor = .black
            view.alpha = alpha
        return view
    }
   
    
     @objc public func removeWithSuperView() {
        if let sup = self.superview  {
            if  sup.subviews.count == 1 {
                    sup.removeFromSuperview()
            }
        }
    }
//    func addBottomLine(space: CGFloat = 0) {
//        let line = UIView.color(.gray)
//        line.frame = CGRect.init(x: 0, y: self.frame.height - 1, width: self.width() - space, height: 1)
//        self.addSubview(line)
//    }
   
   
    
    func flicker(interval: CFTimeInterval = 1,times: Float = MAXFLOAT ) {
        let ani = CAKeyframeAnimation(keyPath: "opacity")
            ani.values = [1,0,1]
            ani.repeatCount = times
            ani.duration = interval
            ani.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            self.layer.add(ani, forKey: "ani")
    }
    
    func Lf_flicker(alpha: CGFloat = 0, timeInterval: TimeInterval = 1, finish: @escaping ()->Bool){
        TimeTool.act(startWith: 0, interval: timeInterval/2, timeHandler: { (_) in
            if self.alpha == 1 {
                self.alpha = alpha
            } else {
                self.alpha = 1
            }
        }, waitStop: { (_) -> Bool in
            return finish()
        }) {
            self.alpha = 1
        }
    }
}


