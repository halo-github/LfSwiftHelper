//
//  UIScrollView-extension.swift
//  Jellyfish
//
//  Created by halo vv on 2018/11/5.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit
extension UIScrollView {
    
    func show(images: [String]) {
        let count = images.count
        let ww = self.bounds.width
        let hh = bounds.height
        self.contentSize = CGSize.init(width: ww * CGFloat(count + 1), height: hh)
        self.isPagingEnabled = true
        self.bounces = true
//        self.co
        print(self)
        images.enumerated().forEach { (idx, name) in
            let img = UIImageView.name(name)
                img.frame = CGRect.init(x: ww * CGFloat(idx), y: 0, width: ww, height: hh)
                print(img.frame)
//            self.addSubview(img)
            
        }
print(self)

    }
    
    func endHandler(_ r :@escaping VoidHandler) {
        self.rx.contentOffset.subscribe(onNext: {
            if $0.x == self.contentSize.width - self.bounds.width {
                r()
            }
        }).disposed(by: self.bag)
    }
}
