#import "RevMobPlugin.h"

@interface RevMobPlugin ()

//- (void)resizeViews;

- (void)deviceOrientationChange:(NSNotification *)notification;

- (void)updateViewFrames;

@end

@implementation RevMobPlugin

#pragma mark - CDVPlugin

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
    float bannerWidth = 320;
    float bannerHeight = 50;

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

#pragma mark - RevMobPlugin

- (void)startSession:(CDVInvokedUrlCommand *)command {

    NSString *appId = [command argumentAtIndex:0];
    NSLog(@"Starting session for appId: %@", appId);
    [RevMobAds startSessionWithAppID:@"548bba2f85c0ffa609ba13d4"
                  withSuccessHandler:^{
                      // TODO: should I make sure the memory any previous RevMobAds reference is released or do nothing it already exists?
                      self.bannerView = [[RevMobAds session] bannerView];
                      self.bannerView.hidden = YES;
                      [self.containerView insertSubview:self.bannerView belowSubview:self.webView];
                  } andFailHandler:^(NSError *error) {
                NSLog(@"Session failed to start with block %@", error.userInfo);
            }];
}

- (void)enableTestMode:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].testingMode = [[command argumentAtIndex:0 withDefault:@"YES"] boolValue] ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeWithoutAds;
}

- (void)disableTestMode:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].testingMode = RevMobAdsTestingModeOff;
}

- (void)openAdLink:(CDVInvokedUrlCommand *)command {

    [[RevMobAds session] openAdLinkWithDelegate: self];
}

- (void)showPopupAd:(CDVInvokedUrlCommand *)command {

    [[RevMobAds session] showPopup];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand *)command {

    [[RevMobAds session] showFullscreen];
}

- (void)printEnvironmentInformation:(CDVInvokedUrlCommand *)command {

    [[RevMobAds session] printEnvironmentInformation];
}

- (void)setConnectionTimeout:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].connectionTimeout = [[command argumentAtIndex:0] intValue];
}

- (void)showBannerAd:(CDVInvokedUrlCommand *)command {

    self.bannerAtTop = [[command argumentAtIndex:0 withDefault:@"NO"] boolValue];

    [self updateViewFrames];
    self.webView.frame = self.webViewFrame;
    self.bannerView.frame = self.bannerFrame;
    self.bannerView.hidden = NO;

    [self.bannerView loadAd];
}

- (void)hideBannerAd:(CDVInvokedUrlCommand *)command {

    self.webView.frame = self.containerView.frame;
    self.bannerView.hidden = YES;
}

#pragma mark - interal stuff

- (void)deviceOrientationChange:(NSNotification *)notification {

    [self updateViewFrames];

    if (self.bannerView.isHidden == NO) {
        self.webView.frame = self.webViewFrame;
        self.bannerView.frame = self.bannerFrame;
    }
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


#pragma mark - RevMobAdsDelegate
// TODO: fire javascript events when these various actions occur
- (void)revmobAdDidFailWithError:(NSError *)error {

    NSLog(@"Ad Load Error: %@", error);
}

- (void)revmobSessionIsStarted {

    NSLog(@"Session started");
}

- (void)revmobSessionNotStartedWithError:(NSError *)error {
    NSLog(@"Session Start Error: %@", error);
}

- (void)revmobAdDidReceive {
    NSLog(@"Ad Recieved");
}

- (void)revmobAdDisplayed {

    NSLog(@"Ad Displayed");
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"Ad clicked");
}

- (void)revmobUserClosedTheAd {

    NSLog(@"Ad closed");
}

- (void)installDidReceive {
    NSLog(@"Install received.");
}

- (void)installDidFail {

    NSLog(@"Install failed");
}

@end
