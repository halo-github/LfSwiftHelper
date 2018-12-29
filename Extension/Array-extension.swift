//
//  Array-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/9/3.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


extension Array where Element: NSObject {

}



extension Array where Element : UIView {
    func  equalLayoutHorizon(on : UIView, autoSize: Bool = true) {
        on.layoutIfNeeded()
        self.enumerated().forEach { (idx, view) in
                        view.lf_sup_divideXY(view: on, YdividedBy: 1, Yindex: 0, XdividedBy: self.count, Xindex: idx,
                                 width: autoSize == true ? -1 : on.width() / CGFloat(self.count),
                                 height: autoSize == true ? -1 : on.height())
        }
    }
    
//    在指定矩形内等距排列
    
    func suibian(on: UIView, equalSize: CGSize = CGSize.init(width: -1, height: -1)) {
        on.layoutIfNeeded()
        
        var arr = self
        let first = arr.removeFirst()
        first.lf_sup_centerY(on, left: 0, width: equalSize.width, height: equalSize.height)
        _ = arr.reduce(first) { (view1, view2) -> UIView in
            view2.lf_sub_centerY(view1, left: 0, width: equalSize.width, height: equalSize.height)
            return view2
        }
        on.layoutIfNeeded()
        let totalW = self.reduce(0) { (w, view) -> CGFloat in
            return w + view.bounds.width
        }
        let space = (on.width() - totalW)/CGFloat(self.count - 1)
        _ = arr.reduce(first, { (v1, v2) -> UIView in
            v2.snp.updateConstraints({ (make) in
                make.left.equalTo(v1.snp.right).offset(space)
                
            })
            return v2
        })
        
        
        
        
    }
    
    
    
    func  equalLayoutVertical(on : UIView, autoSize: Bool = true) {
        on.layoutIfNeeded()
        self.enumerated().forEach { (idx, view) in
            view.lf_sup_divideXY(view: on, YdividedBy: self.count, Yindex: idx, XdividedBy: 1, Xindex: 0 ,
                                 width: autoSize == true ? -1 : on.width() ,
                                 height: autoSize == true ? -1 : on.height() / CGFloat(self.count))
        }
    }
    
}

extension Array where Element: UIButton {
    func selectTap(r:@escaping (_ it: Int)->Void)  {
        self.enumerated().forEach { (idx,btn) in
            btn.rx.tap.throttle(0.5, scheduler: MainScheduler.instance).subscribe({ (_) in
                self.forEach({ (button) in
                    let b = (btn == button)
                    button.isSelected = b
                    
                })
                r(idx)
    
            }).disposed(by: (self.first?.bag)!)
            
        }
    }
    

}


extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let idx = self.index(of: object) {
            self.remove(at: idx)
        }
    }
}

var rxCountKey = 111
let count123Key: UnsafeRawPointer = UnsafeRawPointer("count123Key")
extension Array where Element: Equatable {
    

    

    
    
    
    mutating func rx_append(_ element: Element,countoOb: PublishSubject<Int>) {
        self.append(element)
        countoOb.onNext(self.count)
    }
    
    mutating func rx_remove(element: Element, countoOb: PublishSubject<Int>)  {
        self.remove(object: element)
        countoOb.onNext(self.count)
    }
    
    mutating func rx_removeAll(countoOb: PublishSubject<Int>) {
        self.removeAll()
        countoOb.onNext(0)
    }
    
}
