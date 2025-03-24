//
//  AppDelegate.swift
//  Airplay2ndScreen
//
//  Created by Arveen kumar on 21/07/2023.
//

import UIKit
import AVFoundation
import FeedMedia


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var avPlayer = AVPlayer(url: URL(string: "https://s3.amazonaws.com/feedfm/gladiator.m4v")!)
    
    var mainController : MainViewController?
    var externalController : ExternalViewController?
    var isExternalActive : Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // initialize Feed Media music
        FMAudioPlayer.setClientToken("demo", secret:"demo")

        let player = FMAudioPlayer.shared()
        player.whenAvailable {
            // normally you would enable music playback buttons only after music
            // has been reported as available
            print("music is available for this client")

        }  notAvailable: {
            // normally your music playback buttons would continue to be disabled,
            // so the user doesn't try to play music, which is not available
            print("music is not available for this client")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

