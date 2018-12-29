//
//  UIView-Extensive.swift

//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit



















struct LayoutStruct {
    var target:targetConstrainType
    var vertical:CGFloat
    var horizon:CGFloat
    var width:CGFloat
    var height:CGFloat

}
enum targetConstrainType {
    case horizon(to:UIView)
    case vertical(to:UIView)
    case superview(view:UIView)
}




enum TargetViewType {
    enum HorizonAlign {
        case left,right,center
    }
    enum VerticalAlign {
        case top,bottom,center
    }
    enum HorizonDirection {
        case left(ConstraintRelatableTarget)
        case right(ConstraintRelatableTarget)
        case center(multipliedBy:CGFloat)
        case divide(divided: Int, index: Int)
        case align(HorizonAlign)
    }
    enum VerticalDrection {
        case top(ConstraintRelatableTarget)
        case bottom(ConstraintRelatableTarget)
        case center(multipliedBy:CGFloat)
        case divide(divided: Int, index: Int)
        case align(VerticalAlign)
    }
    case sup_vertical(v:VerticalDrection)
    case sup_horizon(h:HorizonDirection)
    case sub_vertical(v:VerticalDrection)
    case sub_horizon(h:HorizonDirection)
}





//MARK:- snp 的封装
extension UIView{

//约束的时候统一使用left,top,width,height，以根据屏幕宽度适配机型
//iPhone X 额外判断
    
    //二等分父视图，子视图中心点分别在父视图的 1/4，3/4
    //三等分父视图，子视图中心点分别在父视图的 1/6，1/2，5/6
    
//    func lf_divide(views:[UIView]){
//        let count = views.count
//        for (i,view) in views.enumerated() {
//            view.lf_sup_centerY(view: self, multX: CGFloat(i/count + 1/(count * 2)), width: -1, height: -1)
//        }
//    }
    
    
   public func convert(_ contraintTarget:ConstraintRelatableTarget) -> ConstraintRelatableTarget {
        //有瑕疵   swift 的类型判断会自动判断整数为 Int， 从而不能转换成CGFloat
        var numOnPhone: CGFloat = 0
//        if AI {
            if  let tg = contraintTarget as? Int {
                numOnPhone = CGFloat(tg)
                    return numOnPhone * padScale
            }
            if let tg = contraintTarget as? CGFloat {
                numOnPhone = CGFloat(tg) 
                    return numOnPhone * padScale
            }
//        }

        return contraintTarget
    }
    
    //视图在同一父视图上两个子视图之间居中
    //X轴
    func lf_horizon_center(view1: UIView,view2: UIView,width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        guard view1.superview == view2.superview else {
            return
        }
        guard let sup = view1.superview else {
            return
        }
        sup.layoutIfNeeded()
        sup.addSubview(self)
        
        self.snp.makeConstraints { (make) in
            self.widthConstraint(make: make, width: width)
            self.heightConstraint(make: make, height: height)
            make.top.equalTo(view1)
            make.centerX.equalTo(view1.center.x/2 + view2.center.x/2)
        }
    }
    
