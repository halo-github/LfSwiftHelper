//
//  Lf_shareTool.swift
//  Jellyfish
//
//  Created by halo vv on 2018/12/5.
//  Copyright © 2018年 liufeng. All rights reserved.
//


/*
 
 "com.apple.share.SinaWeibo.post",
 "com.apple.share.TencentWeibo.post"
 "com.taobao.taobao4iphone.ShareExtension"
 "com.tencent.qqmail.shareextension}",
 "com.apple.mobilenotes.SharingExtension"
 "com.apple.share.Vimeo.post"
 "com.apple.mobileslideshow.StreamShareService}",
 "com.tencent.mqq.ShareExtension"
 "com.tencent.xin.sharetimeline"
 "com.apple.share.Twitter.post"
 "com.apple.share.Flickr.post"
 "com.alipay.iphoneclient.ExtensionSchemeShare"
 "com.apple.Music.MediaSocialShareService",
 "com.apple.share.Facebook.post"
 "com.apple.reminders.RemindersEditorExtension"
 "com.up.2.ShareExtension"
 "com.jianshu.Hugo.Share-Extension"
 "com.apple.Health.HealthShareExtension"


 "com.alipay.iphoneclient.ExtensionSchemeShare" = "<NSExtension: 0x170167140> {id = com.alipay.iphoneclient.ExtensionSchemeShare}";
 "com.apple.Health.HealthShareExtension" = "<NSExtension: 0x1701660c0> {id = com.apple.Health.HealthShareExtension}";
 "com.apple.Music.MediaSocialShareService" = "<NSExtension: 0x170167380> {id = com.apple.Music.MediaSocialShareService}";
 "com.apple.mobilenotes.SharingExtension" = "<NSExtension: 0x1701666c0> {id = com.apple.mobilenotes.SharingExtension}";
 "com.apple.mobileslideshow.StreamShareService" = "<NSExtension: 0x1701669c0> {id = com.apple.mobileslideshow.StreamShareService}";
 "com.apple.reminders.RemindersEditorExtension" = "<NSExtension: 0x170167680> {id = com.apple.reminders.RemindersEditorExtension}";
 "com.apple.share.Facebook.post" = "<NSExtension: 0x170167500> {id = com.apple.share.Facebook.post}";
 "com.apple.share.Flickr.post" = "<NSExtension: 0x170166fc0> {id = com.apple.share.Flickr.post}";
 "com.apple.share.SinaWeibo.post" = "<NSExtension: 0x170167b00> {id = com.apple.share.SinaWeibo.post}";
 "com.apple.share.TencentWeibo.post" = "<NSExtension: 0x170166240> {id = com.apple.share.TencentWeibo.post}";
 "com.apple.share.Twitter.post" = "<NSExtension: 0x170166e40> {id = com.apple.share.Twitter.post}";
 "com.apple.share.Vimeo.post" = "<NSExtension: 0x170166b40> {id = com.apple.share.Vimeo.post}";
 "com.jianshu.Hugo.Share-Extension" = "<NSExtension: 0x170167980> {id = com.jianshu.Hugo.Share-Extension}";
 "com.taobao.taobao4iphone.ShareExtension" = "<NSExtension: 0x1701663c0> {id = com.taobao.taobao4iphone.ShareExtension}";
 "com.tencent.mqq.ShareExtension" = "<NSExtension: 0x170166840> {id = com.tencent.mqq.ShareExtension}";
 "com.tencent.qqmail.shareextension" = "<NSExtension: 0x170166540> {id = com.tencent.qqmail.shareextension}";
 "com.tencent.xin.sharetimeline" = "<NSExtension: 0x170166cc0> {id = com.tencent.xin.sharetimeline}";
 "com.up.2.ShareExtension" = "<NSExtension: 0x170167800> {id = com.up.2.ShareExtension}";
 }
 
 作者：upworld
 链接：https://www.jianshu.com/p/ce123a2015f9
 來源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
*/
import Social
import Foundation
enum Lf_sharePlatform: String {
    case wx = "com.tencent.xin.sharetimeline"
    case sina = "com.apple.share.SinaWeibo.post"
    case qq = "com.tencent.mqq.ShareExtension"
}



class Lf_ShareTool {
    static func shareVC(type: Lf_sharePlatform) -> SLComposeViewController {
        return  SLComposeViewController.init(forServiceType: type.rawValue)
    }
    
    static func appleShare(items: [Any],completion: @escaping UIActivityViewController.CompletionWithItemsHandler){
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.message,UIActivity.ActivityType.mail,UIActivity.ActivityType.print,UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.saveToCameraRoll]
            activityVC.completionWithItemsHandler = completion
            
            UIWindow.topViewController()?.present(activityVC, animated: true)
        }
        
    }
}
