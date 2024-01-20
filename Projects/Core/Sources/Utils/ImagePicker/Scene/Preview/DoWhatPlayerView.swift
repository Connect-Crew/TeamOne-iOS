//
//  PlayerLockView.swift
//  SamplePick
//
//  Created by CHKim on 27/03/2020.
//  Copyright © 2020 NOMAD SOFT. All rights reserved.
//

import UIKit
import AVKit;
import AVFoundation;

struct PlayerCallback{
    
    var onComplete:(()->())?
    var onDuration:((Int)->())?
    var onProgress:((Int)->())?
}

class DoWhatPlayerView: UIView {
    
    var mCallback:PlayerCallback?
    var timeObserver:Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    
    func initView(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func setCallback(callback:PlayerCallback){
        
        self.mCallback = callback
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        if mCallback != nil{
            mCallback!.onComplete?()
        }
    }
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
    
    
    var url:String?
    
    func  initUrl(_ url:String){
        self.url = url
//
//        if !self.url!.starts(with: "http"){
//            self.url = DfsApi.sharedInstance.getDfsUrl("/download/\(MyInfo.sharedInstance.companySeq)/\(MyInfo.sharedInstance.hotelInfo?.hotelSeq ?? 0)/") + self.url!
//        }
//
        //        NSUtils.Log.printLog(self.url!)
        player = AVPlayer(url: URL(string: self.url!)!)
        
        player!.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        player!.isMuted = true
//        player!.play()
    }
    
    
    func initUrlPlayer(_ url:String){
        self.url = url
//        
//        if !self.url!.starts(with: "http"){
//            self.url = DfsApi.sharedInstance.getDfsUrl("/download/\(MyInfo.sharedInstance.companySeq)/\(MyInfo.sharedInstance.hotelInfo?.hotelSeq ?? 0)/") + self.url!
//        }
//        
        //        NSUtils.Log.printLog(self.url!)
        player = AVPlayer(url: URL(string: self.url!)!)
        
        player!.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        player!.isMuted = true
    }
    
    func playVideo(){
        if let pl = self.player{
            pl.seek(to: CMTime.zero)
            pl.play()
        }
        
    }
    
    func stopVideo(){
        
        if let pl = self.player{
            pl.seek(to: CMTime.zero)
            pl.pause()
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if player!.rate > 0 {
                
                let duration : CMTime = player!.currentItem!.asset.duration
                let seconds : Float64 = CMTimeGetSeconds(duration)
                
                //                NSUtils.Log.printLog("[video started] : \(seconds)")
                
                if let callback = mCallback{
                    
                    callback.onDuration!(Int(seconds))
                    
                }
                
                let interval = CMTime(seconds: 1, preferredTimescale: 1)
                timeObserver = player!.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
                    
                    let playerDuration = self.playerItemDuration()
                    if CMTIME_IS_INVALID(playerDuration) {
                        
                        if let callback = self.mCallback{
                            
                            callback.onProgress!(0)
                            
                        }
                        
                        return
                    }
                    
                    
                    
                    let duration = Float(CMTimeGetSeconds(playerDuration))
                    if duration.isFinite && duration > 0 {
                        
                        
                        if let callback = self.mCallback{
                            
                            let time = Int(CMTimeGetSeconds(elapsedTime))
                            
                            callback.onProgress!(time)
                            
                        }
                    }
                })
                
            }
        }
    }
    private func playerItemDuration() -> CMTime {
        let thePlayerItem = player!.currentItem
        if thePlayerItem?.status == .readyToPlay {
            return thePlayerItem!.duration
        }
        return CMTime.invalid
    }
    
    public func removeOb() {
        if player != nil && timeObserver != nil{
            player!.removeTimeObserver(timeObserver!)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
        }
    }
    
    
}
