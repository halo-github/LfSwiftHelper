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
