//
//
//  ViewController.swift
//  Airplay2ndScreen
//
//  Created by Arveen kumar on 21/07/2023.
//

import UIKit
import FeedMedia
import AVKit



class ExternalViewController: UIViewController {

    
    @IBOutlet weak var slider: UIProgressView!
    @IBOutlet weak var elapsed: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var musicControls: UIView!
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playView: UIView!
    
    var playerLayer :AVPlayerLayer?
    var isPresenting: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerTimeObserver : Any? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        playerLayer?.frame = self.playView.bounds
    }


    func startPlayback() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if(appDelegate.avPlayer == nil) {
            appDelegate.avPlayer = AVPlayer(url: URL(string: "https://s3.amazonaws.com/feedfm/gladiator.m4v")!)
        }
        // if presenting on another screen dismiss it
        
        if(!isPresenting) {
            intitalizePlayers()
        }
       
    }
    
    
    func intitalizePlayers()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        FMAudioPlayer.setClientToken("demo", secret:"demo")
        let player = FMAudioPlayer.shared()
        player.whenAvailable { [self] in
            
            isPresenting = true
            playerLayer = AVPlayerLayer.init(player: appDelegate.avPlayer)
             
            playerLayer?.frame = self.playView.bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.playView.layer.addSublayer(playerLayer!)
            self.playView.layer.addSublayer(self.musicControls.layer)
            appDelegate.avPlayer?.play()
            // begin playback of video
            if(player.playbackState != .playing) {
                player.play()
            }
            
            let interval = CMTimeMake(value: 5, timescale: 10) // every half second

            playerTimeObserver = appDelegate.avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                let seconds = Float(CMTimeGetSeconds(time))
                self.updateElapsedAndRemainingLabels(for: seconds)
            }
        } notAvailable: {
            
        }
    }
    
    
    func updateElapsedAndRemainingLabels(for time: Float) {
        
        let _playerItem = appDelegate.avPlayer?.currentItem
        guard let playerItem = _playerItem else {
            return
        }

        let duration = Float(CMTimeGetSeconds(playerItem.duration))
        let fractionalProgress = time / duration
        
        slider.progress = fractionalProgress
       
        
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60

        elapsed.text = String(format: "%ld:%02ld", minutes, seconds)

        let remainingSeconds = Int(duration - time) % 60
        let remainingMinutes = Int(duration - time) / 60

        remaining.text = String(format: "%ld:%02ld", remainingMinutes, remainingSeconds)
    }
    
    
    func stripVideo(){
        
        isPresenting = false
        playerLayer?.removeFromSuperlayer();
        playerLayer = nil
        
    }
}

