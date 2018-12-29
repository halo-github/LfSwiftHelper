//
//  UIColor-Extensive.swift

//

import Foundation
import UIKit
enum XHFont {
    enum XHFontType {
        case semi
        case regular
        case bold
        case none
    }
    case PF
    case LT
    static func jfFont(aiPt: CGFloat) -> UIFont {
        return XHFont.LT.font(type: .none, size: aiPt)
    }
    func font(type:XHFontType,size:CGFloat) -> UIFont {
        var fontName = ""
        switch self {
        case .LT:fontName = "FZLanTingHei-L-GBK"
        case .PF : fontName = "PingFangSC"
        }
        switch type {
        case .semi: fontName.append("-Semibold")
        case .regular:fontName.append("-Regular")
        case .bold:fontName.append("-Bold")
        case .none :break
        }
        var newSize = size
        if AI { newSize = size.V()}
//        if MAINHEIGHT < 375 {     //6以下，大字体需要缩小
//            if newSize > 24 {
//                newSize = newSize - 2
//                if newSize > 40 {
//                    newSize = newSize - 2
//                }
//            }
//        }
        return UIFont.font(name: fontName, pixel: newSize)
    }
}


extension UIColor {
   class func hex(_ hexString:String) -> UIColor {
    guard hexString.hasPrefix("#"), hexString.count == 7 else {
        return UIColor.purple
    }
    var hex:UInt32 = 0
    let xx = hexString.replacingOccurrences(of: "#", with: "0X")
    Scanner(string:xx).scanHexInt32(&hex)
    return self.init(
                       red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(hex & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
    class func randomColor() -> UIColor{
        return self.init(red:(CGFloat(arc4random()%255)/255.0),
                         green:(CGFloat(arc4random()%255)/255.0),
                         blue:(CGFloat(arc4random()%255)/255.0),
                         alpha:1)
    }
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor {
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }

}



extension UIFont {
   private static func pixelFont(pixel:CGFloat)->UIFont {
    
    return UIFont.systemFont(ofSize: MAINHEIGHT == 320 ? pixel - CGFloat(2) : pixel)
    }
    
     static func font(name:String,pixel:CGFloat) -> UIFont {
//        for i in UIFont.familyNames {
//            print("----font family:\(i)")
//            for o in UIFont.fontNames(forFamilyName: i) {
//                print(o)
//            }
//        }
        if #available(iOS 9.0, *){
            return UIFont.init(name: name, size: MAINHEIGHT == 320 ? pixel - CGFloat(2) : pixel)!
            
        }
        return UIFont.pixelFont(pixel: pixel)
    }
//    static func num36() -> UIFont{
//        return XHFont.DIN.font(type: .bold, size: 36)
////        return self.font(name: "DINCondensed-Bold", pixel: 36)
//    }
//    static func num24() -> UIFont{
//        return XHFont.DIN.font(type: .bold, size: 24)
////        return self.font(name: "DINCondensed-Bold", pixel: 24)
//    }
//    static func text24() -> UIFont{
//        return XHFont.PF.font(type: .semi, size: 24)
////        return self.font(name: "PingFangSC-Semibold", pixel: 24)
//    }
//    static func textTitle18() -> UIFont{
//        return XHFont.PF.font(type: .semi, size: 18)
////        return self.font(name: "PingFangSC-Semibold", pixel: 18)
//    }
//    static func text18() -> UIFont{
//        return XHFont.PF.font(type: .regular, size: 18)
////        return self.font(name: "PingFangSC-Regular", pixel: 18)
//    }
//    static func text16() -> UIFont{
//        return XHFont.PF.font(type: .semi, size: 16)
////        return self.font(name: "PingFangSC-Semibold", pixel: 16)
//    }
//    static func text14() -> UIFont{
//        return XHFont.PF.font(type: .regular, size: 14)
////        return self.font(name: "PingFangSC-Regular", pixel: 14)
//    }
//    static func text14Semi() -> UIFont{
//        return XHFont.PF.font(type: .semi, size: 14)
////        return self.font(name: "PingFangSC-Semibold", pixel: 14)
//    }
//    
//    static func text12() -> UIFont{
//        return XHFont.PF.font(type: .regular, size: 12)
////        return self.font(name: "PingFangSC-Regular", pixel: 12)
//    }
}
//MARK:-扩展view的颜色
extension UIView {
     func setGradColorVIew(cgColors:[CGColor]) {
        let gradientlayer = CAGradientLayer.init()
        gradientlayer.frame = self.bounds
        self.layer.addSublayer(gradientlayer)
        gradientlayer.colors = cgColors
        gradientlayer.startPoint = CGPoint.zero
        gradientlayer.endPoint = CGPoint.init(x: 1, y: 1)
        gradientlayer.locations = [0,1]
    }
}
