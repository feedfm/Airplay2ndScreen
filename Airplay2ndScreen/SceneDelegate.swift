//
//  SceneDelegate.swift
//  Airplay2ndScreen
//
//  Created by Arveen kumar on 21/07/2023.
//

import UIKit
import AVFoundation
import AVKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // Needed in order to reference storyboard
    var window: UIWindow?

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if(windowScene.session.role == .windowExternalDisplay){
            appDelegate.isExternalActive = false
            
            appDelegate.externalController?.disableVideoPlayback()
            appDelegate.mainController?.enableVideoPlayback()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;

        guard let windowScene = scene as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        let controller = window.rootViewController

        if( windowScene.session.role == .windowApplication){
            // initialize the main window (on the iOS device)

            // save ref to MainViewController instance for later
            if controller is MainViewController {
                appDelegate.mainController = (controller as! MainViewController)
            }

            if(appDelegate.isExternalActive == false){
                appDelegate.mainController?.enableVideoPlayback()
            } else {
                appDelegate.mainController?.disableVideoPlayback()
            }
        }
        
        if(windowScene.session.role == .windowExternalDisplay){
            // initialize the external (AirPlay) window

            if controller is ExternalViewController {
                // save ref to ExternalViewController for later
                appDelegate.externalController = (controller as! ExternalViewController)

                appDelegate.isExternalActive = true
                                
                appDelegate.mainController?.disableVideoPlayback()

                appDelegate.externalController?.enableVideoPlayback()
            }
           
        }
    }


}

