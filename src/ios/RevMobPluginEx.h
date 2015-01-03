#import "RevMobPlugin.h"

@interface RevMobPluginEx : RevMobPlugin

@property (nonatomic, strong)RevMobBannerView *bannerView;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic) CGRect bannerFrameTopLandscape;
@property (nonatomic) CGRect bannerFrameBottomLandscape;
@property (nonatomic) CGRect webViewFrameTopLandscape;
@property (nonatomic) CGRect webViewFrameBottomLandscape;
@property (nonatomic) CGRect bannerFrameTopPortrait;
@property (nonatomic) CGRect bannerFrameBottomPortrait;
@property (nonatomic) CGRect webViewFrameTopPortrait;
@property (nonatomic) CGRect webViewFrameBottomPortrait;
@property (nonatomic) CGRect webViewFrame;
@property (nonatomic) CGRect bannerFrame;
@property (nonatomic, getter=isBannerAtTop) BOOL bannerAtTop;

@end