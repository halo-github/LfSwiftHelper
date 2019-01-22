//
//  File.swift
//  Jellyfish
//
//  Created by halo vv on 2018/9/6.
//  Copyright © 2018年 liufeng. All rights reserved.
//

import Foundation
import AudioToolbox
import AVKit
import RxCocoa
//import

public class MediaTool {
    public static func playAudio(sound: SystemSound){
        AudioServicesPlaySystemSound(SystemSoundID(sound.rawValue))
    }
}

public enum SystemSound: SystemSoundID {
    case takePhoto = 1108   //拍照
    case vibrate =  0x00000FFF //  震动  kSystemSoundID_Vibrate 
}


/*
 1108 拍照  photoShutter
 
 
 */


public class lf_VideoView: UIView {
   public override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(playEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func mp4(frame: CGRect, url: URL) -> lf_VideoView {
        let view = lf_VideoView.init(frame: frame)
            view.videoUrl = url
        return view
    }
    public var player: AVPlayer?
    public let avLayer = AVPlayerLayer()
    public var videoUrl: URL = URL.init(string: "abc")! {
        willSet {
            player =  AVPlayer.init(url: newValue)
                avLayer.frame = self.bounds
                avLayer.player = player
//            avLayer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(avLayer)
            player?.play()
            
        }
    }
    
    var repeatTimes: Int = 1
    var times: Int = 0
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
   public @objc func playEnded() {
        times = times + 1
        if times != repeatTimes {
            player?.seek(to: CMTime.init(value: 0, timescale: 1))
            player?.play()
            
        }
    }
}
