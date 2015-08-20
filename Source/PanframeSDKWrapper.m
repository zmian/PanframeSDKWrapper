//
// PanframeSDKWrapper.m
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

#import "PanframeSDKWrapper.h"

#pragma mark ---------------------
#pragma mark - Function Prototypes
#pragma mark ---------------------

PanframeAssetMessage assetMessageEnumConverter(enum PFASSETMESSAGE msg);
PanframeNavigationMode navigationModeEnumConverter(enum PFNAVIGATIONMODE mode);
PanframeBlindSpotLocation blindSpotLocationEnumConverter(enum PFBLINDSPOTLOCATION location);
enum PFBLINDSPOTLOCATION blindSpotLocation_2_PF_BLINDSPOT(PanframeBlindSpotLocation location);
enum PFNAVIGATIONMODE navigationMode_2_PF_NAVIGATION(PanframeNavigationMode mode);

#pragma mark ---------------
#pragma mark - PanframeAsset
#pragma mark ---------------

@interface PanframeAsset() <PFAssetObserver, PFAssetTimeMonitor>
{
    id<PanframeAssetObserver> panframeAssetObserver;
}
@end

@implementation PanframeAsset

- (instancetype)initWithUrl:(NSURL *)url observer:(id<PanframeAssetObserver>)observer
{
    if (self = [super init]) {
        self.asset = (id<PFAsset>)[PFObjectFactory assetFromUrl:url observer:(PFAssetObserver*)self];
        panframeAssetObserver = observer;
    }
    return self;
}

#pragma mark - PFAssetTimeMonitor

- (void)onPlayerTime:(id<PFAsset>)asset hasTime:(CMTime)time
{
    [panframeAssetObserver panframeAsset:self onPlayerTime:time];
}

#pragma mark - PFAssetObserver

- (void)onStatusMessage:(PFAsset *)asset message:(enum PFASSETMESSAGE)m
{
    [panframeAssetObserver panframeAsset:self onStatusMessage:assetMessageEnumConverter(m)];
}

#pragma mark - PFAsset

- (void)playWithSeekTo:(CMTime)start onKeyFrame:(BOOL)keyframe
{
    [self.asset playWithSeekTo:start onKeyFrame:keyframe];
}

- (void)play
{
    [self.asset play];
}

- (void)pause
{
    [self.asset pause];
}

- (void)stop
{
    [self.asset stop];
}

- (void)setTimeRange:(CMTime)start duration:(CMTime)duration onKeyFrame:(BOOL)keyframe
{
    [self.asset setTimeRange:start duration:duration onKeyFrame:keyframe];
}

- (void)addObserver:(PFAssetObserver *)observer
{
    [self.asset addObserver:observer];
}

- (void)removeObserver:(PFAssetObserver *)observer
{
    [self.asset removeObserver:observer];
}

- (bool)setTimeMonitor:(id<PFAssetTimeMonitor>)monitor
{
    return [self.asset setTimeMonitor:monitor];
}

- (void)setVolume:(float)volume
{
    [self.asset setVolume:volume];
}

// Available as Properties

- (CMTimeRange)getTimeRange
{
    return [self.asset getTimeRange];
}

- (CMTime)getPlaybackTime
{
    return [self.asset getPlaybackTime];
}

- (CMTime)getDuration
{
    return [self.asset getDuration];
}

- (NSURL *)getUrl
{
    return [self.asset getUrl];
}

- (enum PFASSETMESSAGE)getStatus
{
    return [self.asset getStatus];
}

- (float)getDownloadProgress
{
    return [self.asset getDownloadProgress];
}

#pragma mark - Properties

- (CMTimeRange)timeRange
{
    return [self.asset getTimeRange];
}

- (CMTime)currentTime
{
    return [self.asset getPlaybackTime];
}

- (CMTime)duration
{
    return [self.asset getDuration];
}

- (NSURL *)assetUrl
{
    return [self.asset getUrl];
}

