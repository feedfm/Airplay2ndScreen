//
//
//  ViewController.swift
//  Airplay2ndScreen
//
//  Created by Arveen kumar on 21/07/2023.
//

import UIKit
import FeedMedia

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FMAudioPlayer.setClientToken("demo", secret:"demo")
        var player = FMAudioPlayer.shared()
        player.whenAvailable {
            
            
            player.play()
            
        } notAvailable: {
            
        }

    }


}

