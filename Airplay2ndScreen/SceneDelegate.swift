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

 
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
       
            
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if(windowScene.session.role == .windowExternalDisplay){
            appDelegate.isExternalActive = false
            
            appDelegate.externalController?.stripVideo()
            appDelegate.mainController?.startPlayback()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if( windowScene.session.role == .windowApplication){
            print("MainBecameActive")
            print(appDelegate.isExternalActive)
            let window = windowScene.windows.first
            let controller = window!.rootViewController
            if controller is MainViewController {
                appDelegate.mainController = (controller as! MainViewController)
            }
            if(appDelegate.isExternalActive == false){ 
                appDelegate.mainController?.startPlayback()
            } else {
                appDelegate.mainController?.stripVideo()
            }
        }
        
        if(windowScene.session.role == .windowExternalDisplay){
            print("ExternalBecameActive")
            print(appDelegate.isExternalActive)
            appDelegate.isExternalActive = true
            let window = windowScene.windows.first
            let controller = window!.rootViewController
            
            if controller is ExternalViewController {
                appDelegate.externalController = (controller as! ExternalViewController)
                appDelegate.externalController?.startPlayback()
                appDelegate.mainController?.stripVideo()
            }
           
        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
       
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