    //Y轴
    func lf_vertical_center(view1: UIView,view2: UIView,width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        guard view1.superview == view2.superview else {
            return
        }
        guard let sup = view1.superview else {
            return
        }
        sup.layoutIfNeeded()
        sup.addSubview(self)
        
        self.snp.makeConstraints { (make) in
//            make.centerX.equalTo(view1.center)
            make.left.equalTo(view1)
            make.centerY.equalTo(view1.center.y/2 + view2.center.y/2)
            self.widthConstraint(make: make, width: width)
            self.heightConstraint(make: make, height: height)
        }
        
    }
    
    
    // 父视图左上约束
    func lf_super_left(_ sup:UIView, top:ConstraintRelatableTarget, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sup,
                       vertical: .sup_vertical(v: .top(top)),
                       horizon: .sup_horizon(h: .left(left)),
                       width: width,
                       height: height)
    }
    //父视图右上约束
    func lf_super_right(_ sup:UIView, top:ConstraintRelatableTarget, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sup,
                            vertical: .sup_vertical(v: .top(top)),
                            horizon: .sup_horizon(h: .right(right)),
                            width: width,
                            height: height)
    }
    //父视图水平居中，顶约束
    func lf_super_centerX(_ sup:UIView, top:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sup,
                       vertical: .sup_vertical(v: .top(top)),
                       horizon: .sup_horizon(h: .align(.center)),
                       width: width,
                       height: height)
    }
    //父视图居中对齐，左约束
    func lf_sup_centerY(_ sup:UIView, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget)  {
        self.lf_layout(view: sup, vertical: .sup_vertical(v: .align(.center)), horizon: .sup_horizon(h: .left(left)), width: width, height: height)
    }
    //父视图居中对齐，右约束
    func lf_sup_centerY(_ sup:UIView, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget)  {
        self.lf_layout(view: sup, vertical: .sup_vertical(v: .align(.center)), horizon: .sup_horizon(h: .right(right)), width: width, height: height)
    }
    //子视图居中对齐，左约束
    func lf_sub_centerY(_ sub:UIView, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .align(.center)),
                       horizon: .sub_horizon(h: .left(left)),
                       width: width,
                       height: height)
    }
    //子视图中心水平对齐
    func lf_sub_centerY(_ sub:UIView, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .align(.center)),
                       horizon: .sub_horizon(h: .right(right)),
                       width: width,
                       height: height)
    }
    //子视图中心水平对齐
    func lf_sub_centerY(_ sub:UIView, sup_right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .align(.center)),
                       horizon: .sup_horizon(h: .right(sup_right)),
                       width: width,
                       height: height)
    }
    
    
    //子视图垂直对齐
    func lf_sub_left(_ sub:UIView, top:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .top(top)),
                       horizon: .sub_horizon(h: .align(.left)),
                       width: width,
                       height: height)
    }
    // 子视图底部对父视图，左约束
    func lf_sup_bottom(_ sup:UIView, bottom:ConstraintRelatableTarget, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sup,
                       vertical: .sup_vertical(v: .bottom(bottom)),
                       horizon: .sup_horizon(h: .left(left)),
                       width: width, height: height)
    }
    
    // 子视图底部对父视图,右约束
    func lf_sup_bottom(_ sup:UIView, bottom:ConstraintRelatableTarget, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sup,
                       vertical: .sup_vertical(v: .bottom(bottom)),
                       horizon: .sup_horizon(h: .right(right)),
                       width: width, height: height)
    }
    //子视图居中，底部约束
    func lf_sup_bottom_centerX(_ sup:UIView, bottom:ConstraintRelatableTarget,  width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sup, vertical: .sup_vertical(v: .bottom(bottom)), horizon: .sup_horizon(h: .align(.center)), width: width, height: height)
    }
    
    //子视图中心垂直对齐
    func lf_sub_centerX(_ sub:UIView, top:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget ) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .top(top)),     //垂直间隔
                       horizon: .sub_horizon(h: .align(.center)),
                       width: width,
                       height: height)
    }
    //子视图顶对齐
    func lf_sub_equal_top(_ sub:UIView, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .align(.top)),
                       horizon: .sub_horizon(h: .left(left)),
                       width: width, height: height)
    }
    
    func lf_sub_equal_top(_ sub:UIView, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sub,
                       vertical: .sub_vertical(v: .align(.top)),
                       horizon: .sub_horizon(h: .right(right)),
                       width: width, height: height)
    }
    
    //父视图左约束，子视图顶约束
    func lf_sub_top_sup_left(_ sub:UIView, top:ConstraintRelatableTarget, left:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sub, vertical: .sub_vertical(v: .top(top)), horizon: .sup_horizon(h: .left(left)), width: width, height: height)
    }
    //父视图右约束，子视图左约束
    func lf_sub_top_sup_right(_ sub:UIView, top:ConstraintRelatableTarget, right:ConstraintRelatableTarget, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sub, vertical: .sub_vertical(v: .top(top)), horizon: .sup_horizon(h: .right(right)), width: width, height: height)
    }
    
    //子视图垂直中心对齐，父视图右约束
    func lf_sub_centerY_super_right(_ sub:UIView, right:ConstraintRelatableTarget,width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: sub, vertical: .sub_vertical(v: .align(.center)), horizon: .sup_horizon(h: .right(right)), width: width, height: height)
    }
    //父视图水平等分
    func lf_sup_multCenterX(_ sup: UIView, top:ConstraintRelatableTarget, multX: CGFloat, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        lf_layout(view: sup,
                  vertical: .sup_vertical(v: .top(top)),
                  horizon: .sup_horizon(h: .center(multipliedBy: multX)),
                  width: width, height: height)
    }
    //父视图垂直等分
    func lf_sup_multCenterY(_ sup: UIView, left:ConstraintRelatableTarget, multipliedBy: CGFloat, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        lf_layout(view: sup,
                  vertical: .sup_vertical(v: .center(multipliedBy: multipliedBy)),
                  horizon: .sup_horizon(h: .left(left)),
                  width: width, height: height)
    }
    
    //Y轴居中，X轴等分
    func lf_sup_centerY(view:UIView, multX: CGFloat, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: view, vertical: .sup_vertical(v: .align(.center)), horizon: .sup_horizon(h: .center(multipliedBy: multX)), width: width, height: height)
    }
    
    //X轴居中，Y轴等分
    func lf_sup_centerX(view:UIView, multY: CGFloat, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: view, vertical: .sup_vertical(v: .center(multipliedBy: multY)), horizon: .sub_horizon(h: .align(.center)), width: width, height: height)
    }
    
    // x,y按比例排列
    func lf_sup_multXY(view:UIView,multY:CGFloat, multX:CGFloat,  width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: view, vertical: .sup_vertical(v: .center(multipliedBy: multY)),
                       horizon: .sup_horizon(h: .center(multipliedBy: multX)), width: width, height: height)
    }
    
    func lf_sup_divideXY(view:UIView,YdividedBy:Int, Yindex:Int, XdividedBy:Int, Xindex: Int, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: view, vertical: .sup_vertical(v: .divide(divided: YdividedBy, index: Yindex)), horizon: .sup_horizon(h: .divide(divided: XdividedBy, index: Xindex)), width: width, height: height)
    }
    
    //x,y居中
    func lf_sup_centerXY(view:UIView, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        self.lf_layout(view: view,
                       vertical: .sup_vertical(v: .align(.center)), horizon: .sup_horizon(h: .align(.center)),
                       width: width, height: height)
    }
    

    func lf_betweenHorizon(leftDireciont: Bool = true ,first: UIView, second: ConstraintRelatableTarget,width: ConstraintRelatableTarget,height: ConstraintRelatableTarget)  {
        let sup = first.superview
        sup?.layoutIfNeeded()
        sup?.addSubview(self)
        var centerX:CGFloat = 0
        if let secondV = second as? UIView {                                                //第二项是否UIView
            centerX = (first.center.x + secondV.center.x)/2
        } else {
            if let secondFloat = second as? CGFloat {                                      //是否CGFloat
                let firstX = leftDireciont == true ? first.frame.maxX : first.frame.minX
                centerX = (firstX + secondFloat)/2
            } else if let secondInt = second as? Int {                                                  //Int
                let firstX = leftDireciont == true ? first.frame.maxX : first.frame.minX
                centerX = (firstX + CGFloat(secondInt))/2
            } else { return}
        }
        
        self.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerX)
            make.centerY.equalTo(first)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }

    

