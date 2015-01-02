#import <Foundation/Foundation.h>
#import "RevMobAds.h"
#import "CDVPlugin.h"
#import "RevMobAdsDelegate.h"


@interface RevMobPlugin : CDVPlugin <RevMobAdsDelegate>

@property (nonatomic, strong)RevMobBanner *bannerWindow;

- (void) startSession:(CDVInvokedUrlCommand*)command;

- (void) setTestingMode:(CDVInvokedUrlCommand*)command;

- (void) openAdLink:(CDVInvokedUrlCommand*)command;

- (void) showPopup:(CDVInvokedUrlCommand*)command;

- (void) showBanner:(CDVInvokedUrlCommand*)command;

- (void) hideBanner:(CDVInvokedUrlCommand*)command;

- (void) showFullscreen:(CDVInvokedUrlCommand*)command;

- (void) printEnvironmentInformation:(CDVInvokedUrlCommand*)command;

- (void) setTimeoutInSeconds:(CDVInvokedUrlCommand*)command;

@property (nonatomic, strong)CDVInvokedUrlCommand *sessionCommand;

@end