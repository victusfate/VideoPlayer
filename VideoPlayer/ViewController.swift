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
    var compositionAudioTrack : AVMutableCompositionTrack?

    var playerItem : AVPlayerItem?
    var player : AVPlayer?
    var playerController : AVPlayerViewController?
    var rateSet = false
    
    
    @IBAction func tapGesture(sender: AnyObject) {
        urlField.resignFirstResponder()
        NSLog("tapGesture called " + urlField.text!)
    }

    @IBAction func urlChanged(sender: AnyObject) {
        NSLog("urlChanged called " + urlField.text!)
        playVideo()
    }

    @IBAction func playPushed(sender: AnyObject) {
        NSLog("playPushed called " + urlField.text!)
        playVideo()
    }
    
//    var path = "https://d2ohigj5624u4a.cloudfront.net/bitcodin/m3u8s/stream.m3u8"
    var path = "http://192.168.40.74:5000/hls?url=http://s3.amazonaws.com/media.sp0n.com/bitcodin/m3u8s/stream.m3u8"
//    var path = "https://sp0n-stream-api.herokuapp.com/hls?url=https://s3.amazonaws.com/media.sp0n.com/bitcodin/m3u8s/stream.m3u8"
//    var path = "https://bitcodin_test.storage.googleapis.com/livestream20151279460/m3u8s/stream.m3u8"
//    var path = "https://s3.amazonaws.com/media.sp0n.com/bitcodin/hls/3000k/abc.m3u8"
    // var path = NSBundle.mainBundle().pathForResource("victusSlowMo", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("trim", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("rendered30fps", ofType: "m4v")!
    
    
    func initValues() {
        urlField.text = path;
    }
    

    func playVideo() {
        let videoURL = NSURL.fileURLWithPath(urlField.text!)

        self.videoAsset = AVURLAsset(URL: videoURL, options: nil)
        self.playerItem = AVPlayerItem(asset: self.videoAsset!)
        self.playerItem?.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmVarispeed
        self.player = AVPlayer(playerItem: self.playerItem!)
    
        self.playerController = AVPlayerViewController()
        self.playerController!.player = player
        self.playerController!.view.frame = self.view.frame
        self.presentViewController(self.playerController!, animated: true, completion: nil)
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