- (PanframeAssetMessage)status
{
    return assetMessageEnumConverter([self.asset getStatus]);
}

- (float)downloadProgress
{
    return [self.asset getDownloadProgress];
}

@end

#pragma mark --------------
#pragma mark - PanframeView
#pragma mark --------------

@interface PanframeView()
{
    PFView *pfView;
}
@end

@implementation PanframeView

- (instancetype)init
{
    NSLog(@"Called simple init");
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"Called simple initWithFrame");
    if (self = [super initWithFrame:frame]) {
        pfView                  = [PFObjectFactory viewWithFrame:frame];
        pfView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.navigationMode     = PanframeNavigationModeMotion;
        self.viewMode           = PanframeViewModeFlat;
        self.aspectRatio        = 2.0/1.0;
        [self addSubview:pfView];
    }
    return self;
}

#pragma mark - Methods

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    [pfView setInterfaceOrientation:orientation];
}

- (void)setAsset:(PanframeAsset * __nullable)asset
{
    [pfView displayAsset:(PFAsset *)asset.asset];
}

- (void)injectImage:(UIImage * __nullable)image
{
    [pfView injectImage:image];
}

- (void)run
{
    [pfView run];
}

- (void)halt
{
    [pfView halt];
}

- (void)clear
{
    [pfView clear];
}

- (void) resetView
{
    [pfView resetView];
}

- (void)setBlindSpotImage:(NSString *)resourceImageName
{
    [pfView setBlindSpotImage:resourceImageName];
}

- (void)setBlindSpotLocation:(PanframeBlindSpotLocation)location
{
    [pfView setBlindSpotLocation:(enum PFBLINDSPOTLOCATION)location];
}

- (void)setFieldOfView:(float)fov
{
    [pfView setFieldOfView:fov];
}

- (void)setViewMode:(PanframeViewMode)mode andAspectRatio:(float)aspectRatio
{
    self.aspectRatio = aspectRatio;
    [pfView setViewMode:mode andAspect:aspectRatio];
}

- (id<PFHotspot>)createHotspot:(UIImage *)image
{
    return [pfView createHotspot:image];
}

- (void)removeHotspot:(id<PFHotspot>)hotspot
{
    [pfView removeHotspot:hotspot];
}

- (void)setAutoLevel:(BOOL)autoLevel afterSeconds:(float)seconds
{
    [pfView setAutoLevel:autoLevel afterSeconds:seconds];
}

- (void)setStereo:(BOOL)stereo
{
    [pfView setStereo:stereo];
}

#pragma mark - Properties

- (void)setRotationX:(float)rotationX
{
    [pfView setRotationX:rotationX];
}

- (float)rotationX
{
    return [pfView getRotationX];
}

- (void)setRotationY:(float)rotationY
{
    [pfView setRotationY:rotationY];
}

- (float)rotationY
{
    return [pfView getRotationY];
}

- (void)setRotationZ:(float)rotationZ
{
    [pfView setRotationZ:rotationZ];
}

- (float)rotationZ
{
    return [pfView getRotationZ];
}

- (void)setNavigationMode:(PanframeNavigationMode)navigationMode
{
    _navigationMode = navigationMode;
    [pfView setNavigationMode:navigationMode_2_PF_NAVIGATION(navigationMode)];
}

- (void)setViewMode:(PanframeViewMode)viewMode
{
    _viewMode = viewMode;
    [self setViewMode:viewMode andAspectRatio:self.aspectRatio];
}

- (void)toggleNavigationMode
{
    if (self != nil)
    {
        if (self.navigationMode == PanframeNavigationModeMotion)
        {
            self.navigationMode = PanframeNavigationModeTouch;
        }
        else
        {
            self.navigationMode = PanframeNavigationModeMotion;
        }
    }
}

