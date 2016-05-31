# CareKitSampleApp

🚨WORK IN PROGRESS🚨

A sample app using Apple's CareKit framework, backed by CloudMine storage.

## Getting Started

This demo application requires [CocoaPods](http://cocoapods.org) version 1.0.0 or greater for dependency management. If you don't already have CocoaPods, install the gem:

```
sudo gem install cocoapods
```

You can then proceed to clone the app, install dependencies, and build it in Xcode:

```
git clone https://github.com/cloudmine/CareKitSampleApp.git
cd CareKitSampleApp
cp CareKitSampleApp/SupportingFiles/BCMSecrets.h-Template CareKitSampleApp/SupportingFiles/BCMSecrets.h
pod install
open BackTrack.xcworkspace
```

**You will need to edit `BCMSecrets.h` in your project to include a CloudMine App Identifier and App Secret (also referred to as API Key).**
