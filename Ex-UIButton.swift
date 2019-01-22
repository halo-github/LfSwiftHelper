//
//  UIButton-extension.swift
//  xeenho
//
//  Created by 刘峰 on 2018/3/12.
//  Copyright © 2018年 cn.xeenho. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
public extension UIButton {
    
   public static func sizedImageButton(imageName:String,size: CGSize) -> UIButton {
            let btn = UIButton.init(type: .custom)
        let imageV = UIImageView.init(image: UIImage.init(named: imageName))
        imageV.isUserInteractionEnabled = false
        btn.addSubview(imageV)
        imageV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        }
        return btn
    }
   
    
    
    
//    var backColor:Binder<Bool> {
//        return Binder(self){ b ,c in
//            b.backgroundColor = c ? UIColor.hex("#CB9C56") : UIColor.hex("#CBD1E0")
//        }
//    }
    
//    func setBackgroudColor(_ color:UIColor,forState:UIControlState) {
//        self.rx.isEnabled.
//    }
    
//    static func titleLeadingImageButton(title: String, image: String) -> UIButton {
//        let btn = UIButton.init(type: .custom)
//        btn.setTitle(title, for: .normal)
//        btn.setTitleColor(UIColor.hex("#5F6575"), for: .normal)
//        btn.titleLabel?.font = XHFont.PF.font(type: .regular, size: 14)
//        btn.setImage(UIImage.init(named: image), for: .normal)
//        btn.titleLeading()
//        return btn
//    }
//    func imageShift(selectedImage:String,anotherSelectImage:String) -> UIButton {
//        self.setImage(UIImage.init(named: selectedImage), for: .selected)
//        self.setImage(UIImage.init(named: anotherSelectImage), for: .disabled)
//        self.rx.tap.bind(to: self.rx.shiftImageBinder).disposed(by: self.bag)
//        return self
//    }
    
    
    
   public static func defaultBtn() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.sizeToFit()
        return btn
    }
    //文字按钮
   public static func titleButton(_ title:String) -> UIButton {
        let btn = UIButton.defaultBtn()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = XHFont.PF.font(type: .regular, size: 14)
        btn.isEnabled = true
        
        return btn
    }
    
    //设置标题颜色
    //纯图按钮
   public static func imageButton(_ image:String) -> UIButton {
        let img = UIImage.init(named: image)
        let btn = defaultBtn()
            btn.setImage(img, for: .normal)
        return btn
    }
    
    
    public func title(_ t: String, state: UIControl.State = .normal) -> UIButton {
        self.setTitle(t, for: state)
        return self
    }
    
    public func titleColor(_ c: UIColor, state: UIControl.State = .normal) -> UIButton {
        self.setTitleColor(c, for: state)
        return self
    }
    
    public func titleFont(_ f: UIFont) -> UIButton {
        self.titleLabel?.font = f
        return self
    }
    
    public func selectedStatusEnable() -> UIButton {
        self.rx.tap.subscribe{_ in
            self.isSelected = !self.isSelected
        }.disposed(by: self.bag)
        return self
    }
    
    //调整图片
//    static func imageButton(_ image:String,newSize:CGSize) -> UIButton {
//        let img = UIImage.resize(imageName: image, size: newSize)
//        let btn = UIButton.init(type: .custom)
//        btn.setBackgroundImage(img, for: .normal)
//        return btn
//    }
    
    
    public static func ImageTitleButton(image:String,title:String) -> UIButton {
        let btn = UIButton.defaultBtn()
        btn.setImage(UIImage.init(named: image), for: .normal)
        btn.setTitle(title, for: .normal)
        return btn
    }
//    func topImageBottomTitle(space: CGFloat) {
//        self.superview?.layoutIfNeeded()
//        self.contentHorizontalAlignment = .center
//        let imageSize = self.imageView?.size()
//        let titleSize = self.titleLabel?.size()
//        self.titleEdgeInsets = UIEdgeInsets(top: (imageSize!.height + (titleSize?.height)! + space),
//                                            left: -((imageSize?.width)!), bottom: 0, right: 0)
//        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -((titleSize?.width)!))
//    }
//
//    static func titleImageButton(title:String, image:String) -> UIButton {
//        let btn = UIButton.ImageTitleButton(image: image, title: title)
//        return btn
//    }
//    //titile,image调换位置，需要在实际约束之后调用
//    func titleLeading() {
//                let imageW = self.imageView?.bounds.size.width
//                let titleW = self.titleLabel?.bounds.size.width
//                self.frame = CGRect.init(x: self.x(), y: self.y(), width: self.width() , height: self.height())
//                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageW!, bottom: 0, right: imageW!)
//                self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleW!, bottom: 0, right: -titleW!)
//
//
//    }
//
//    //禁用
//
    //多了选中状态图
    public static func selectedImageButton(_ image:String,selectedImage:String) -> UIButton {
        let btn = UIButton.imageButton(image)
        btn.setImage(UIImage.init(named: selectedImage), for: .selected)
        btn.rx.tap.subscribe { (_) in
            btn.isSelected = !btn.isSelected
        }.disposed(by: btn.bag)
        return btn
    }
