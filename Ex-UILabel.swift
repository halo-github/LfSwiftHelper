//
//  UILabel-extension.swift
//  xeenho
//
//  Created by 刘峰 on 2018/3/22.
//  Copyright © 2018年 cn.xeenho. All rights reserved.
//

import Foundation
import UIKit
public enum XHfontColorType {
    case normal
    case white
}
public extension UILabel {
    
   public static func autosizeLabel() -> UILabel {
        let lab = UILabel()
        lab.sizeToFit()
        return lab
    }
    public func whiteFontColor() -> UILabel{
        self.textColor = UIColor.white
        return self
    }
    public static func statusLabel() -> UILabel {
        return autosizeLabel().textColor(.white).font(XHFont.jfFont(aiPt: 40)).align(.center)
    }

    
    public static func defaultLab() -> UILabel {
         return autosizeLabel().align(.center)
        
    }
    
    public func font(_ f:UIFont) -> UILabel{
        self.font = f
        return self
    }
    
    public func textColor(_ c:UIColor) -> UILabel{
        self.textColor = c
        return self
    }
    public func align(_ a:NSTextAlignment) -> UILabel{
        self.textAlignment = a
        return self
    }
    public func titile(_ t:String) -> UILabel {
        self.text = t
        return self
    }
    
    
    public func attributeText(text: String, lineSpace: CGFloat)  {
        var paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing  = lineSpace
        let attrStr = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.attributedText = attrStr
    }
    
    
    
}
