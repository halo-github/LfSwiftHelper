//
//  H264Decoder.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/23.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import VideoToolbox


protocol H264DisplayDelegate {
    func sampleDisplay(sample: CMSampleBuffer)
    func cvimageDisplay(cvImage: CVImageBuffer)
}

protocol H264WriteDelegate {
    func write(sample: CMSampleBuffer)
}


class H264Decoder {
    static let shared = H264Decoder()
    var description: CMVideoFormatDescription?
    var session: VTDecompressionSession?
    var spsLen = 0
    var ppsLen = 0
    var sps = UnsafeMutableRawPointer.allocate(byteCount: 40, alignment: 0)
//        UnsafeMutablePointer<UInt8>.allocate(capacity: 40),
    var pps = UnsafeMutableRawPointer.allocate(byteCount: 40, alignment: 0)
    var cvImgBuffer: CVImageBuffer?
    var sample: CMSampleBuffer?
    var block: CMBlockBuffer?
    
    var displayDelegate: H264DisplayDelegate?
    var writeDelegate: H264WriteDelegate?
    
     let decompressionSessionDecodeFrameCallback: VTDecompressionOutputCallback = { decompressRef, sourceFrameref, status, flags, cvBuffer, timeStamp, duration in
//        print(status,flags,cvBuffer,timeStamp,duration)
        if (status != noErr) || cvBuffer == nil {
            print("Error decompressing frame at \(Float(timeStamp.value) / Float(timeStamp.timescale)) status: \(status) flags: \(flags)")
            return
        }
        if (status == kVTInvalidSessionErr) {
            print("iOS8VT:invalid session, reset decoder session")
        } else if (status == kVTVideoDecoderBadDataErr) {
            print("iOS8VT:decode failed status = \(status) (Bad data)")
        } else if status != noErr {
            print("iOS8VT:decode failed status = \(status)")
        }
        
        
//        let decoder = decompressRef?.assumingMemoryBound(to: H264Decoder.self).pointee
        if H264Decoder.shared.session !=  nil {
        H264Decoder.shared.displayDelegate?.cvimageDisplay(cvImage: cvBuffer!)
        }
    }
    
    func updata(sps: UnsafeMutablePointer<UInt8>, spsLen: Int, pps: UnsafeMutablePointer<UInt8>, ppsLen: Int) -> OSStatus{
        let spsSet = UnsafePointer<UInt8>.init(sps)
        let ppsSet = UnsafePointer<UInt8>.init(pps)
        let paraSets = [spsSet, ppsSet]
        let status = CMVideoFormatDescriptionCreateFromH264ParameterSets(allocator: kCFAllocatorDefault, parameterSetCount: 2, parameterSetPointers: paraSets, parameterSetSizes: [spsLen, ppsLen], nalUnitHeaderLength: 4, formatDescriptionOut: &description)
        return status
    }
    
    
    func creatSession() {
        var status: OSStatus?
        if self.session != nil {
            VTDecompressionSessionInvalidate(self.session!)
        }
        
        
        let sps1 = self.sps.assumingMemoryBound(to: UInt8.self)
        let pps1 = self.pps.assumingMemoryBound(to: UInt8.self)
        status = self.updata(sps: sps1, spsLen: self.spsLen, pps: pps1, ppsLen: self.ppsLen)
        if status != noErr {
            return
        }
        free(self.sps)
        free(self.pps)
        
        var callbackRecord = VTDecompressionOutputCallbackRecord.init()
        callbackRecord.decompressionOutputCallback = decompressionSessionDecodeFrameCallback
        callbackRecord.decompressionOutputRefCon = Unmanaged.passUnretained(self).toOpaque()
        
        let destinationAttrs = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange  ]
//        kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32RGBA kCVPixelFormatType_420YpCbCr8Planar
//        let status = VTDecompressionSessionCreate(nil, description!, nil, destinationAttrs as CFDictionary, &callbackRecord, &session)
        
         status = VTDecompressionSessionCreate(allocator: kCFAllocatorDefault, formatDescription: description!, decoderSpecification: nil,
                                               imageBufferAttributes: destinationAttrs as CFDictionary,
                                    outputCallback: &callbackRecord, decompressionSessionOut: &session)
        

