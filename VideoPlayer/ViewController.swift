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
//    var moviePlayer : MPMoviePlayerViewController?
//    var player : AVPlayer?
//    var playerController : AVPlayerViewController?
    
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
//    var path = NSBundle.mainBundle().pathForResource("victusSlowMo", ofType: "mov")
    var path = NSBundle.mainBundle().pathForResource("trim", ofType: "mov")
//    var path = NSBundle.mainBundle().pathForResource("rendered30fps", ofType: "m4v")!
    
//    var url = "https://s3.amazonaws.com/messel.test.cameo.tv/victusSlowMo.mov"
//    var url = "https://s3.amazonaws.com/messel.test.cameo.tv/rendered30fps.m4v"
    
    func initValues() {
        urlField.text = path!;
    }
    

    func playVideo() {
//        let videoURL = NSURL(string: urlField.text)
        let videoURL = NSURL.fileURLWithPath(urlField.text)

//        moviePlayer = MPMoviePlayerViewController(contentURL: videoURL )
//        NSLog("about to play video " + urlField.text)
//        if let player = moviePlayer {
//            NSLog("setting stuff")
//            player.view.frame = self.view.bounds
//            self.presentViewController(moviePlayer!, animated: true, completion: nil)
//            NSLog("all done")
//        }

        if let player = AVPlayer(URL: videoURL) {
            let playerController = AVPlayerViewController()
            playerController.player = player
//            self.addChildViewController(playerController)
//            self.view.addSubview(playerController.view!)
            playerController.view.frame = self.view.frame
            self.presentViewController(playerController, animated: true, completion: nil)
            NSLog("all done")
        
            player.play()
            
        }
        else {
            NSLog("no player")
        }
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