//    主要是提供一个水平约束和一个垂直约束，并区别对待父视图和子视图，各种对齐方式
    func lf_layout(view:UIView, vertical:TargetViewType, horizon:TargetViewType, width:ConstraintRelatableTarget, height:ConstraintRelatableTarget) {
        if case TargetViewType.sub_horizon(_) = horizon {               //模式匹配 if case let
            guard let sup = view.superview else {return}
            sup.addSubview(self)
        }
        else if case TargetViewType.sub_vertical(_) = vertical {
            guard let sup = view.superview else {return}
            sup.addSubview(self)
        }
        else {
            view.addSubview(self)
        }
        
        
        
        
        self.snp.makeConstraints { (make) in
            
//            if AI {
//                self.widthConstraint(make: make, width: width.V())
//                self.heightConstraint(make: make, height: height.V())
//                self.verticalConstraint(view: view, make: make, vertical: vertical)
//                self.horizonConstraint(view: view, make: make, horizon: horizon)
//            }
            self.widthConstraint(make: make, width: width)
            self.heightConstraint(make: make, height: height)
            self.verticalConstraint(view: view, make: make, vertical: vertical)
            self.horizonConstraint(view: view, make: make, horizon: horizon)
        }

    }
    
    
    
    
    func  widthConstraint(make:ConstraintMaker, width:ConstraintRelatableTarget) {
        if let wid = convert(width) as? CGFloat {
            if wid > -0.1 {                      //测送中5s，wid为-0.83
                make.width.equalTo(wid)
            }
        } else {
            make.width.equalTo(width)
        }
}
    func  heightConstraint(make:ConstraintMaker, height:ConstraintRelatableTarget) {
        if let ht = convert(height) as? CGFloat {
            if ht > -0.1 {
                make.height.equalTo(ht)
            }
        } else {
            make.height.equalTo(height)
        }
    }
    //垂直方向
    func  verticalConstraint(view:UIView, make:ConstraintMaker, vertical:TargetViewType){
        switch vertical{
        case .sup_vertical(let v):
            switch v {
            case .center(multipliedBy: let mult) :
                make.centerY.equalToSuperview().multipliedBy(mult * 2)
            case .top(let equal):
                make.top.equalTo(convert(equal))
            case .bottom(let equal): do {
//                if self.superview?.next is UIViewController {
//                    if let eq = convert(equal) as? CGFloat {
//                        newBottom = eq - tabBarExtraHeght
//                        make.bottom.equalTo(newBottom)
//                    }
//                } else {
                make.bottom.equalTo(convert(equal))
//                    }
                }
            case .divide(let divided, let idx):
                make.centerY.equalToSuperview().multipliedBy((1/CGFloat(divided) * CGFloat(idx) + 1/CGFloat(divided * 2)) * 2)
                
                
            case .align(let v): do {
                switch v {
                case .top:
                    make.top.equalToSuperview()
                case .bottom:
                    make.bottom.equalToSuperview()
                case .center:
                    make.centerY.equalToSuperview()

                }
                
                }
            }
        case .sub_vertical(let v):
            switch v {
            case .top(let equal):
                make.top.equalTo(view.snp.bottom).offset(convert(equal) as! ConstraintOffsetTarget)
            case .bottom(let equal):
                make.bottom.equalTo(view.snp.top).offset(convert(equal)  as! ConstraintOffsetTarget)
            case .divide(let divided, let idx):
                make.centerY.equalToSuperview().multipliedBy((1/CGFloat(divided) * CGFloat(idx) + 1/CGFloat(divided * 2)) * 2)
            case .align(let type):
                switch type {case .top:
                    make.top.equalTo(view)
                case .bottom:
                    make.bottom.equalTo(view)
                case .center:
                    make.centerY.equalTo(view)
                }
            case .center(let multipliedBy):
                make.centerY.equalToSuperview().multipliedBy(multipliedBy * 2)
            }
        default : break
            }
        }
    
    //水平方向
    func  horizonConstraint(view:UIView, make:ConstraintMaker, horizon:TargetViewType){
        switch horizon {
            case .sup_horizon(let h):
                switch h {
                    case .left(let equal):
                        make.left.equalTo(convert(equal))
                    case .right(let equal):
                        make.right.equalTo(convert(equal))
                case .divide(let divided, let idx):
                    make.centerX.equalToSuperview().multipliedBy((1/CGFloat(divided) * CGFloat(idx) + 1/CGFloat(divided * 2)) * 2)
                case .align(let type):
                    switch type {case .left:
                        make.left.equalTo(view)
                    case .right:
                        make.right.equalTo(view)
                    case .center:
                        make.centerX.equalTo(view)
                    }
                case .center(let multipliedBy):
                    make.centerX.equalToSuperview().multipliedBy(multipliedBy * 2)
            }
            case .sub_horizon(let h):
                switch h {
                    case .left(let equal):
                        make.left.equalTo(view.snp.right).offset(convert(equal) as! ConstraintOffsetTarget)
                    case .right(let equal):
                        make.right.equalTo(view.snp.left).offset(convert(equal) as! ConstraintOffsetTarget)
                case .divide(let divided, let idx):
                    make.centerX.equalToSuperview().multipliedBy((1/CGFloat(divided) * CGFloat(idx) + 1/CGFloat(divided * 2)) * 2)
                    case .align(let type):
                    switch type {case .left:
                        make.left.equalTo(view)
                    case .right:
                        make.right.equalTo(view)
                    case .center:
                        make.centerX.equalTo(view)
                    }
                case .center(let multipliedBy):
                    make.centerX.equalTo(view).multipliedBy(multipliedBy * 2)
            }
                    default : break
        }
    }
}



//extension ConstraintRelatableTarget {
//    func V() -> ConstraintRelatableTarget {
//        if let flt = self as? CGFloat {
//        return flt * MAINHEIGHT / 1080
//    }
//        if let it = self as? Int {
//            return CGFloat(it) * MAINHEIGHT / 1080
//        }
//        return self
//    }
//    func H() -> ConstraintRelatableTarget {
//        if let flt = self as? CGFloat {
//            if isX {
//                return flt * MAINWIDTH / 2340
//            }
//            return flt * MAINWIDTH / 1920
//        }
//        if let it = self as? Int {
//            if isX {
//                return CGFloat(it) * MAINWIDTH / 2340
//            }
//            return CGFloat(it) * MAINWIDTH / 1920
//        }
//        return self
//    }
//}
