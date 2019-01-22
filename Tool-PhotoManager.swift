//
//  PhotoManager.swift
//  Jellyfish
//
//  Created by halo vv on 2018/8/16.
//  Copyright © 2018年 liufeng. All rights reserved.
//

/*
 要避免
 PHPhotoLibrary.shared().performChanges
 嵌套
 */

import Foundation
import Photos
//import RxCocoa
//import RxSwift
import CoreGraphics
public let appName: String = Bundle.main.infoDictionary![String(kCFBundleNameKey)] as! String

public class PhotoManager: NSObject {
//    let bag = DisposeBag()
    static let shared = PhotoManager()
    
    
    /// 获取指定相册，不存在则先创建
    ///
    /// - Parameter title:
    /// - Returns: 
    public func Ablum(title: String) -> PHAssetCollection? {
        let options = PHFetchOptions()
//        options.predicate = NSPredicate.init(format: title, [:])
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var ablum: PHCollection?
        
        result.enumerateObjects { (collection, idx, _) in
            if collection.localizedTitle == title {
                ablum = collection
            }
        }
        if ablum != nil {
            return ablum as! PHAssetCollection
        }

        var newID = ""
            try? PHPhotoLibrary.shared().performChangesAndWait {
                newID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title).placeholderForCreatedAssetCollection.localIdentifier
            }

        var col: PHFetchResult<PHAssetCollection>?
        col = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [newID], options: nil)
        ablum = col?.firstObject
        return ablum as! PHAssetCollection
    }
    
    public func remove(assets: [PHAsset],completion:@escaping (Bool,Error?)->Void)  {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }) { (b, e) in
            completion(b,e)
        }
        
    }
    
    
//    func takePhotoAndSave() {
//        UPUAVClient.shared.framePtr?
//            .map {$0.assumingMemoryBound(to: UPUAV_FrameData.self).pointee}
//            .filter{$0.timestamp == 0}
//            .take(1)
//            .subscribe(onNext: {
//                let pointee = $0
//                DispatchQueue.main.async {
//                    let image = PhotoManager.shared.cgImage(rgbData: (pointee.frame_data)!, w: pointee.w, h: pointee.h)
//                    let uiImage = UIImage.init(cgImage: image, scale: 1, orientation: .up)
//                    PhotoManager.shared.saveImage(uiImage, toAlbum: appName)
//                }
//            }).disposed(by: self.bag)
//
//    }
    
    public func saveImage(_ image: UIImage, toAlbum: String ) {
        PhotoManager.checkAuthorize {
            let collection = self.Ablum(title: toAlbum)
            //        var assertRequest: PHAssetChangeRequest?
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                let  assertRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)   //图片请求
                let collectionRequest = PHAssetCollectionChangeRequest(for: collection!)         //相册请求
                //            [assertRequest.placeholderForCreatedAsset] as NSArray 转为 NSFastEnumeration
                collectionRequest?.addAssets([assertRequest.placeholderForCreatedAsset!] as NSArray)
            }
        }
        
                
        
    }
    
    public func addRequest(_ r: PHAssetChangeRequest, toAlbum: String) {
        do {
            try PHPhotoLibrary.shared().performChangesAndWait({
//                let assertRequest  = PHAssetChangeRequest.crea
                let collection = self.Ablum(title: toAlbum)
                let collectionRequest = PHAssetCollectionChangeRequest(for: collection!)
                let fastenum = [r.placeholderForCreatedAsset!] as NSArray
                collectionRequest?.addAssets(fastenum)
            })
        }
        catch _ {
            }
    }
    
    
    public func cgImage(rgbData: UnsafeRawPointer,w: Int32, h: Int32) -> CGImage {
        let callback: CGDataProviderReleaseDataCallback = {_,_,_ in}

        let provider = CGDataProvider.init(dataInfo: nil, data: rgbData, size: Int(3 * w * h), releaseData: callback)        
        let bitPerComponent = 8
        let bitPerPixel = 24
        let bytesPerRow = 3 * w
        
        let bitMapInfo = CGBitmapInfo.byteOrderMask
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let renderingIntent = CGColorRenderingIntent.defaultIntent
        let cgImageRef = CGImage.init(width: Int(w), height: Int(h), bitsPerComponent: bitPerComponent, bitsPerPixel: bitPerPixel, bytesPerRow: Int(bytesPerRow), space: colorSpaceRef, bitmapInfo: bitMapInfo, provider: provider!, decode: nil, shouldInterpolate: false, intent: renderingIntent)
        
        return cgImageRef!
    }
    
    
    /// 相册里项目默认按创建时长升序排列
    ///
    /// - Parameters:
    ///   - s:
    ///   - ascending:
    /// - Returns:
    public func asserts(_ s: String, ascending: Bool = false) -> PHFetchResult<PHAsset> {
        let collection = PhotoManager.shared.Ablum(title: s)
        let option = PHFetchOptions()
            option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: ascending)]
        let assetsResult = PHAsset.fetchAssets(in: collection!, options: option)
        return assetsResult
    }
    
    public func assetArray(_ s: String, ascending: Bool = false) -> [PHAsset] {
        var arr = [PHAsset]()
        self.asserts(s, ascending: ascending).enumerateObjects { (asset, _, _) in
            arr.append(asset)
        }
        return arr
    }
    
