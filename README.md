# BackTrack

A demo application that showcases the CloudMine [CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS) interface for Apple [CareKit](http://carekit.org/).

## CMHealth iOS SDK and CareKit

CareKit is an Apple framework geared toward the applications of patient care.  By itself, CareKit is a powerful tool for building apps which let patients regularly track care plans and monitor their progress.  However, CareKit provides no mechanisms for storing the data it generates anywhere except the patient's own device.  This is where CloudMine and the [CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS) step in.

The [CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS) uses the [CloudMine](http://cloudmineinc.com/) [Connected Health Cloud](cloudmineinc.com/platform/developer-tools/) to manage the user and data needs of CareKit applications.  Through the [CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS), your application can create patient accounts in the cloud, store consent documents and survey data associated with that patient, and even send the patient an email if they forget their password.  Application developers can further leverage patient data using either the [CloudMine iOS SDK](https://cloudmine.io/docs/#/ios) within the application itself, or create a patient portal using the [CloudMine JavaScript SDK](https://cloudmine.io/docs/#/javascript).  In all cases, the data is stored on the [CloudMine Connected Health Cloud]([CMHealth iOS SDK](https://github.com/cloudmine/CMHealthSDK-iOS)), a HIPAA HITECH compliant cloud data platform for healthcare.

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

The project should now open and build.

## Your CloudMine Application

Edit the `CareKitSampleApp/SupportingFiles/BCMSecrets.h` file and add your CloudMine [App ID](https://cloudmine.io/docs/#/getting_started#welcome-to-cloudmine) and [API Key](https://cloudmine.io/docs/#/data_security), as well as the shared snippet name used for persisting shared CareKit objects. For help with this one time configuration process, please see the [CMHealth documentation](https://github.com/cloudmine/CMHealthSDK-iOS#configuration).

Need an account [CloudMine](https://cloudmineinc.com) account?  Email our [sales@cloudmineinc.com](mailto:sales@cloudmineinc.com). Trouble getting set up? Email [support@cloudmineinc.com](mailto:support@cloudmineinc.com).