        if status != noErr {
            self.creatSession()
        }
    }
    
    
    func classify(frame: UnsafeRawPointer,size: Int){
        var data: UnsafeMutableRawPointer?

        if size < 4 {
            return
        }
        let naluType = frame.u8(at: 4) & 0x1f
        data = malloc(size)
        memcpy(data, frame, size)
        let len:UInt32  = UInt32(size - 4)
        var lenArr = NSSwapHostIntToBig(len)
        memcpy(data, &lenArr, 4)
        switch naluType {
        case 5:
//            print("I frame")
            self.creatSession()
              decode(dataFrame: data!, len: size)
            
            
        case 7:
//            print("sps")
            sps = malloc(size)
            spsLen = size - 4
            memset(sps, 0, size)
            memcpy(sps, frame.advanced(by: 4), spsLen)
        case 8:
//            print("pps")
            pps = malloc(size)
            ppsLen = size - 4
            memset(pps, 0, ppsLen)
            memcpy(pps, frame.advanced(by: 4), ppsLen)
        default:
//            print("B/P frame")
            decode(dataFrame: data!, len: size)
        }
        


        free(data)


        
    }
    

    
    func decode(dataFrame: UnsafeMutableRawPointer, len: Int){
        var status: OSStatus?
        
        block = nil
        status = CMBlockBufferCreateWithMemoryBlock(allocator: nil,
                                                    memoryBlock: dataFrame,
                                                    blockLength: len,
                                                    blockAllocator: kCFAllocatorNull,
                                                    customBlockSource: nil,
                                                    offsetToData: 0,
                                                    dataLength: len,
                                                    flags: 0,
                                                    blockBufferOut: &block)
        if status != noErr {
            print("CMBlockBufferCreateWithMemoryBlock error: \(status.debugDescription)")
            return
        }
        
        let sampleSizeArr = [len]
        status = CMSampleBufferCreateReady(allocator: kCFAllocatorDefault, dataBuffer: block, formatDescription: description, sampleCount: 1, sampleTimingEntryCount: 0, sampleTimingArray: nil, sampleSizeEntryCount: 1, sampleSizeArray: sampleSizeArr, sampleBufferOut: &sample)
//        status = CMSampleBufferCreate(kCFAllocatorDefault, block, true, nil, nil, description, 1, 0, nil, 0, sampleSizeArr, &sample)
        if status != noErr {
            print("CMSampleBufferCreate error: \(status.debugDescription)")
            return
        }
        
        self.writeDelegate?.write(sample: sample!)
        
        if self.session != nil {
            let frameFlags: VTDecodeFrameFlags = VTDecodeFrameFlags(rawValue: 0)
            var outFlags = [VTDecodeInfoFlags.init(rawValue: 0)]
            
            VTDecompressionSessionDecodeFrame(session!, sampleBuffer: sample!, flags: frameFlags, frameRefcon: &cvImgBuffer, infoFlagsOut: &outFlags)

        }
        


    }
    
    
//    func configSampleBuffer(sample: CMSampleBuffer, type: u8) -> CMSampleBuffer? {
//        if session == nil || description == nil{
//            return nil
//        }
//        var sampleBuffer = sample
//        let attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true)
//        let dict = CFArrayGetValueAtIndex(attachments, 0)
//        let cfStrPointer = unsafeBitCast(kCMSampleAttachmentKey_DisplayImmediately, to: UnsafeRawPointer.self)
//        let cfTurePointer = unsafeBitCast(kCFBooleanTrue, to: UnsafeRawPointer.self)
//        let cfFalsePointer = unsafeBitCast(kCFBooleanFalse, to: UnsafeRawPointer.self)
//        
//        CFDictionarySetValue(dict as! CFMutableDictionary, cfStrPointer, cfTurePointer)
//        CFDictionarySetValue(dict as! CFMutableDictionary, unsafeBitCast(kCMSampleAttachmentKey_IsDependedOnByOthers, to: UnsafePointer.self), cfTurePointer)
//        
//        if type == 1 {
//            CFDictionarySetValue(dict as! CFMutableDictionary, unsafeBitCast(kCMSampleAttachmentKey_NotSync, to: UnsafePointer.self), cfTurePointer)
//            CFDictionarySetValue(dict as! CFMutableDictionary, unsafeBitCast(kCMSampleAttachmentKey_DependsOnOthers, to: UnsafePointer.self), cfTurePointer);
//        } else {
//            CFDictionarySetValue(dict as! CFMutableDictionary, unsafeBitCast(kCMSampleAttachmentKey_NotSync, to: UnsafePointer.self), cfFalsePointer)
//            CFDictionarySetValue(dict as! CFMutableDictionary, unsafeBitCast(kCMSampleAttachmentKey_DependsOnOthers, to: UnsafePointer.self), cfFalsePointer)
//        }
//        
//        return sampleBuffer
//    }
    
    
    func int(ofFrame: UnsafeRawPointer, index: Int) -> u8 {
        return ofFrame.advanced(by: index).load(as: u8.self)
    }


    

}

extension UnsafeRawPointer {
    func u8(at: Int) -> CUnsignedChar {
       return self.advanced(by: at).load(as: CUnsignedChar.self)
    }
}
