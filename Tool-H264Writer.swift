//
//  H264Writer.swift
//  Jellyfish
//
//  Created by halo vv on 2018/9/4.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import AVFoundation
import RxCocoa
import RxSwift
public class H264Writer: AVAssetWriter, H264WriteDelegate {
    public func write(sample: CMSampleBuffer) {
        print(self.status.rawValue)
//        if CMSampleBufferDataIsReady(sample) == false {
//            print("not ready")
//            return
//        }
//
//        
//        if self.status != .writing {
//            let startTime = CMSampleBufferGetPresentationTimeStamp(sample)
//            print(startTime)
//            self.startWriting()
//            self.startSession(atSourceTime: startTime)
//        }
//        
//        if self.status == .writing {
//            if (self.writerInput?.isReadyForMoreMediaData)! {
//                self.writerInput?.append(sample)
//                print("add sample")
//            }
//        }
        
    }
    
    public var writerInput: AVAssetWriterInput?
    
    public func addH264Input(w:Int, h: Int){
        let setting = [AVVideoCodecKey: AVVideoCodecH264, AVVideoWidthKey: w, AVVideoHeightKey: h] as [String : Any]
        self.writerInput = AVAssetWriterInput.init(mediaType: .video, outputSettings: setting)
        self.writerInput?.expectsMediaDataInRealTime = true
        if self.canAdd(self.writerInput!) {
            self.add(self.writerInput!)
        }
    }
}

//extension Reactive where Base: H264Writer {
//    var sps_pps_Binder: Binder<UnsafeRawPointer> {
//        return Binder(base) { writer, ptr in
//           let date = ptr.assumingMemoryBound(to: UPUAV_H264Data.self).pointee
//            memset(writer.sps_pps, 0, writer.sps_pps_len)
//
//            var ptr = UnsafeMutablePointer<u8>.allocate(capacity: 256)
//            writer.sps_pps.assign(repeating: 0x00, count: 3)
//            writer.sps_pps.assign(repeating: 0x01, count: 1)
//
//            memcpy(writer.sps_pps, date.sps, Int(date.sps_length))
//
//            writer.sps_pps.assign(repeating: 0x00, count: 3)
//            writer.sps_pps.assign(repeating: 0x01, count: 1)
//
//            memcpy(writer.sps_pps, date.pps, Int(date.pps_length))
//
//        }
//    }
//}
