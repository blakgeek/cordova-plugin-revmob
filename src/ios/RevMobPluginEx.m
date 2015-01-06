#import "RevMobPluginEx.h"

@interface RevMobPluginEx ()

//- (void)resizeViews;

- (void)deviceOrientationChange:(NSNotification *)notification;

- (void)updateViewFrames;

@end

@implementation RevMobPluginEx

- (void)pluginInitialize {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(deviceOrientationChange:)
                   name:UIDeviceOrientationDidChangeNotification
                 object:nil];

    self.containerView = self.webView.superview;
    self.containerView.backgroundColor = [UIColor blackColor];

    // precalculate all frame sizes and positions
    CGSize containerSize = self.containerView.frame.size;
    CGFloat max = MAX(containerSize.width, containerSize.height);
    CGFloat min = MIN(containerSize.width, containerSize.height);
    float bannerWidth, bannerHeight;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerWidth = 768;
        bannerHeight = 114;
    } else {
        bannerWidth = 320;
        bannerHeight = 50;
    }

    self.bannerFrameTopLandscape = CGRectMake(max / 2 - bannerWidth / 2, 0, bannerWidth, bannerHeight);
    self.bannerFrameBottomLandscape = CGRectMake(max / 2 - bannerWidth / 2, min - bannerHeight, bannerWidth, bannerHeight);
    self.webViewFrameTopLandscape = CGRectMake(0, bannerHeight, max, min - bannerHeight);
    self.webViewFrameBottomLandscape = CGRectMake(0, 0, max, min - bannerHeight);

    self.bannerFrameTopPortrait = CGRectMake(min / 2 - bannerWidth / 2, 0, bannerWidth, bannerHeight);
    self.bannerFrameBottomPortrait = CGRectMake(min / 2 - bannerWidth / 2, max - bannerHeight, bannerWidth, bannerHeight);
    self.webViewFrameTopPortrait = CGRectMake(0, bannerHeight, min, max - bannerHeight);
    self.webViewFrameBottomPortrait = CGRectMake(0, 0, min, max - bannerHeight);

    [self updateViewFrames];
}

- (void)updateViewFrames {

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsPortrait(orientation)) {
        // portrait
        if (self.bannerAtTop) {
            self.bannerFrame = self.bannerFrameTopPortrait;
            self.webViewFrame = self.webViewFrameTopPortrait;
        } else {
            self.bannerFrame = self.bannerFrameBottomPortrait;
            self.webViewFrame = self.webViewFrameBottomPortrait;
        }
    } else {

        // landscape
        if (self.bannerAtTop) {
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
    [RevMobAds startSessionWithAppID:@"548bba2f85c0ffa609ba13d4"
                  withSuccessHandler:^{
                      self.bannerView = [[RevMobAds session] bannerView];
                      self.bannerView.hidden = YES;
                      [self.containerView insertSubview:self.bannerView belowSubview:self.webView];
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
}

- (void)showBanner:(CDVInvokedUrlCommand *)command {

    self.bannerAtTop = [[command argumentAtIndex:0 withDefault:@"NO"] boolValue];

    [self updateViewFrames];
    self.webView.frame = self.webViewFrame;
    self.bannerView.frame = self.bannerFrame;
    self.bannerView.hidden = NO;

    [self.bannerView loadAd];
}

- (void)hideBanner:(CDVInvokedUrlCommand *)command {

    self.webView.frame = self.containerView.frame;
    self.bannerView.hidden = YES;
}
@end
