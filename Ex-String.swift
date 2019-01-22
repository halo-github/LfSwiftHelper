//
//  String-extension.swift

//

import Foundation
import UIKit
import CommonCrypto



extension NSAttributedString {
    func newNSAttributedString(color:UIColor) -> NSAttributedString {
        let new : NSMutableAttributedString = NSMutableAttributedString.init(attributedString: self)
        new.addAttribute(.foregroundColor, value: color, range: NSMakeRange(0, self.length))
        return new as NSAttributedString
    }
    
    //下划线
    func fullUnderline() -> NSAttributedString {
        return self.underLineStr(range: NSRange.init(location: 0, length: self.length))
    }
    func underLineStr(range: NSRange) -> NSAttributedString {
        let new : NSMutableAttributedString = NSMutableAttributedString.init(attributedString: self)
        new.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        return new as NSAttributedString
    }
    
    
    
}
extension String {
    //获取NSRange
    func nsRange(of: String) -> NSRange{
        return (self as NSString).range(of:of)
//        let range = self.range(of: of)
//        return  NSRange(range!, in: self)
    }
    //本地化
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
   static func dateStr(date: Date = Date()) -> String {
        let format = DateFormatter()
            format.dateFormat = "yyyyMMddHHss"
        return format.string(from:date)
    }
    
    //MD5
    func md5()->String {
        let md5Len = Int(CC_MD5_DIGEST_LENGTH)
        print(md5Len)
        let cStr = self.cString(using: .utf8)
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: md5Len)
        CC_MD5(cStr, UInt32(strlen(self)), ptr)
        var md5Str = ""
        for i in 0..<md5Len {
            md5Str.append(String.init(format: "%02x", ptr[i]))
        }
        return md5Str
    }
    //字间距
    func wordSpace(_ s: CGFloat) -> NSAttributedString {
        return NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.kern: s])
        
    }
    
    
//    static func rateString(_ rate:String, size:CGFloat, colorHex:String, perSize:CGFloat, perHex:String) ->NSAttributedString {
//        let str:NSMutableAttributedString = NSMutableAttributedString.init(string: rate, attributes: [NSAttributedStringKey.font : XHFont.DIN.font(type: .bold, size: size),NSAttributedStringKey.foregroundColor:UIColor.hex(colorHex)])
//
//        str.append(NSAttributedString.init(string: "%", attributes: [NSAttributedStringKey.font : XHFont.DIN.font(type: .bold, size: perSize),NSAttributedStringKey.foregroundColor:UIColor.hex(perHex)]))
//        return str as NSAttributedString
//    }
    
    //复杂文字
    static func complexAttrString(arr:[[String:[NSAttributedString.Key: Any]]]) -> NSAttributedString{
        let attrStr = NSMutableAttributedString()
        for dic in arr {
            attrStr.append(NSAttributedString.init(string: dic.keys.first!, attributes: dic.values.first!))
        }
        return attrStr as NSAttributedString
    }
    
    //软妹币符号¥+数字 大小不一致 （¥ 1234,567）
//    static func RMB(_ num:String) -> NSAttributedString {
//        return String.complexAttrString(arr:[
//            ["¥ " : [NSAttributedStringKey.font:XHFont.PF.font(type: .semi, size: 24)]],
//            //            [" " : [NSAttributedStringKey.foregroundColor:UIColor.hex("#AFB2BA")]],
//            [num : [NSAttributedStringKey.font:XHFont.DIN.font(type: .bold, size: 36)]]])
//    }
    
    //文字+数字 颜色不一致 （余额：12234）
//    static func strWithNumber(str:String, num:String) -> NSAttributedString {
//        return String.complexAttrString(arr:[
//            [str : [NSAttributedStringKey.foregroundColor:UIColor.hex("#AFB2BA")]],
//            [" " : [NSAttributedStringKey.foregroundColor:UIColor.hex("#AFB2BA")]],
//            [num : [NSAttributedStringKey.foregroundColor:UIColor.hex("#5F6575")]]])
//    }
    //数字加单位 大小不一致 （12234元）
    
//    static func numberWithUnit(num:String, unit:String, defaultColor: UIColor = UIColor.white) -> NSAttributedString {
//        return String.complexAttrString(arr:[
//            [num : [NSAttributedStringKey.font:XHFont.DIN.font(type: .bold, size: 24), NSAttributedStringKey.foregroundColor: defaultColor]],
////            [" " : [NSAttributedStringKey.foregroundColor:UIColor.hex("#AFB2BA")]],
//            [unit : [NSAttributedStringKey.font:XHFont.PF.font(type: .regular, size: 14), NSAttributedStringKey.foregroundColor: defaultColor]]])
//    }
    
    //银行卡只显示后四位
//    func bankCardSecurity() -> String {
//        let str = self.suffix(4)
//        return "**** **** **** " + str.description
//    }
//
//
//    func scanFloat() -> Float {
//        let scanner = Scanner(string: self)
//        scanner.scanUpToCharacters(from: .decimalDigits, into: nil)
//        var num:Float = 0.0
//        scanner.scanFloat(&num)
//        return num
//    }
//
//    func scanInt() -> Int {
//        let scanner = Scanner(string: self)
//        scanner.scanUpToCharacters(from: .decimalDigits, into: nil)
//        var num:Int = 0
//        scanner.scanInt(&num)
//        return num
//    }
    
   
}

//extension String {
//    func mj_underlineFromMinus()->String {
//        if self.count == 0 { return self }
//        let arr: NSArray = self.components(separatedBy: "-") as NSArray
//        let str = arr.componentsJoined(by: "_")
//        return str
//    }
//}


func filePath(name:String,extend: String) -> String? {
    return Bundle.main.path(forResource: name, ofType: extend)
}

