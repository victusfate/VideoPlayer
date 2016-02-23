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


private var myContext = 0

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
    var timer = NSTimer()
    
    
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
    var path = "http://d2ohigj5624u4a.cloudfront.net/streams/0ba0f916-8f3e-4a2a-8fae-cf95405aa65b/0ba0f916-8f3e-4a2a-8fae-cf95405aa65b.m3u8"

//    var path = "https://livestream.peer5.com/video/kite/index.m3u8"
//    var path = NSBundle.mainBundle().pathForResource("victusSlowMo", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("trim", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("rendered30fps", ofType: "m4v")!
    
    
    func initValues() {
        urlField.text = path;
    }
    

    func playVideo() {
        let videoURL = NSURL(string: urlField.text!)
        
        self.playerItem = AVPlayerItem(URL: videoURL!)
        self.player = AVPlayer(playerItem: self.playerItem!)
        self.player!.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        self.playerController = AVPlayerViewController()
        
        self.playerController!.player = self.player
        self.playerController!.view.frame = self.view.frame
        self.presentViewController(self.playerController!, animated: true, completion: nil)
        self.player!.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "itemDidFinishPlaying:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: self.playerItem)

        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "itemStatus", userInfo: nil, repeats: true)

        self.player!.addObserver(self, forKeyPath: "rate", options: .New, context: &myContext)
        self.player!.addObserver(self, forKeyPath: "status", options: .New, context: &myContext)
        self.player!.addObserver(self, forKeyPath: AVPlayerItemDidPlayToEndTimeNotification, options: .New, context: &myContext)
    }
    
    func itemStatus() {
        var endTime : Double = 0
        if let aPlayerItem = self.playerItem {
            endTime = CMTimeGetSeconds(aPlayerItem.forwardPlaybackEndTime)
        }
        print("buffer empty \(self.playerItem?.playbackBufferEmpty) end time \(endTime) rate \(self.player?.rate) playerError \(self.player?.error)")
    }
    
    func itemDidFinishPlaying(notification: NSNotification) {
        print("Reached End")
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
            else if keyPath == AVPlayerItemDidPlayToEndTimeNotification {
                print("kvo did play to end")
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


}

