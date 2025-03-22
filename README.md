# Airplay2ndScreen

## Motivation

When developing an application with video using Apple's AVPlayer, the application
largely gets AirPlay support for free, because AVPlayer allows the user to select an AirPlay
device and AVPlayer automatically transfers video and audio playback to that device.
Unfortunately, if your application is also playing music using the Feed Media SDK (which uses
a different AVPlayer), that audio does not also get streamed to the AirPlay device, and the 
user experience is degraded.

A user can use the 'mirror screen' option on the iOS device so that video and Feed Media
music are both sent to the remote AirPlay device, but what is displayed on the AirPlay device
doesn't take full advantage of the screen, and the interface does not appear polished.

This sample app shows how you can take advantage of iOS's ability to detect and treat
an AirPlay device as an 'external display' so that you can display your video, full
screen, on the AirPlay device while iOS also streams Feed Media music through it.


## Sample App

This sample app makes use of iOS's ability to treat an AirPlay device as an external
display. When a user visits the control center, selects 'mirror screen' and selects an AirPlay
device, the application has the option to provide a custom window to be rendered on the AirPlay
device instead of a simple mirror of the iOS display.

When this app is run with no AirPlay connection, the interface looks like the following:

<img height="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/8253e839-5cc5-4d6e-838b-c02007c4d249">

When the user turns on AirPlay mirroring from the control center, video and audio (including Feed Media music) are
transferred to the AirPlay device. The iOS display updates to look like the following:

<img height="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/e72fa4e2-17c7-45ff-8fab-bfe75136d0a9">

and the external AirPlay device updates to display this:

![External](https://github.com/feedfm/Airplay2ndScreen/assets/9086361/a43651d8-4cdb-41ea-9762-35951815ea4c)


## Official and external documentation

The sample app makes use of iOS APIs that became available in iOS 13 to 
support external (or 'connected') displays. Apple's documentation for this is 
[here](https://developer.apple.com/documentation/uikit/presenting-content-on-a-connected-display).

[Geoff Hackworth](https://hacknicity.medium.com/) has a great blog post that describes
the [evolution of external display support over time](https://hacknicity.medium.com/external-display-support-versus-stage-manager-on-ipados-16-149e15dc700e
). His post is
ultimately concerned with the issues surrounding how Stage Manager conflicts with the pre-iOS 16
support for external displays, but he walks through some of the configuration needed
for an app to support external displays, and he has a very simple demo app.


## Notes on the Sample App

This demo is written in swift and works on iOS 13+. It makes use of Scene Delegate to detect and respond to screen connect and disconnect notifications. The app creates a single `AVPlayer` that exists for the duration of the app, and it creates and destroys different `AVPlayerLayers` to render the video on the iOS device or the AirPlay device. The Feed Media SDK is initialized on startup, and music playback transitions from iOS to AirPlay automatically.

 The presence of the “Application Scene Manifest” and the "Enable Multiple Windows" option in Info.plist opts this app in to supporting scenes.
 
Application Scene Manifest in Info.plist

<img width="824" alt="Screenshot 2023-08-07 at 17 14 26" src="https://github.com/feedfm/Airplay2ndScreen/assets/9086361/97401917-b434-4ce1-842e-e8a91997f654">

