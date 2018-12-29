//
//  Lf_progressView.swift
//  Jellyfish
//
//  Created by halo vv on 2018/12/14.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import UIKit

protocol ProgressAnimation {
    var interval: TimeInterval { get }
    var total: Double { get }
    func animation(progress: @escaping () -> CGFloat, until: @escaping  () -> Bool,completion: @escaping VoidHandler)
}

class Lf_progressView: UIView, ProgressAnimation {
    var total: Double = 1
    
    var interval: TimeInterval = 0.01
    
    func animation(progress: @escaping () -> CGFloat, until: @escaping () -> Bool, completion: @escaping VoidHandler) {
        TimeTool.act(startWith: 0, interval: interval, timeHandler: { (_) in
           self.progressValue = progress()
        }, waitStop: { (_) -> Bool in
            until() == true
        }) {
            completion()
        }
    }
    
    
    
    
    var shape: CAShapeLayer?
    
    var progressValue: CGFloat = 0 {
        willSet {
            self.setNeedsDisplay()
            
        }
    }
    var backColor: UIColor?
    var shapeColor: UIColor = .clear
    var progressColor = UIColor.clear
    
    
    override func draw(_ rect: CGRect) {
        
        let ww = bounds.width
        let hh = bounds.height
        
        let rds = min(ww/2, hh/2)
        let start: CGFloat = CGFloat(-Double.pi/2)
        let end = start + progressValue * CGFloat(Double.pi * 2) / CGFloat(total)
        let ctr = CGPoint.init(x: ww/2, y: hh/2)
       
        let path = UIBezierPath.init(arcCenter: ctr, radius: rds, startAngle: start, endAngle: end, clockwise: true)
            path.addLine(to: ctr)
            path.addLine(to: CGPoint.init(x: ww/2, y: 0))
        let ctx = UIGraphicsGetCurrentContext()
            ctx?.addPath(path.cgPath)

            ctx?.setFillColor(self.progressColor.cgColor)
            ctx?.fillPath()

    }
    
}
