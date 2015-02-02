//
//  ViewController.swift
//  VideoPlayer
//
//  Created by messel on 8/22/14.
//  Copyright (c) 2014 messel. All rights reserved.
//

import UIKit
import CoreMedia
import MediaPlayer

import AVKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet var urlField : UITextField!

    var videoAsset : AVURLAsset?

    var composition : AVMutableComposition?
    var compositionVideoTrack : AVMutableCompositionTrack?

    var playerItem : AVPlayerItem?
    var player : AVPlayer?
    var playerController : AVPlayerViewController?
    var rateSet = false
    
    
    @IBAction func tapGesture(sender: AnyObject) {
        urlField.resignFirstResponder()
        NSLog("tapGesture called " + urlField.text)
    }

    @IBAction func urlChanged(sender: AnyObject) {
        NSLog("urlChanged called " + urlField.text)
        playVideo()
    }

    @IBAction func playPushed(sender: AnyObject) {
        NSLog("playPushed called " + urlField.text)
        playVideo()
    }
    
//    var url = "http://api.cameo.tv/montage/xTsJQBVx.m3u8"
//    var url = "http://api.cameo.tv/file/9bafd29deafc16edbfdc8dfcbc0489d1895c7178"
    var path = NSBundle.mainBundle().pathForResource("victusSlowMo", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("trim", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("rendered30fps", ofType: "m4v")!
    
//    var url = "https://s3.amazonaws.com/messel.test.cameo.tv/victusSlowMo.mov"
//    var url = "https://s3.amazonaws.com/messel.test.cameo.tv/rendered30fps.m4v"
    
    func initValues() {
        urlField.text = path!;
    }
    

    func playVideo() {
        let videoURL = NSURL.fileURLWithPath(urlField.text)

        // work in progress
        /*
        self.composition = AVMutableComposition()
        self.compositionVideoTrack = self.composition?.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        var error : NSErrorPointer?
        var trimStart = CMTime(value: 75192227, timescale: 1000000000, flags: 3, epoch: 0)
        var duration = CMTime(value: 2772044114, timescale: 1000000000, flags: 3, epoch: 0)
        var timeRange = CMTimeRange(start: trimStart, duration: duration)
        var videoInsertResult = compositionVideoTrack?.insertTimeRange(timeRange: timeRange,
            ofTrack: videoAsset?.tracksWithMediaType(AVMediaTypeVideo),
            atTime: kCMTimeZero,
            error: error)
        */

        
        self.videoAsset = AVURLAsset(URL: videoURL, options: nil)
        self.playerItem = AVPlayerItem(asset: self.videoAsset)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.playerController = AVPlayerViewController()
        self.playerController!.player = player
//            self.addChildViewController(playerController)
//            self.view.addSubview(playerController.view!)
        self.playerController!.view.frame = self.view.frame
        self.presentViewController(self.playerController!, animated: true, completion: nil)
        self.player!.addPeriodicTimeObserverForInterval(
            CMTimeMake(1,30),
            queue: dispatch_get_main_queue(),
            usingBlock: {
                (callbackTime: CMTime) -> Void in
                let t1 = CMTimeGetSeconds(callbackTime)
                let t2 = CMTimeGetSeconds(self.player!.currentTime())
                if t2 > 0.075192227 && t2 < 2.772044114 && !(self.rateSet) {
                    self.rateSet = true
                    self.player!.setRate(0.125, time: kCMTimeInvalid, atHostTime: kCMTimeInvalid)
//                    self.player!.videoComposition
                    println("setting rate r1 \(self.player!.rate)")
                }
                else if t2 >= 2.772044114 && self.rateSet {
                    self.rateSet = false
                    self.player!.setRate(1, time: kCMTimeInvalid, atHostTime: kCMTimeInvalid)
                    println("setting rate r2 \(self.player!.rate)")
                }
                println("periodic observer called \(t1)) player time \(t2)")
        })
        NSLog("all done")

        self.player!.play()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