- (void)toggleViewMode
{
    if (self != nil)
    {
        switch (self.viewMode) {
            case PanframeViewModeSpherical:
                self.viewMode = PanframeViewModeFlat;
                break;
            case PanframeViewModeFlat:
                self.viewMode = PanframeViewModeCylindrical;
                break;
            case PanframeViewModeCylindrical:
                self.viewMode = PanframeViewModeVRSideBySide;
                break;
            case PanframeViewModeVRSideBySide:
                self.viewMode = PanframeViewModeVRTopDown;
                break;
            default:
                self.viewMode = PanframeViewModeSpherical;
                break;
        }
    }
}

@end

#pragma mark ---------
#pragma mark - Helpers
#pragma mark ---------

PanframeAssetMessage assetMessageEnumConverter(enum PFASSETMESSAGE msg)
{
    PanframeAssetMessage message = PanframeAssetMessageError;

    switch (msg) {
        case PF_ASSET_ERROR:
            message = PanframeAssetMessageError;
            break;
        case PF_ASSET_LOADED:
            message = PanframeAssetMessageLoaded;
            break;
        case PF_ASSET_SEEKING:
            message = PanframeAssetMessageSeeking;
            break;
        case PF_ASSET_PLAYING:
            message = PanframeAssetMessagePlaying;
            break;
        case PF_ASSET_PAUSED:
            message = PanframeAssetMessagePaused;
            break;
        case PF_ASSET_COMPLETE:
            message = PanframeAssetMessageComplete;
            break;
        case PF_ASSET_STOPPED:
            message = PanframeAssetMessageStopped;
            break;
        case PF_ASSET_DOWNLOADED:
            message = PanframeAssetMessageDownloaded;
            break;
        case PF_ASSET_DOWNLOADING:
            message = PanframeAssetMessageDownloading;
            break;
        case PF_ASSET_DOWNLOADCANCELLED:
            message = PanframeAssetMessageDownloadCancelled;
            break;
        default:
            break;
    }

    return message;
}

PanframeNavigationMode navigationModeEnumConverter(enum PFNAVIGATIONMODE mode)
{
    PanframeNavigationMode navigationMode;

    switch (mode) {
        case PF_NAVIGATION_MOTION:
            navigationMode = PanframeNavigationModeMotion;
            break;
        case PF_NAVIGATION_TOUCH:
            navigationMode = PanframeNavigationModeTouch;
            break;
    }

    return navigationMode;
}

PanframeBlindSpotLocation blindSpotLocationEnumConverter(enum PFBLINDSPOTLOCATION location)
{
    PanframeBlindSpotLocation blindSpotLocation;

    switch (location) {
        case PF_BLINDSPOT_NONE:
            blindSpotLocation = PanframeBlindSpotLocationNone;
            break;
        case PF_BLINDSPOT_TOP:
            blindSpotLocation = PanframeBlindSpotLocationTop;
            break;
        case PF_BLINDSPOT_BOTTOM:
            blindSpotLocation = PanframeBlindSpotLocationBottom;
            break;
    }

    return blindSpotLocation;
}

enum PFBLINDSPOTLOCATION blindSpotLocation_2_PF_BLINDSPOT(PanframeBlindSpotLocation location)
{
    enum PFBLINDSPOTLOCATION blindSpotLocation;

    switch (location) {
        case PanframeBlindSpotLocationNone:
            blindSpotLocation = PF_BLINDSPOT_NONE;
            break;
        case PanframeBlindSpotLocationTop:
            blindSpotLocation = PF_BLINDSPOT_TOP;
            break;
        case PanframeBlindSpotLocationBottom:
            blindSpotLocation = PF_BLINDSPOT_BOTTOM;
            break;
    }

    return blindSpotLocation;
}

enum PFNAVIGATIONMODE navigationMode_2_PF_NAVIGATION(PanframeNavigationMode mode)
{
    enum PFNAVIGATIONMODE navigationMode;

    switch (mode) {
        case PanframeNavigationModeMotion:
            navigationMode = PF_NAVIGATION_MOTION;
            break;
        case PanframeNavigationModeTouch:
            navigationMode = PF_NAVIGATION_TOUCH;
            break;
    }
    
    return navigationMode;
}
