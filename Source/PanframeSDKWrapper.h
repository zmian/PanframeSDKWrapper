//
// PanframeSDKWrapper.h
//
// Copyright (c) 2015 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <Panframe/Panframe.h>

typedef NS_ENUM(NSInteger, PanframeAssetMessage) {
    PanframeAssetMessageLoaded            = 1,
    PanframeAssetMessagePlaying           = 2,
    PanframeAssetMessagePaused            = 3,
    PanframeAssetMessageStopped           = 4,
    PanframeAssetMessageComplete          = 5,
    PanframeAssetMessageDownloading       = 6, // Deprecated
    PanframeAssetMessageDownloaded        = 7, // Deprecated
    PanframeAssetMessageDownloadCancelled = 8, // Deprecated
    PanframeAssetMessageError             = 9,
    PanframeAssetMessageSeeking           = 10
};

typedef NS_ENUM(NSInteger, PanframeNavigationMode) {
    PanframeNavigationModeMotion = 0,
    PanframeNavigationModeTouch  = 1
};

typedef NS_ENUM(NSInteger, PanframeViewMode) {
    PanframeViewModeSpherical    = 0,
    PanframeViewModeFlat         = 1,
    PanframeViewModeCylindrical  = 2,
    PanframeViewModeVRSideBySide = 3,
    PanframeViewModeVRTopDown    = 4
};

typedef NS_ENUM(NSInteger, PanframeBlindSpotLocation) {
    PanframeBlindSpotLocationNone   = 0,
    PanframeBlindSpotLocationTop    = 1,
    PanframeBlindSpotLocationBottom = 2
};

NS_ASSUME_NONNULL_BEGIN

#pragma mark - PanframeAssetObserver

@class PanframeAsset;
/** An object which implements the PanframeAssetObserver protocol for monitoring asset status.*/
@protocol PanframeAssetObserver
- (void)panframeAsset:(PanframeAsset *)asset onPlayerTime:(CMTime)time;
- (void)panframeAsset:(PanframeAsset *)asset onStatusMessage:(PanframeAssetMessage)message;
@end

#pragma mark - PanframeAsset

@interface PanframeAsset : NSObject <PFAsset>
- (instancetype)initWithUrl:(NSURL *)url observer:(id<PanframeAssetObserver>)observer NS_DESIGNATED_INITIALIZER;
@property (nonatomic, readwrite) id<PFAsset> asset;
@property (nonatomic, readonly) NSURL *assetUrl;
@property (nonatomic, readonly) PanframeAssetMessage status;
@property (nonatomic, readonly) CMTime duration;
@property (nonatomic, readonly) CMTime currentTime;
@property (nonatomic, readonly) CMTimeRange timeRange;
@property (nonatomic, readonly) float downloadProgress;
@end

#pragma mark - PanframeView

@interface PanframeView : UIView
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (void)setAsset:(PanframeAsset * __nullable)asset;
- (void)injectImage:(UIImage * __nullable)image;
- (void)run;
- (void)halt;
- (void)clear;
- (void)resetView;
- (void)setBlindSpotImage:(NSString *)resourceImageName;
- (void)setBlindSpotLocation:(PanframeBlindSpotLocation)location;
- (void)setFieldOfView:(float)fov;
- (void)setViewMode:(PanframeViewMode)mode andAspectRatio:(float)aspectRatio;
- (id<PFHotspot>)createHotspot:(UIImage *)image;
- (void)removeHotspot:(id<PFHotspot>)hotspot;
- (void)setAutoLevel:(BOOL)autoLevel afterSeconds:(float)seconds;
- (void)setStereo:(BOOL)stereo;
- (void)toggleNavigationMode;
- (void)toggleViewMode;
/**
 *  Default value is 2.0/1.0
 */
@property (nonatomic, readwrite) float aspectRatio;
@property (nonatomic, readwrite) PanframeNavigationMode navigationMode;
@property (nonatomic, readwrite) PanframeViewMode viewMode;
@property (nonatomic, readwrite) float rotationX;
@property (nonatomic, readwrite) float rotationY;
@property (nonatomic, readwrite) float rotationZ;
@end

NS_ASSUME_NONNULL_END
