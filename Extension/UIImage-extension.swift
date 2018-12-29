//
//  UIImage-extension.swift
//  xeenho
//
//  Created by 刘峰 on 2018/3/21.
//  Copyright © 2018年 cn.xeenho. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    static func image(rect:CGRect,color:UIColor) -> UIImage{
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    static func image(text: NSString,font: UIFont) -> UIImage {
        let size = text.size(withAttributes: [NSAttributedString.Key.font:font])
        let size1 = CGSize.init(width: size.width, height: 20)
        
        UIGraphicsBeginImageContext(size1)
        text .draw(at: CGPoint.init(x: 0, y: 0), withAttributes: [NSAttributedString.Key.font:font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func resize(imageName:String, size:CGSize) -> UIImage {
        let img = UIImage.init(named: imageName)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        img?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg!
    }
    static func defaultNaviBackImage ( ) -> UIImage {
        return UIImage.image(rect: CGRect.init(x: 0, y: -44, width: MAINWIDTH, height: 100), color: UIColor.white)
    }
    
     func image(newRect: CGRect) -> UIImage {
        let cgImage = self.cgImage
        let newCGImage = cgImage?.cropping(to: newRect)
        return UIImage.init(cgImage: newCGImage!, scale: UIScreen.main.scale, orientation: .up)
    }
    
}



