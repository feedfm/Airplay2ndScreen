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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playerLayer?.frame = playView.bounds
    }

    func enableVideoPlayback() {
        if(playerLayer == nil) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            playerLayer = AVPlayerLayer.init(player: appDelegate.avPlayer)
            playerLayer?.frame = playView.bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            playView.layer.addSublayer(playerLayer!)
            playView.layer.addSublayer(musicControls.layer)
            
            let interval = CMTimeMake(value: 5, timescale: 10) // every half second
            
            appDelegate.avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                let seconds = Float(CMTimeGetSeconds(time))
                self.updateElapsedAndRemainingLabels(for: seconds)
            }
        }
    }
    
    func disableVideoPlayback(){
        playerLayer?.removeFromSuperlayer();
        playerLayer = nil
    }
    
    func updateElapsedAndRemainingLabels(for time: Float) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let _playerItem = appDelegate.avPlayer.currentItem
        guard let playerItem = _playerItem else {
            return
        }

        let duration = CMTIME_IS_VALID(playerItem.duration) && !CMTIME_IS_INDEFINITE(playerItem.duration) ? Float(CMTimeGetSeconds(playerItem.duration)) : 0.0

        if (duration > 0.0) {
            let fractionalProgress = time / duration
            slider.progress = fractionalProgress
        } else {
            slider.progress = 1
        }
       
        let seconds = Int(time) % 60
        let minutes = Int(time) / 60

        elapsed.text = String(format: "%ld:%02ld", minutes, seconds)

        let remainingSeconds = Int(duration - time) % 60
        let remainingMinutes = Int(duration - time) / 60

        remaining.text = String(format: "%ld:%02ld", remainingMinutes, remainingSeconds)
    }
    
}

