//
//  UITextView-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/10/12.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    /// 跳转到指定文本
    ///
    /// - Parameter text: 
    func scrollTextTotop(_ text: String) {
//        self.scrollRangeToVisible(self.attributedText.string.nsRange(of: text))
        let textRange = self.textRange(of: text)
        let rect = self.caretRect(for: textRange.start)
        let pt = rect.origin
        let offset = CGPoint.init(x: 0, y: pt.y)
        self.setContentOffset(offset, animated: true)
    }
    
    
    func textRange(of: String) -> UITextRange {
    
        let nsRange = self.text.nsRange(of: of)
        let beginning = self.beginningOfDocument
        let start = self.position(from: beginning, offset: nsRange.location)
        let end = self.position(from: start!, offset: nsRange.length)
        print("------\(nsRange)")
        return self.textRange(from: start!, to: end!)!
    }
    
    func currentTextRect() -> CGRect {
        self.superview?.layoutIfNeeded()
        let offSet = self.contentOffset
        let rect = CGRect.init(x: offSet.x, y: offSet.y, width: self.bounds.width, height: self.bounds.height)
        return rect
    }
    
    func rectOf(textRange: UITextRange) -> CGRect{
//        let textRange = self.textRange(of: str)
        self.superview?.layoutIfNeeded()
        let startRect = self.caretRect(for: textRange.start)
        let endRect = self.caretRect(for: textRange.end)
        let hasRect = CGRect.init(x: 0, y: startRect.origin.y, width: self.bounds.width, height: endRect.origin.y - startRect.origin.y + endRect.height)
        let view = UIView.color(UIColor.randomColor())
        view.frame = hasRect
        self.addSubview(view)
        view.alpha = 0.3
        
        return hasRect
    }
}
