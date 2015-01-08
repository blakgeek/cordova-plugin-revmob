#import "RevMobPlugin.h"

@interface RevMobPlugin ()

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
    [RevMobAds startSessionWithAppID: appId withSuccessHandler:^{
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } andFailHandler:^(NSError *error) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", error]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)enableTestMode:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].testingMode = [[command argumentAtIndex:0 withDefault:@"YES"] boolValue] ? RevMobAdsTestingModeWithAds : RevMobAdsTestingModeWithoutAds;
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)disableTestMode:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].testingMode = RevMobAdsTestingModeOff;
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)openAdLink:(CDVInvokedUrlCommand *)command {

    if(self.adLink == nil) {
        self.adLink = [[RevMobAds session] adLink];
    }
    [self.adLink loadWithSuccessHandler:^(RevMobAdLink *adLink) {
        [adLink openLink];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } andLoadFailHandler:^(RevMobAdLink *adLink, NSError *error) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", error]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showPopupAd:(CDVInvokedUrlCommand *)command {

    if(self.popupAd == nil) {
        self.popupAd = [[RevMobAds session] popup];
    }
    [self.popupAd loadWithSuccessHandler:^(RevMobPopup *popup) {
        [popup showAd];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } andLoadFailHandler:^(RevMobPopup *popup, NSError *error) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", error]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } onClickHandler:^(RevMobPopup *popup) {

        NSLog(@"Popup Clicked");
        // TODO: fire javascript event
    }];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showInterstitialAd:(CDVInvokedUrlCommand *)command {

    if(self.interstitial == nil) {
       self.interstitial = [[RevMobAds session] fullscreen];
    }
    [self.interstitial loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", error]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)printEnvironmentInformation:(CDVInvokedUrlCommand *)command {

    [[RevMobAds session] printEnvironmentInformation];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setConnectionTimeout:(CDVInvokedUrlCommand *)command {

    [RevMobAds session].connectionTimeout = [[command argumentAtIndex:0] intValue];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showBannerAd:(CDVInvokedUrlCommand *)command {

    if(self.bannerView == nil) {
        self.bannerView = [[RevMobAds session] bannerView];
        self.bannerView.hidden = YES;
        [self.containerView insertSubview:self.bannerView belowSubview:self.webView];
    }

    self.bannerAtTop = [[command argumentAtIndex:0 withDefault:@"NO"] boolValue];

    [self updateViewFrames];
    self.webView.frame = self.webViewFrame;
    self.bannerView.frame = self.bannerFrame;
    self.bannerView.hidden = NO;

    [self.bannerView loadWithSuccessHandler:^(RevMobBannerView *banner) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%@", error]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } onClickHandler:^(RevMobBannerView *banner) {

        NSLog(@"Banner Clicked");
        // TODO: fire javascript event notification of the click
    }];
}

- (void)hideBannerAd:(CDVInvokedUrlCommand *)command {

    if(self.bannerView != nil) {
        self.webView.frame = self.containerView.frame;
        self.bannerView.hidden = YES;
    }
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
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
@end
