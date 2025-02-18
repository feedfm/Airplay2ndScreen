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

class MainViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var workoutPlayPauseButton: UIButton!
    @IBOutlet weak var volumeMuteButton: UIButton!
    @IBOutlet weak var musicControls: UIView!
    @IBOutlet weak var elapsed: UILabel!
    @IBOutlet weak var remaining: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var activityLabel: UILabel!
    
    
    var playerLayer :AVPlayerLayer?
    var isPresenting: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var playerTimeObserver : Any? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityLabel.isHidden = true
    }
  
    func startPlayback() {
        
         
        if(appDelegate.avPlayer == nil) {
            appDelegate.avPlayer = AVPlayer(url: URL(string: "https://s3.amazonaws.com/feedfm/gladiator.m4v")!)
        }
        // if presenting on another screen dismiss it
        if(!isPresenting) {
            intitalizePlayers()
        }
       
    }
    
    
    @IBAction func workoutPlayPauseButtonWasTouched(_ sender: Any) {
        if workoutPlayPauseButton.isSelected {
            // User wants to pause
            appDelegate.avPlayer?.pause()
            FMAudioPlayer.shared().pause()
            workoutPlayPauseButton.isSelected = false
        } else {
            // User wants to play
            appDelegate.avPlayer?.play()
            FMAudioPlayer.shared().play()
           
            
            workoutPlayPauseButton.isSelected = true
        }
    }
    
    
    func updateElapsedAndRemainingLabels(for time: Float) {
        
        let _playerItem = appDelegate.avPlayer?.currentItem
        guard let playerItem = _playerItem else {
            return
        }

        let duration = CMTIME_IS_VALID(playerItem.duration) && !CMTIME_IS_INDEFINITE(playerItem.duration) ? Float(CMTimeGetSeconds(playerItem.duration)) : 0.0

        if(duration > 0){
            slider.maximumValue = duration
            slider.value = time
            slider.isEnabled = true;
            slider.isContinuous = true;
        }
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60

        elapsed.text = String(format: "%ld:%02ld", minutes, seconds)

        let remainingSeconds = Int(duration - time) % 60
        let remainingMinutes = Int(duration - time) / 60

        remaining.text = String(format: "%ld:%02ld", remainingMinutes, remainingSeconds)
    }
    
    
    func intitalizePlayers(){
        
        activityLabel.isHidden = true
        FMAudioPlayer.setClientToken("demo", secret:"demo")
        let player = FMAudioPlayer.shared()
        player.whenAvailable { [self] in
            
            
            isPresenting = true
            playerLayer = AVPlayerLayer.init(player: appDelegate.avPlayer)
             
            playerLayer?.frame = self.playView.bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.playView.layer.addSublayer(playerLayer!)
            self.playView.layer.addSublayer(self.musicControls.layer)
            workoutPlayPauseButton.isSelected = true
            appDelegate.avPlayer?.play()
            // begin playback of video
            if(player.playbackState != .playing) {
                player.play()	
            }
           
            setObserver()
        } notAvailable: {
            
        }
    }
    
    fileprivate func setObserver() {
        if(playerTimeObserver == nil) {
            let interval = CMTimeMake(value: 5, timescale: 10) // every half second
            playerTimeObserver = appDelegate.avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                let seconds = Float(CMTimeGetSeconds(time))
                self.updateElapsedAndRemainingLabels(for: seconds)
            }
        }
    }
    
    func stripVideo(){
        
        
        isPresenting = false
        playerLayer?.removeFromSuperlayer();
        playerLayer = nil
        activityLabel.text = "Playing On External Screen"
        activityLabel.isHidden = false
        
        setObserver()
    }
}

