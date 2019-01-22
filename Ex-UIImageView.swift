//
//  File.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/3.
//  Copyright © 2018年 liufeng. All rights reserved.
//

//在retina屏幕下程序会自动寻找@2x图片，如果没有后缀为@2x图片，就会自动拉伸非@2x图片，所以尽量将你的图片都带上@2x后缀，这样就不会造成在使用resizableImageWithCapInsets时因无法找到@2x图片对原图进行拉伸进而再使用resizableImageWithCapInsets进行平铺时造成图片变形问题。
//
//作者：月咏蝴蝶
//链接：https://www.jianshu.com/p/806afec8f463
//來源：简书
//简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
import Foundation
import UIKit

public extension UIImageView {
    
    public static func name(_ n: String) -> UIImageView {
        return UIImageView.init(image: UIImage.init(named: n))
}
    public static func aspectAscale(name: String) -> UIImageView {
        let i = UIImageView.name(name)
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = false
        return i
    }

    
    
    
}

public extension UIImage {
    func resizeImage() -> UIImage{
        let ww = self.size.width/2
        let hh = self.size.height/2
        let img = self.resizableImage(withCapInsets: UIEdgeInsets.init(top: hh, left: ww, bottom: hh , right: ww))
        return img
    }
}


public enum ImageShiftType {
    case swipeLeft
    case swipeRight
    case tapRight
}

public class SwipeImageView: UIImageView {
    var imageNames: [String]?
    var images: [UIImage]?
    var currentIdx: Int = 0
    var endhandler: VoidHandler?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(type:ImageShiftType) {
        switch type {
        
        case .swipeLeft:
            let gstL = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeLeft))
            gstL.direction = .left
            self.addGestureRecognizer(gstL)
        case .swipeRight:
            let gstR = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeRight))
            gstR.direction = .right
            self.addGestureRecognizer(gstR)
        case .tapRight:
            let tapGst = UITapGestureRecognizer.init(target: self, action: #selector(swipeLeft))
            self.addGestureRecognizer(tapGst)
        }
    }
    
   public func endHandler(_ r :@escaping VoidHandler) {
        
    }
    @objc func swipeLeft() {
//      self.contentMode = .scaleAspectFit
//        let ani = CATransition.init()
//        ani.duration = 0.5
////        ani.timingFunction =
//        ani.subtype =  CATransitionSubtype.fromRight
//        ani.type = .push
//        self.layer.add(ani, forKey: "a")
        let idx = currentIdx + 1
        
        if idx == self.images?.count {
            print("end")
            self.image = UIImage()
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }) { (_) in
                self.removeFromSuperview()
                self.endhandler?()
            }
            
        } else {
            self.image = self.images?[idx]
//        let name = imageNames?[idx]
//        self.image = UIImage.init(named: name!)
       
        self.currentIdx = idx
        }
    }
    
    @objc func swipeRight() {
        if currentIdx == 0 { return}
        let ani = CATransition.init()
        ani.duration = 0.5
        ani.subtype =  CATransitionSubtype.fromLeft
        ani.type = .push
        self.layer.add(ani, forKey: "a")
        
//        self.contentMode = .scaleAspectFit
        let idx = currentIdx - 1
        
        if idx < (self.images?.count)! - 1  {
            self.image = self.images?[idx]
//            let name = imageNames?[idx]
//            self.image = UIImage.init(named: name!)
            
            
            self.currentIdx = idx
        }
    }
}