//缩略图
    
    public func findThumbnails(ablum: String) -> [UIImage] {
        var arr = [UIImage]()
        let result = self.asserts(ablum)
        result.enumerateObjects { (asset, idx, _) in
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize.zero, contentMode: .aspectFit, options: nil, resultHandler: { (img, _) in
                arr.append(img!)
            })
        }

        return arr
    }
    
    public func  handle(ablum: String,imgHandler: @escaping ImageHandler,  videoHandler: @escaping VideoHandler)  {
        let result = self.asserts(ablum)
        
        result.enumerateObjects { (asset, _, _) in
            switch asset.mediaType {
            case .image:
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: nil, resultHandler: { (img, _) in
                    imgHandler(img!)
//                    print(asset)
                })
            case .video:
                PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil, resultHandler: { (item, _) in
                    if let urlAsset = item?.asset as? AVURLAsset? {
                        videoHandler((urlAsset?.url)!)
                    }
                })

            default:
                break
            }
        }
    }
    
    
    /// 保存视频
    ///
    /// - Parameter path: 沙盒路径
    public func saveVideo(path: String) {
        PhotoManager.checkAuthorize {
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path){
                let ablum = self.Ablum(title: appName)
                PHPhotoLibrary.shared().performChanges({
                    let url = URL.init(fileURLWithPath: path)
                    let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                    let placeholder = assetRequest?.placeholderForCreatedAsset
                    let collcectRequest  = PHAssetCollectionChangeRequest.init(for: ablum!)
                    collcectRequest?.addAssets([placeholder] as NSArray)
                    
                }) { (ok, err) in
                    if ok == false {
                        print("相册添加视频失败：\(err?.localizedDescription)")
                    }
                }
            }
        }
        
    }
    
    public @objc func save( video: String ) {
//        let urlAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: video))
        try? PHPhotoLibrary.shared().performChangesAndWait {
            let assertRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL.init(fileURLWithPath: video))  //图片请求
            let collection = self.Ablum(title: appName)                                        //相册
            let collectionRequest = PHAssetCollectionChangeRequest(for: collection!)         //相册请求
            //            [assertRequest.placeholderForCreatedAsset] as NSArray 转为 NSFastEnumeration
            collectionRequest?.addAssets([assertRequest?.placeholderForCreatedAsset!] as NSArray)
        }
    }
    
    
    public static func image(fromSampleBuffer: CMSampleBuffer) -> UIImage?{
        //pixelBuffer
        guard let imageBuffer = CMSampleBufferGetImageBuffer(fromSampleBuffer) else {return nil}
        //lockAddress
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        let address = CVPixelBufferGetBaseAddress(imageBuffer)
        
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let w  = CVPixelBufferGetWidth(imageBuffer)
        let h = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //bitInfo是关键，这两项设置我也不知道啥意思
        let bitInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))
        if let context = CGContext(data: address,
                                   width: w, height: h, bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                   space: colorSpace, bitmapInfo: bitInfo) {
            guard let cgimage = context.makeImage() else { return nil }
            
            let image = UIImage.init(cgImage: cgimage, scale: 1, orientation: .right)
            return image
        }
        return nil
        
    }
    
    //获取授权
    public static func checkAuthorize(authorizedHandler:@escaping VoidHandler) {
    //保证UI在主线程
    if PHPhotoLibrary.authorizationStatus() == .authorized {
        DispatchQueue.main.async {
            authorizedHandler()}
    } else {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                DispatchQueue.main.async {
                    authorizedHandler()}
            } else {
                DispatchQueue.main.async {
                    UIWindow.remind("相册权限不足")
                }
            }
          }
         }
        }
    
}

public extension PHAssetCollection {

    public func asset(ID: String) -> PHAsset? {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [ID], options: nil)
        return result.firstObject
    }
}
