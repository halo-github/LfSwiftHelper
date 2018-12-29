//
//  Object-extension.swift

//

import Foundation
import UIKit


//swift 扩展添加属性的方法
//原理：由于swift扩展不能添加存储属性，所以考虑以计算属性获取另一对象的存储属性，该对象通过动态绑定给原对象
//创建协议 包含中间对象，两个用于绑定的key
protocol LFassociateObject {
    var newInstance: AnyObject {get}
//    static var key:UnsafeRawPointer { get }       //key不要用String类型
}
//创建空类，用于生成中间对象
class NewClass: NSObject {
    required override init() {
    }
}
let mid = "dddd"
let midKey:UnsafeRawPointer = UnsafeRawPointer("mid")
//协议扩展，实现中间对象，并绑定
extension LFassociateObject {
    
    var newInstance: AnyObject {
        guard let obj = objc_getAssociatedObject(self, midKey) else {
            let newInstance = NewClass.init()
            objc_setAssociatedObject(self, midKey, newInstance, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newInstance
        }

        return obj as AnyObject
    }
}


extension NSObject {
    func getIvars() {
        var count:UInt32  = 0
        let ivars  = class_copyIvarList(type(of: self), &count)
        for i in 0..<count {
            let ivar = ivars![Int(i)]
            let name = ivar_getName(ivar)
            let nameStr = String.init(cString: name!)
            print(nameStr)
    }
}

    func getProperty() {
        var count:UInt32  = 0
        let properties  = class_copyPropertyList(type(of: self), &count)
        for i in 0..<count {
            let property = properties![Int(i)]
            let name = property_getName(property)
            let nameStr = String.init(cString: name)
            print(nameStr)
        }
    }
}
