//
//  UILabel-extension.swift
//  xeenho
//
//  Created by 刘峰 on 2018/3/22.
//  Copyright © 2018年 cn.xeenho. All rights reserved.
//

import Foundation
import UIKit
enum XHfontColorType {
    case normal
    case white
}
extension UILabel {
    
    static func autosizeLabel() -> UILabel {
        let lab = UILabel()
        lab.sizeToFit()
        return lab
    }
    func whiteFontColor() -> UILabel{
        self.textColor = UIColor.white
        return self
    }
    static func statusLabel() -> UILabel {
        return autosizeLabel().textColor(.white).font(XHFont.jfFont(aiPt: 40)).align(.center)
    }
//    static func Lab36 (_ title:String,type:XHfontColorType = .normal)-> UILabel {
//        return autosizeLabel().font(UIFont.num36()).align(.center).textColor(UIColor.white).titile(title)
//    }
//    //24号字体lab
//    static func Lab24 (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text24()).align(.center).textColor(UIColor.hex("#373F52")).titile(title)
//    }
//    //18号字体lab
//    static func Lab18 (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.textTitle18()).align(.center).textColor(UIColor.hex("#373F52")).titile(title)
//    }
//    
//    static func Lab16 (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text16()).align(.center).textColor(UIColor.hex("#373F52")).titile(title)
//    }
//    
//    static func Lab14 (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text14()).align(.center).textColor(UIColor.hex("#373F52")).titile(title)
//    }
//    
//    static func Lab14Light (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text14()).align(.center).textColor(UIColor.hex("#5F6575")).titile(title)
//
//    }
//    
//    
//    //12号字体lab--文字
//    
//    static func Lab12 (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text12()).align(.center).textColor(UIColor.hex("#AFB2BA")).titile(title)
//
//    }
//    
//    static func Lab12Num (_ title:String)-> UILabel {
//        return autosizeLabel().font(UIFont.text12()).align(.center).textColor(UIColor.hex("#5F6575")).titile(title)
//
//    }
    
    static func defaultLab() -> UILabel {
         return autosizeLabel().align(.center)
        
    }
    
    func font(_ f:UIFont) -> UILabel{
        self.font = f
        return self
    }
    
    func textColor(_ c:UIColor) -> UILabel{
        self.textColor = c
        return self
    }
    func align(_ a:NSTextAlignment) -> UILabel{
        self.textAlignment = a
        return self
    }
    func titile(_ t:String) -> UILabel {
        self.text = t
        return self
    }
    
    
    func attributeText(text: String, lineSpace: CGFloat)  {
        var paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing  = lineSpace
        let attrStr = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attrStr
    }
    
    
    
}
