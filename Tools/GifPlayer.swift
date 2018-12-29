//
//  GifPlayer.swift

//
import UIKit
import Foundation
import SnapKit
class GifPlayer: UIImageView {
//    static let shared = GifPlayer.init(frame: .zero)
    var images: [UIImage] = [UIImage]()
    var index = 0
    var totalDuration : TimeInterval = 0
    var gifName = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func add(gif:String, onView:UIView) {
        onView.addSubview(self)
        self.frame = onView.bounds
        self.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
//        self.contentMode = .scaleAspectFit
        self.creat(gif: gif)
    }
    
    func creat(gif:String) {
        images.removeAll()
        totalDuration = 0
        gifName = gif
        
        guard let path = Bundle.main.path(forResource: gif, ofType: "gif"),
            let data = NSData(contentsOfFile: path),
            let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        for i in 0..<CGImageSourceGetCount(imageSource) {
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            //            print(image.size)
            i == 0 ? self.image = image : ()
            images.append(image)
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary,
                let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary,
                let frameDuration = gifDict[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
    }
    
    
    
    func playGif(repeats:Int) {
        self.animationImages = images
        self.animationDuration = totalDuration
        self.animationRepeatCount = repeats
        self.startAnimating()
    }
    func stop() {
//        self.animationImages = []
        self.layer.removeAllAnimations()
        self.stopAnimating()
        self.removeFromSuperview()
    }
    
    func stopAtLast() {
        
        self.image = self.animationImages?.last
        self.layer.removeAllAnimations()
        self.stopAnimating()
    }
    
    func image(indexOf: Int) -> UIImage {
        return images[indexOf]
    }
    
    func save(indexOf: Int) {
        let img = self.image(indexOf: indexOf)
        let data = img.jpegData(compressionQuality: 1)
        let path = "\(docPath!)/\(gifName)_\(indexOf).png"
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        
    }
    
    static func newGif()-> GifPlayer{
        let gif = GifPlayer.init(frame: .zero)
        return gif
    }
     func play(name: String, times: Int,  onView: UIView) {
//        let gif = GifPlayer.init(frame: .zero)
            self.add(gif: name, onView: onView)
            self.playGif(repeats: times)
            self.contentMode = .scaleAspectFit
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.totalDuration * Double(times)) {
//            gif.stopAtLast()
            UIView.animate(withDuration: self.totalDuration/3 > 1 ? self.totalDuration/3 : 1, animations: {
                self.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
