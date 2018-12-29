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

class MediaTool {
    static func playAudio(sound: SystemSound){
        AudioServicesPlaySystemSound(SystemSoundID(sound.rawValue))
    }
}

enum SystemSound: SystemSoundID {
    case takePhoto = 1108   //拍照
    case vibrate =  0x00000FFF //  震动  kSystemSoundID_Vibrate 
}


/*
 1108 拍照  photoShutter
 
 
 */


class lf_VideoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var player: AVPlayer?
    let avLayer = AVPlayerLayer()
    var videoUrl: URL = URL.init(string: "abc")! {
        willSet {
//            let url = URL.init(fileURLWithPath: newValue)
            player =  AVPlayer.init(url: newValue)
                avLayer.frame = self.bounds
                avLayer.player = player
//            avLayer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(avLayer)
            player?.play()
            
        }
    }
    
}
