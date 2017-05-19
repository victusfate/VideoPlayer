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

    fileprivate var myContext = 0

    var playerItem : AVPlayerItem?
    var player : AVPlayer?
    var playerController : AVPlayerViewController?
    var rateSet = false
    var timer : Timer? = Timer()
    
    
    @IBAction func tapGesture(_ sender: AnyObject) {
        urlField.resignFirstResponder()
        NSLog("tapGesture called " + urlField.text!)
    }

    @IBAction func urlChanged(_ sender: AnyObject) {
        NSLog("urlChanged called " + urlField.text!)
        playVideo()
    }

    @IBAction func playPushed(_ sender: AnyObject) {
        NSLog("playPushed called " + urlField.text!)
        playVideo()
    }
    
//    var path = "http://d2ohigj5624u4a.cloudfront.net/streams/testStream/testStream.m3u8"
    var path = "https://d2ohigj5624u4a.cloudfront.net/streams/278ec4f5-fb1a-4afb-8f9a-7997007b21c5/vod_278ec4f5-fb1a-4afb-8f9a-7997007b21c5.m3u8"

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
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func addObserver() {
        if let aPlayerItem = self.playerItem {
            print("adding observer")
            NotificationCenter.default.addObserver(self,
                selector: #selector(ViewController.itemDidFinishPlaying(_:)),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: aPlayerItem)
            
            NotificationCenter.default.addObserver(self,
                selector: #selector(ViewController.itemDidFailedPlayingToEnd(_:)),
                name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
                object: aPlayerItem)
            
            NotificationCenter.default.addObserver(self,
                selector: #selector(ViewController.itemDidStall(_:)),
                name: NSNotification.Name.AVPlayerItemPlaybackStalled,
                object: aPlayerItem)
        }
        
        if let aPlayer = self.player {
            aPlayer.addObserver(self, forKeyPath: "rate", options: .new, context: &myContext)
            aPlayer.addObserver(self, forKeyPath: "status", options: .new, context: &myContext)
        }
        
    }

    func playVideo() {
        
        self.removeObserver()
    
        let videoURL = URL(string: urlField.text!)
        
        self.playerItem = AVPlayerItem(url: videoURL!)
        self.player = AVPlayer(playerItem: self.playerItem!)
        self.player!.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        self.addObserver()
        
        self.playerController = AVPlayerViewController()
        
        self.playerController!.player = self.player
        self.playerController!.view.frame = self.view.frame
        self.present(self.playerController!, animated: true, completion: nil)
        self.player!.play()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.itemStatus), userInfo: nil, repeats: true)

    }
    
    func itemStatus() {
        var endTime : Double = 0
        var likelyToKeepUp: Bool?
        var bufferFull: Bool?
        var bufferEmpty: Bool?
        if let aPlayerItem = self.playerItem {
            endTime = CMTimeGetSeconds(aPlayerItem.forwardPlaybackEndTime)
            likelyToKeepUp = aPlayerItem.isPlaybackLikelyToKeepUp
            bufferFull = aPlayerItem.isPlaybackBufferFull
            bufferEmpty = aPlayerItem.isPlaybackBufferEmpty
        }
        print("buffer empty \(self.playerItem?.isPlaybackBufferEmpty) end time \(endTime) rate \(self.player?.rate) playerError \(self.player?.error) likely to keep up \(likelyToKeepUp) pb buffer full \(bufferFull) pb buffer empty \(bufferEmpty)")
    }
    
    func itemDidFailedPlayingToEnd(_ notification: Notification) {
        print("AVPlayer failed playing to the end stream")
    }
    
    func itemDidStall(_ notification: Notification) {
        print("AVPlayer got stalled stream url")
    }
    
    func itemDidFinishPlaying(_ notification: Notification) {
        print("AVPlayer finished playing stream url")
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "status" {
                print("kvo status \(newValue)")
            }
            else if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "rate" {
                let rate: Float = CFloat(newValue as! NSNumber)
                print("kvo rate \(rate)")
//                if rate == 0.0 // Playback stopped
//                else if rate == 1.0 // Normal playback
//                else if rate == -1.0 { // Reverse playback
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

