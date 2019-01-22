//
//  TimeTool.swift
//  Jellyfish
//
//  Created by halo vv on 2018/9/5.
//  Copyright © 2018年 liufeng. All rights reserved.
//

typealias IntHandler = (Int)->Void
typealias DoubleHandler = (Double)->Void

import Foundation

public class TimeTool {
    public static func act(prepare: VoidHandler,times: Int, interval: TimeInterval = 1, timeHandler: @escaping DoubleHandler, completion: @escaping VoidHandler){
        prepare()
        var count = times
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: DispatchTime.now(), repeating: 1)
        timer.setEventHandler {
            if count == 0 {
                timer.cancel()
            }else {
                timeHandler(Double(count))
            count -= 1
            }
        }
        timer.resume()
        
        
        timer.setCancelHandler {
            completion()
        }
    }
    public static func repeatForever(interval: TimeInterval = 1, _ h: @escaping VoidHandler) {
        self.act(startWith: 0, interval: interval, timeHandler: { (_) in
            h()
        }, waitStop: { _  -> Bool in
            false
        }) {
            
        }
    }
    
    public static func act(startWith: Double, interval: TimeInterval = 1, timeHandler: @escaping DoubleHandler, waitStop:@escaping (Double)->Bool,completion: @escaping VoidHandler){
        
        var start = startWith
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timer.schedule(deadline: DispatchTime.now(), repeating: interval)
        timer.setEventHandler {
            if waitStop(start) == true {
                timer.cancel()
            }else {
                timeHandler(start)
                start += interval
            }
        }
        timer.setCancelHandler {
            completion()
        }
        
        timer.resume()
    }
    
    public static func secondToHMS(sec: Int) -> [String] {
        let hours = sec / 3600
        let minsLeft = sec % 3600
        let mins = minsLeft / 60
        let secs = minsLeft % 60
//        print(hours,minsLeft,mins,secs)
        let arr = [hours,mins,secs].map({ (it) -> String in
            var str:String
            if it < 10 {
                str = "0\(String(it))"
            } else {
                str = String(it)
            }
            return str
        })
        return arr
    }
    
}
