#import "RevMobPluginEx.h"

@interface RevMobPluginEx()

//- (void)resizeViews;

- (void)deviceOrientationChange:(NSNotification *)notification;

- (void)updateViewFrames;

//- (bool) __isLandscape;

//- (int) __getBannerHeight;

@end

@implementation RevMobPluginEx

- (void) pluginInitialize
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationChange:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    self.containerView = self.webView.superview;
    
    CGSize containerSize = self.containerView.frame.size;
    
    // precalculate all sizes here
    CGFloat max = MAX(containerSize.width, containerSize.height);
    CGFloat min = MIN(containerSize.width, containerSize.height);
    
    // TODO: get min and max measurements and use them to setup the frames below
    // TODO: add properties for landscape and portrait rectangles
    
    self.bannerFrameTopLandscape = CGRectMake(0, 0, max, 50);
    self.bannerFrameBottomLandscape = CGRectMake(0, min - 50, max, 50);
    self.webViewFrameTopLandscape = CGRectMake(0, 50, max, min - 50);
    self.webViewFrameBottomLandscape = CGRectMake(0, 0, max, min - 50);
    
    self.bannerFrameTopPortrait = CGRectMake(0, 0, min, 50);
    self.bannerFrameBottomPortrait = CGRectMake(0, max - 50, min, 50);
    self.webViewFrameTopPortrait = CGRectMake(0, 50, min, max - 50);
    self.webViewFrameBottomPortrait = CGRectMake(0, 0, min, max - 50);
    
    [self updateViewFrames];
}

- (void) updateViewFrames {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        // portrait
        if(self.bannerAtTop) {
            self.bannerFrame = self.bannerFrameTopPortrait;
            self.webViewFrame = self.webViewFrameTopPortrait;
        } else {
            self.bannerFrame = self.bannerFrameBottomPortrait;
            self.webViewFrame = self.webViewFrameBottomPortrait;
        }
    } else {
        
        // landscape
        if(self.bannerAtTop) {
            self.bannerFrame = self.bannerFrameTopLandscape;
            self.webViewFrame = self.webViewFrameTopLandscape;
        } else {
            self.bannerFrame = self.bannerFrameBottomLandscape;
            self.webViewFrame = self.webViewFrameBottomLandscape;
        }
    }
}

- (void)startSession:(CDVInvokedUrlCommand *)command {
    
    NSString *appId = [command argumentAtIndex:0];
    NSLog(@"Starting session for appId: %@", appId);
    [RevMobAds startSessionWithAppID: @"548bba2f85c0ffa609ba13d4"
                  withSuccessHandler:^{
                      self.bannerView = [[RevMobAds session] bannerView];
                      self.bannerView.hidden = YES;
                      [self.containerView insertSubview: self.bannerView belowSubview: self.webView];
                  } andFailHandler:^(NSError *error) {
                      NSLog(@"Session failed to start with block %@", error.userInfo);
                      
                  }];
}

- (void)deviceOrientationChange:(NSNotification *)notification {
    
    [self updateViewFrames];
    
    if (self.bannerView.isHidden == NO) {
        self.webView.frame = self.webViewFrame;
        self.bannerView.frame = self.bannerFrame;
    }
    
    //    CGRect superRect = self.webView.superview.frame;
    //    NSLog(@"%f, %f", superRect.size.width, superRect.size.height);
    //    NSLog(@"%d", self.viewController.shouldAutorotate);
    
}

- (void) showBanner:(CDVInvokedUrlCommand *)command {
    
    self.bannerAtTop = [[command argumentAtIndex:0 withDefault: @"NO"] boolValue];
    
    [self updateViewFrames];
    self.webView.frame = self.webViewFrame;
    self.bannerView.frame = self.bannerFrame;
    self.bannerView.hidden = NO;
    
    [self.bannerView loadAd];
}


- (void) hideBanner:(CDVInvokedUrlCommand*)command {
    
    self.webView.frame = self.containerView.frame;
    self.bannerView.hidden = YES;
}
@end
