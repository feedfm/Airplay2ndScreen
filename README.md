# Airplay2ndScreen
Example project for showing use of Airplay via Multiple screen support.

### Requirements
This demo is written in swift and works on iOS 13+. It makes use of Scene Delegate to detect and respond to screen connect and disconnect notifications. 

### Airplay vs Screen Mirroring
Why pick screen mirroring over Airplay? 
* The reason we consider this method to be superior is as a developer you get far more flexibility on what is shown to the user on the external screen. The demo included shows a basic interface on the TV or external screen but it can be modified to show just about anything while pure Airplay will sevearly limit you to just showing the video with default playback controls and nothing else. 
* In mirroring both the Audio streams are automatically moved the TV wihout any issues, while in case of Airplay only a single stream can played at any given time.

Using Scene Delegates
The default Xcode template for a new UIKit project provides both an AppDelegate and SceneDelegate. The default scene configuration in Info.plist sets the class of the scene delegate and the name of the storyboard used to load the main user interface:

Application Scene Manifest in Info.plist

<img width="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/97401917-b434-4ce1-842e-e8a91997f654">

```External Display Session Role (Legacy)``` was the originally unviled in iOS 13 however it was renamed to Legacy in iOS 16+ but continues to be supported as the Non interactive option is only really useful for iPad OS. 

Notes
* The presence of the “Application Scene Manifest” in Info.plist opts your app into supporting scenes. The scene delegate, not the app delegate, now owns the window.

* In the UIKit app template, “Enable Multiple Windows” defaults to NO. You should change this to YES if you want to support multiple windows on the iPad. It’s not required to support a window on an external screen. However you’re not forced to use storyboards with scene delegates. If you prefer to build your layout in code, remove the storyboard name key from Info.plist and create the window and root view controller in the scene(_:willConnectTo:options:) delegate method:
```
guard let scene = scene as? UIWindowScene else { return }
window = UIWindow(windowScene: scene)
window?.rootViewController = ExternalViewController()
window?.makeKeyAndVisible()
```
*It is strongly recommended make changes to the Info.plist using the Info tab of the target settings rather than in the Info.plist that appears in the project navigator sidebar (see Xcode 13 Missing Info.plist). I still see problems with the two locations not keeping in sync when changing settings (FB9397345) which can be confusing.


### Example app Notes

The demo uses a single AVplayer but changes which view controller displays the video based on the no of screens connected. If an external screen is detected the Main screen stops the playback and acts as remote to control the playback on the external screen.

No external screen attached

<img height="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/8253e839-5cc5-4d6e-838b-c02007c4d249">

Playback on external screen

<img height="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/e72fa4e2-17c7-45ff-8fab-bfe75136d0a9">

External TV Screen playback example 

![External](https://github.com/feedfm/Airplay2ndScreen/assets/9086361/a43651d8-4cdb-41ea-9762-35951815ea4c)

