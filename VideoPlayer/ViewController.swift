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

    private var myContext = 0

    var playerItem : AVPlayerItem?
    var player : AVPlayer?
    var playerController : AVPlayerViewController?
    var rateSet = false
    var timer : NSTimer? = NSTimer()
    
    
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
    
//    var path = "http://d2ohigj5624u4a.cloudfront.net/streams/testStream/testStream.m3u8"
    var path = "http://d2ohigj5624u4a.cloudfront.net/streams/4adadeb8-cb3e-4714-b736-b754565363c7/4adadeb8-cb3e-4714-b736-b754565363c7.m3u8"

//    var path = "https://livestream.peer5.com/video/kite/index.m3u8"
//    var path = NSBundle.mainBundle().pathForResource("victusSlowMo", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("trim", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("rendered30fps", ofType: "m4v")!
    
    
    func initValues() {
        urlField.text = path;
    }
    
    func removeObserver() {
        if let aPlayer = self.player {
            aPlayer.removeObserver(self,forKeyPath:"rate")
            aPlayer.removeObserver(self,forKeyPath:"status")
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }
    
    func addObserver() {
        if let aPlayerItem = self.playerItem {
            print("adding observer")
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "itemDidFinishPlaying:",
                name: AVPlayerItemDidPlayToEndTimeNotification,
                object: aPlayerItem)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "itemDidFailedPlayingToEnd:",
                name: AVPlayerItemFailedToPlayToEndTimeNotification,
                object: aPlayerItem)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "itemDidStall:",
                name: AVPlayerItemPlaybackStalledNotification,
                object: aPlayerItem)
        }
        
        if let aPlayer = self.player {
            aPlayer.addObserver(self, forKeyPath: "rate", options: .New, context: &myContext)
            aPlayer.addObserver(self, forKeyPath: "status", options: .New, context: &myContext)
        }
        
    }

    func playVideo() {
        
        self.removeObserver()
    
        let videoURL = NSURL(string: urlField.text!)
        
        self.playerItem = AVPlayerItem(URL: videoURL!)
        self.player = AVPlayer(playerItem: self.playerItem!)
        self.player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        self.addObserver()
        
        self.playerController = AVPlayerViewController()
        
        self.playerController!.player = self.player
        self.playerController!.view.frame = self.view.frame
        self.presentViewController(self.playerController!, animated: true, completion: nil)
        self.player!.play()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "itemStatus", userInfo: nil, repeats: true)

    }
    
    func itemStatus() {
        var endTime : Double = 0
        var likelyToKeepUp: Bool?
        var bufferFull: Bool?
        var bufferEmpty: Bool?
        if let aPlayerItem = self.playerItem {
            endTime = CMTimeGetSeconds(aPlayerItem.forwardPlaybackEndTime)
            likelyToKeepUp = aPlayerItem.playbackLikelyToKeepUp
            bufferFull = aPlayerItem.playbackBufferFull
            bufferEmpty = aPlayerItem.playbackBufferEmpty
        }
        print("buffer empty \(self.playerItem?.playbackBufferEmpty) end time \(endTime) rate \(self.player?.rate) playerError \(self.player?.error) likely to keep up \(likelyToKeepUp) pb buffer full \(bufferFull) pb buffer empty \(bufferEmpty)")
    }
    
    func itemDidFailedPlayingToEnd(notification: NSNotification) {
        print("AVPlayer failed playing to the end stream")
    }
    
    func itemDidStall(notification: NSNotification) {
        print("AVPlayer got stalled stream url")
    }
    
    func itemDidFinishPlaying(notification: NSNotification) {
        print("AVPlayer finished playing stream url")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeNewKey] where keyPath == "status" {
                print("kvo status \(newValue)")
            }
            else if let newValue = change?[NSKeyValueChangeNewKey] where keyPath == "rate" {
                let rate: Float = CFloat(newValue as! NSNumber)
                print("kvo rate \(rate)")
//                if rate == 0.0 // Playback stopped
//                else if rate == 1.0 // Normal playback
//                else if rate == -1.0 { // Reverse playback
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    deinit {
        self.removeObserver()
    }


}

