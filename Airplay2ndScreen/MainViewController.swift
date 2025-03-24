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

let DEFAULT_TIME_STRING = "-:--"

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
    @IBOutlet weak var instructionLabel: UILabel!
    
    var playerLayer :AVPlayerLayer?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // by default, hide the "Playing On External Screen" message
        activityLabel.isHidden = true
        
        // add scaled 'mirror' icon to explanatory text
        let image = UIImage(named: "ScreenMirror")

        let lineHeight = instructionLabel.font.lineHeight
        let imageAspect = image!.size.width / image!.size.height
        let targetHeight = lineHeight
        let targetWidth = targetHeight * imageAspect

        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: targetWidth, height: targetHeight)).image { _ in
            image!.draw(in: CGRect(origin: .zero, size: CGSize(width: targetWidth, height: targetHeight)))
        }
        
        let mirrorImageAttachment = NSTextAttachment()
        mirrorImageAttachment.image = resizedImage
        
        let instructionText = NSMutableAttributedString(string: "To start airplay pull down the notifiation bar and select the ")
        instructionText.append(NSAttributedString(attachment: mirrorImageAttachment))
        instructionText.append(NSAttributedString(string: " mirror icon"))
        instructionLabel.attributedText = instructionText
        
        // update elapsed time as we play the video
        let interval = CMTimeMake(value: 5, timescale: 10) // every half second
        appDelegate.avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let seconds = Float(CMTimeGetSeconds(time))
            self.updateElapsedAndRemainingLabels(for: seconds)
        }
    }
    
    
    func enableVideoPlayback() {
        if(playerLayer == nil) {
            // hide "Playing On External Screen" label
            activityLabel.isHidden = true
            
            // create video player
            playerLayer = AVPlayerLayer.init(player: appDelegate.avPlayer)
            playerLayer?.frame = playView.bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playView.layer.addSublayer(playerLayer!)
            playView.layer.addSublayer(musicControls.layer)
        }
    }
    
    func disableVideoPlayback(){
        // remove video player
        playerLayer?.removeFromSuperlayer();
        playerLayer = nil
        
        // dispay instructive text
        activityLabel.text = "Playing On External Screen"
        activityLabel.isHidden = false
        
    }

    @IBAction func workoutPlayPauseButtonWasTouched(_ sender: Any) {
        if workoutPlayPauseButton.isSelected {
            // Pause video and audio playback
            appDelegate.avPlayer.pause()
            FMAudioPlayer.shared().pause()
            
            workoutPlayPauseButton.isSelected = false
            
        } else {
            // Start or resume video and audio playback
            appDelegate.avPlayer.play()
            FMAudioPlayer.shared().play()
            
            workoutPlayPauseButton.isSelected = true
        }
    }
    
    
    func updateElapsedAndRemainingLabels(for time: Float) {
        
        let _playerItem = appDelegate.avPlayer.currentItem
        
        guard let playerItem = _playerItem else {
            elapsed.text = DEFAULT_TIME_STRING
            remaining.text = DEFAULT_TIME_STRING
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
    
}

