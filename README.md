# Panframe iOS SDK Wrapper
This wrappers makes Panframe iOS SDK play nice with Swift and brings familiar Objctive-C patterns to the SDK. It also uses modern `NS_ASSUME_NONNULL_BEGIN`, `NS_ASSUME_NONNULL_END`, `__nullable`, `NS_DESIGNATED_INITIALIZER` macros to make the wrapper Swift-er.

**NOTE:** You still need to signup and download the Panframe iOS SDK from their [website](http://www.panframe.com/get-it) to use this wrapper. This is _NOT_ a re-write of their SDK.

## Installation
You have two options to include the `PanframeSDKWrapper` in your project:

### [CocoaPods](http://cocoapods.org/)

#### Podfile

```ruby
pod "PanframeSDKWrapper", "~> 1.0"
```

### Manual Installation
Drag the following classes from the *Source* folder directly into your project:

  * `PanframeSDKWrapper.h`
  * `PanframeSDKWrapper.m`

## Classes

#### Swift Friendly Enums

    enum PanframeAssetMessage: Int {
        case Loaded, Playing, Paused, Stopped, Complete, Downloading, Downloaded, DownloadCancelled, Error, Seeking           
    }

    enum PanframeNavigationMode: Int {
        case Motion, Touch
    }

    enum PanframeViewMode: Int {
        case Flat, Sphere
    }

    enum PanframeBlindSpotLocation: Int {
        case None, Top, Bottom
    }

`PanframeView` replaces `PFView`

#### Objc
```objc
// Before: PFView init
PFView *pfView = [PFObjectFactory viewWithFrame:[self.view bounds]];

// After: PanframeView init
PanframeView *pfView = [[PanframeView alloc] initWithFrame:[self.view bounds]];
```

#### Swift
```swift
// Before: PFView init
let pfView = PFObjectFactory.viewWithFrame(view.bounds)

// After: PanframeView init
let pfView = PanframeView(frame: view.bounds)
```

`PanframeAsset` replaces `PFAsset`

#### Objc
```objc
// Before: PFAsset init
PFAsset *asset = (id<PFAsset>)[PFObjectFactory assetFromUrl:url observer:(PFAssetObserver*)self];

// After: PanframeAsset init
PanframeAsset *asset = [[PanframeAsset alloc] initWithUrl:url observer:self];
```

#### Swift
```swift
// Before: PFAsset init
Not available in Swift. uh oh.

// After: PanframeAsset init
let asset = PanframeAsset(url, observer: self)
```

`PanframeAssetObserver` replaces both `PFAssetObserver` and `PFAssetTimeMonitor` protocols.

```objc
@interface PanoViewController : UIViewController <PanframeAssetObserver>
@end

@implementation PanoViewController
- (void)panframeAsset:(PanframeAsset * __nonnull)asset onPlayerTime:(CMTime)time
{
}

- (void)panframeAsset:(PanframeAsset * __nonnull)asset onStatusMessage:(PanframeAssetMessage)message
{
}
@end
```

```swift
class PanoViewController: UIViewController, PanframeAssetObserver {

    func panframeAsset(asset: PanframeAsset, onPlayerTime time: CMTime) {
    }

    func panframeAsset(asset: PanframeAsset, onStatusMessage message: PanframeAssetMessage) {
    }

}
```


## Author

- [Zeeshan Mian](https://github.com/zmian) ([@zmian](https://twitter.com/zmian))

## License

PanframeSDKWrapper is released under the MIT license. See LICENSE for details. Panframe trademark and technology is the property of their respective owners.