//    //切换选中状态图
//    static func imageShiftButton(title:String, image:String,selectedImage:String,anotherSelectImage:String) -> UIButton {
//        let btn = UIButton.titleImageButton(title: title, image: image)
//        btn.setImage(UIImage.init(named: selectedImage), for: .selected)
//        btn.setImage(UIImage.init(named: anotherSelectImage), for: .disabled)
//        btn.rx.tap.bind(to: btn.rx.shiftImageBinder).disposed(by: btn.bag)
//        return btn
//    }
    
//    static func defaultSelectButton() -> UIButton {
//        return UIButton.selectedImageButton("未勾选2", selectedImage: "勾选")
//    }
    
//调整按钮图片比例位置。不好用
       public func set(image anImage: UIImage?, title: String,
                   titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    //同上
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    

}




////图上字下的按钮
//class TitleDownControl: UIControl {
//
//    var titleSize:CGSize?
//    var imageSize:CGSize?
//    var space:CGFloat?
//    var titleView = UILabel()
//    var imageView = UIImageView()
//
//    var topView : UIView?
//    var bottom : UIView?
//
//    func layout(top:UIView, topSize:CGSize, bottom:UIView, bottomSize:CGSize) {
//        //上面的 view中心点定在父视图的1/3，下层 2/3
//        top.lf_layout(view: self, vertical: .sup_vertical(v: .center(multipliedBy: 1/3)),  horizon: .sup_horizon(h: .center(multipliedBy: 1/2)), width: topSize.width, height: topSize.height)
//
//        bottom.lf_layout(view: self, vertical: .sup_vertical(v: .center(multipliedBy: 2/3)), horizon: .sup_horizon(h: .center(multipliedBy: 1/2)), width: bottomSize.width, height: bottomSize.height)
//    }

//    init(title:String,fontSize:CGFloat, titleSize:CGSize, image:String,imageSize:CGSize) {
//        super.init(frame:.zero)
//
//        self.titleView.font = UIFont.text14()
//        self.titleView.adjustsFontSizeToFitWidth = true
//        self.titleView.textColor = UIColor.hex("#373F52")
//        self.titleView.text = title
//        self.titleView.textAlignment = .center
//
//        self.imageView.image = UIImage.init(named: image)
//        self.imageView.contentMode = .center
//        self.layout(top: self.imageView, topSize: imageSize, bottom: self.titleView, bottomSize: titleSize)
//    }
    
//    //“我的”页面图上文下的按钮
//    convenience init(forUser title:String,image:String) {
//        self.init(title: title, fontSize: 14, titleSize: CGSize.init(width: 56, height: 20), image:image, imageSize: CGSize.init(width: 20, height: 16))
//    }
//    //“会员中心”页面图上文下按钮
//     init(menberCenterimageName: String,title: String) {
//        let ww = MAINWIDTH/3
//        super.init(frame: CGRect.init(x: 0, y: 0, width: ww, height: ww))
//        imageView = UIImageView.init(image: UIImage.init(named: menberCenterimageName))
//        imageView.xh_sup_multXY(view: self, multY: 1/3, multX: 1/2, width: 40, height: 40)
//        titleView = UILabel.Lab14(title)
//        titleView.xh_sup_multXY(view: self, multY: 2/3, multX: 1/2, width: -1, height: 20)
//    }
    
    
    
//    双层不同属性的标题的按钮
//     init( topTitle:NSAttributedString, topSize: CGSize, bottomTitle:NSAttributedString,bottomSize:CGSize) {
//        super.init(frame: .zero)
//        let top = UILabel(),bottom = UILabel()
//        top.attributedText = topTitle
//        bottom.attributedText = bottomTitle
//        self.layout(top: top, topSize: topSize, bottom: bottom, bottomSize: bottomSize)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}


//extension Reactive where Base:UIButton {
//    var selectTitleColorBinder: Binder<Void>{
//        return Binder(base){ btn,_ in
//            btn.isSelected = !btn.isSelected
//            btn.setTitleColor(btn.isSelected ? UIColor.hex("#F76754") : UIColor.hex("#5F6575"), for: .normal)
//        }
//    }
//    var xh_enabledColor:Binder<Bool> {
//        return Binder(base) { btn,enabled in
//            btn.isEnabled = enabled
//            btn.backgroundColor = enabled ? UIColor.hex("#F76754") : UIColor.hex("#CBD1E0")
//
//        }
//    }
//    var shiftImageBinder:Binder<Void> {
//        return Binder(base) { btn,_ in
//            let current = btn.image(for: .selected)
//            let next = btn.image(for: .disabled)
//            btn.setImage(next, for: .selected)
//            btn.setImage(current, for: .disabled)
//        }
//    }
//}



public extension Reactive where Base: UIButton {
    

    public var selectTap: Observable<Bool> {
        return base.rx.tap.map{ self.base.isSelected }
    }
    public func longTap(minTime: TimeInterval) {
        let pub = PublishSubject<Int>.init()
        var now: Date?
        
        base.rx.controlEvent(.touchDown).subscribe {_ in
            now = Date()
        }.disposed(by: base.bag)
        base.rx.tap.subscribe {_ in
            if Date().timeIntervalSince(now!) > 0.5 {
                pub.onNext(1)
                pub.onCompleted()
            }
        }.disposed(by: base.bag)
        
        pub.subscribe { (_) in
            print("longTap(minTime: TimeInterval")
        }.disposed(by: base.bag)
    }
}
