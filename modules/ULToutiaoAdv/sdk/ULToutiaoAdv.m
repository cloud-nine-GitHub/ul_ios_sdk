//
//  ULToutiaoAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/2/25.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULToutiaoAdv.h"
#import "ULILifeCycle.h"
#import "ULTools.h"
#import "ULNotificationDispatcher.h"
#import "ULNotification.h"
#import "ULSplashViewController.h"
#import "ULConfig.h"
#import "ULCop.h"
#import <BUAdSDK/BUAdSDKManager.h>
#import <BUAdSDK/BUSplashAdView.h>
#import <BUAdSDK/BUInterstitialAd.h>
#import <BUAdSDK/BUSize.h>
#import <BUAdSDK/BUFullscreenVideoAd.h>
#import <BUAdSDK/BURewardedVideoAd.h>
#import <BUAdSDK/BURewardedVideoModel.h>
#import <BUAdSDK/BUBannerAdView.h>
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>
#import <BUAdSDK/BUNativeExpressBannerView.h>
#import <BUAdSDK/BUNativeExpressRewardedVideoAd.h>
#import <BUAdSDK/BUNativeExpressFullscreenVideoAd.h>
#import <BUAdSDK/BUNativeExpressSplashView.h>
#import "ULTimer.h"


@interface ULToutiaoAdv()<ULILifeCycle,BUSplashAdDelegate,BUNativeExpressSplashViewDelegate,BUNativeExpressRewardedVideoAdDelegate,BUNativeExpresInterstitialAdDelegate,BUNativeExpressBannerViewDelegate,BUNativeExpressFullscreenVideoAdDelegate>


@property (nonatomic, retain) UIView *customSplashView;
@property (nonatomic, strong) BUSplashAdView *splashView;
@property (nonatomic, strong) BUNativeExpressSplashView *_busplashAdView;

@property (nonatomic, strong) BUNativeExpressInterstitialAd *expressInterAd;
@property (nonatomic, strong) BUNativeExpressBannerView *expressBannerAd;
@property (nonatomic, strong) BUNativeExpressRewardedVideoAd *expressRewardedVideoAd;
@property (nonatomic, strong) BUNativeExpressFullscreenVideoAd *expressFullscreenVideoAd;
//该如何保持与每次的请求一致
@property (nonatomic, strong) NSDictionary *splashJson,*interJson,*videoJson,*fullscreenJson,*bannerJson;
@property (nonatomic, strong) NSString *splashId,*interId,*videoId,*fullscreenId,*bannerId;
@property (nonatomic, assign) int bannerRefreshTime;
@property (nonatomic, assign) BOOL isSplashClicked;
@end

@implementation ULToutiaoAdv





- (void)onInitModule
{
    NSLog(@"%s",__func__);
    
}


- (void)onDisposeModule
{
    NSLog(@"%s",__func__);
}

- (void)addListener
{
    NSLog(@"%s",__func__);
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_FULLSCREEN_ADV withSelector:@selector(onShowFullscreenAdv:) withPriority:PRIORITY_NONE];
    
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_BANNER_ADV withSelector:@selector(onShowBannerAdv:) withPriority:PRIORITY_NONE];
    
    
}

- (void)onShowInterAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showInterstitialAdv:data];
}

- (void)onShowVideoAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showVideoAdv:data];
}

- (void)onShowFullscreenAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showFullscreenAdv:data];
}

- (void)onShowBannerAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showBannerAdv:data];
}




- (NSString *)onJsonAPI :(NSString *)param
{
    NSLog(@"%s",__func__);
    return nil;
    
}

- (NSMutableDictionary *)onResultChannelInfo:(NSMutableDictionary *)baseChannelInfo
{
    NSLog(@"%s",__func__);
    return nil;
    
}

- (NSString *)onJsonRpcCall:(NSString *)jsonRpcCallStr
{
    NSLog(@"%s",__func__);
    return nil;
    
}




- (void)applicationDidBecomeActive {
    NSLog(@"%s",__func__);
}

- (void)applicationDidEnterBackground {
    NSLog(@"%s",__func__);
}

- (void)applicationDidReceiveMemoryWarning {
    NSLog(@"%s",__func__);
}

- (void)applicationWillEnterForeground {
    NSLog(@"%s",__func__);
}

- (void)applicationWillResignActive {
    NSLog(@"%s",__func__);
}

- (void)applicationWillTerminate {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    NSLog(@"%s",__func__);
}

- (void)initModuleAdv
{
    NSLog(@"%s",__func__);
    [self addListener];
    //初始化sdk
    NSString *appId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_toutiao_appid" :@""];
    [BUAdSDKManager setAppID:appId];
    [BUAdSDKManager setIsPaidApp:NO];
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
    
    //获取banner的轮播时间间隔，单位s
    NSString *bannerRefreshTimeStr = [ULTools GetStringFromDic:[ULCop getCopInfo] :@"s_sdk_adv_toutiao_banner_refresh_time" :@""];
    if (bannerRefreshTimeStr != nil && ![bannerRefreshTimeStr isEqualToString:@""]) {
        
        _bannerRefreshTime = [bannerRefreshTimeStr intValue];
        
        
    }else{//默认值
        _bannerRefreshTime = 30;
    }
}

- (void)onConstructorAdv
{
    
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_EMBEDDED]];
}


- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _isSplashClicked = NO;
    _splashJson = json;
    [self showNormalSplashAdv:json];
}

//普通开屏
- (void)showNormalSplashAdv : (NSDictionary *)json
{
    
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    _splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_splashid" withDefaultParam:@"" withSplitString:@"|"];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:_splashId frame:frame];
    splashView.delegate = self;
    [splashView loadAdData];
    [[ULTools getCurrentViewController].view addSubview:splashView];
    splashView.rootViewController = [ULTools getCurrentViewController];
}

//模版开屏
- (void)showExpressSplashAdv: (NSDictionary *)json
{
    
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    _splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_splashid" withDefaultParam:@"" withSplitString:@"|"];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    BUNativeExpressSplashView *splashView = [[BUNativeExpressSplashView alloc] initWithSlotID:_splashId adSize:frame.size rootViewController:[ULTools getCurrentViewController]];
    splashView.delegate = self;
    
    [splashView loadAdData];
    [[ULTools getCurrentViewController].view addSubview:splashView];
}

- (void)showInterstitialAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _interJson = json;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    _interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_interid" withDefaultParam:@"" withSplitString:@"|"];
    self.expressInterAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:_interId adSize:CGSizeMake(300, 300)];
    self.expressInterAd.delegate = self;
    [self.expressInterAd loadAdData];
    
}

- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _videoJson = json;
    //视频
    BURewardedVideoModel *videoModel = [[BURewardedVideoModel alloc] init];
    
    videoModel.userId = @"123";
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    _videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_videoid" withDefaultParam:@"" withSplitString:@"|"];
    self.expressRewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:_videoId rewardedVideoModel:videoModel];
    self.expressRewardedVideoAd.delegate = self;
    [self.expressRewardedVideoAd loadAdData];
}

- (void)showFullscreenAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    //    if (!csjFullScreenVidedoId) {
    //        csjFullScreenVidedoId = @"000";
    //    }
    //每次请求数据 需要重新创建一个对应的 BUFullscreenVideoAd管理,不可使用同一条重复请求数据.
    
    _fullscreenJson = json;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    _fullscreenId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_fullscreenid" withDefaultParam:@"" withSplitString:@"|"];
    self.expressFullscreenVideoAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID: _fullscreenId];
    self.expressFullscreenVideoAd.delegate = self;
    [self.expressFullscreenVideoAd loadAdData];
    
}

- (void)showBannerAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    //banner素材的宽高
//    _bannerJson = json;
//    BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_100];
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    CGFloat bannerHeight = screenSize.width * size.height / size.width;
//
//    CGFloat bannerY = screenSize.height - bannerHeight;
//
//
//    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
//    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
//    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
//    _bannerId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_bannerid" withDefaultParam:@"" withSplitString:@"|"];
//
//    self.expressBannerAd = [[BUNativeExpressBannerView alloc] initWithSlotID:_bannerId rootViewController:[ULTools getCurrentViewController] adSize:CGSizeMake(screenSize.width, bannerHeight) IsSupportDeepLink:YES interval:_bannerRefreshTime];
//
//
//    self.expressBannerAd.frame = CGRectMake(0, bannerY, screenSize.width, bannerHeight);
//    self.expressBannerAd.delegate = self;
//    [[ULTools getCurrentViewController].view addSubview:self.expressBannerAd];
//
//    [self.expressBannerAd loadAdData];
    
    //TODO banner需要重新处理逻辑
    
}

- (void)showUrlAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
    
}

- (void)showEmbeddedAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

- (void)showGiftAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)showIconAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}

- (void)closeAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
}

#pragma mark - normal splash delegate
/**
 This method is called when splash ad material loaded successfully.
 */
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [splashAd removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg];
}

/**
 This method is called when splash ad slot will be showing.
 */
- (void)splashAdWillVisible:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
    [self showAdv:_splashJson :_splashId];
}

/**
 This method is called when splash ad is clicked.
 */
- (void)splashAdDidClick:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
    _isSplashClicked = YES;
    [self showClicked:_splashJson :_splashId];
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
    [splashAd removeFromSuperview];
    if (!_isSplashClicked) {
        [[ULSplashViewController getInstance]removeSplashView];
    }else{
        //TODO 零时处理方案：由于单独提供vc作为开屏展示，在关闭回调中有处理跳转逻辑，开屏点击后也会回调关闭，导致点击广告跳转存在问题。目前是每秒钟去检测当前的vc来判断是否已经回到开屏，然后做对应的逻辑处理，但是这种临时方案对l打开链接性广告还是无法生效。
        [[ULTimer getInstance]startTimerWithName:@"toutiao_splash_delay_close" withTarget:self withTime:1.0 withSel:@selector(delayClose) withUserInfo:nil withRepeat:YES];
    }

}

- (void)delayClose
{
    NSLog(@"%s",__func__);
    //检测当前的vc是否是开屏vc
    UIViewController *vc = [ULTools getCurrentViewController];
    NSString *vcName = NSStringFromClass([vc class]);
    if ([vcName isEqualToString:@"ULSplashViewController"]) {
        NSLog(@"%s:已经回到开屏vc",__func__);
        [[ULTimer getInstance] stopTimerWithName:@"toutiao_splash_delay_close"];
        [[ULSplashViewController getInstance]removeSplashView];
    }
    
}

/**
 This method is called when splash ad is about to close.
 */
- (void)splashAdWillClose:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 This method is called when spalashAd skip button  is clicked.
 */
- (void)splashAdDidClickSkip:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
    [[ULSplashViewController getInstance]removeSplashView];
}

/**
 This method is called when spalashAd countdown equals to zero
 */
- (void)splashAdCountdownToZero:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
}


/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType
{
    NSLog(@"%s",__func__);
    
    //经测试，本函数不回调。按理说点击后的vc逻辑应该在本回调中处理，用户关闭广告跳转页面后再进行vc跳转
}




#pragma mark - express splash delegate
- (void)nativeExpressSplashViewDidLoad:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    
}

- (void)nativeExpressSplashView:(nonnull BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [splashAdView removeSplashView];
    [splashAdView removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg];
}


- (void)nativeExpressSplashViewRenderSuccess:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    [self showAdv:_splashJson :_splashId];
}

- (void)nativeExpressSplashViewRenderFail:(nonnull BUNativeExpressSplashView *)splashAdView error:(NSError * _Nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [splashAdView removeSplashView];
    [splashAdView removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg];
}

- (void)nativeExpressSplashViewWillVisible:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    
}

- (void)nativeExpressSplashViewDidClick:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    [self showClicked:_splashJson :_splashId];
}


- (void)nativeExpressSplashViewDidClickSkip:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    [[ULSplashViewController getInstance]removeSplashView];
}

- (void)nativeExpressSplashViewDidClose:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    [splashAdView removeSplashView];
    [splashAdView removeFromSuperview];
    [[ULSplashViewController getInstance]removeSplashView];
}


- (void)nativeExpressSplashViewFinishPlayDidPlayFinish:(BUNativeExpressSplashView *)splashView didFailWithError:(NSError *)error {
    NSLog(@"%s%@",__func__,error);
}

/**
 This method is called when nativeExpressSplashAdView countdown equals to zero
 */
- (void)nativeExpressSplashViewCountdownToZero:(BUNativeExpressSplashView *)splashAdView
{
    NSLog(@"%s",__func__);
}


#pragma mark - inter delegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    
    NSLog(@"%s",__func__);
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *__nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_interJson :_interId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
}



- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"%s",__func__);
    if (self.expressInterAd.isAdValid) {
        [self.expressInterAd showAdFromRootViewController:[ULTools getCurrentViewController]];
    }else{
        NSLog(@"%s%@",__func__,@"express inter not ready");
        [self showNextAdv:_interJson :_interId :@"express inter not ready"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:@"express inter not ready"];
    }
}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *__nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_interJson :_interId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
    
}


- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"%s",__func__);
    [self showAdv:_interJson :_interId];
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"%s",__func__);
    [self showClicked:_interJson :_interId];
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    
    NSLog(@"%s",__func__);
    
}



#pragma mark - video delegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_videoJson :_videoId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
    
}

/**
 this methods is to tell delegate the type of native express rewarded video Ad
 */
- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType
{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    
    if (self.expressRewardedVideoAd.isAdValid) {
        // The reward based video ad is available, present the ad.
        //UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        // 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
        [self.expressRewardedVideoAd showAdFromRootViewController:[ULTools getCurrentViewController]];
    } else {
        [self showNextAdv:_videoJson :_videoId :@"广告素材无效"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:@"广告素材无效"];
    }
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_videoJson :_videoId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self showAdv:_videoJson :_videoId];
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self resumeSound];
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self showClose:_videoJson :_videoId];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    
    NSLog(@"%s",__func__);
    [self showClicked:_videoJson :_videoId];
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    [self showFailed:_videoJson :_videoId :@"adv not play complete"];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:@"adv not play complete"];
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error
{
    NSLog(@"%s%@",__func__,error);
//    NSString *errorMsg = [[NSString alloc]initWithFormat:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%ld",(long)error.code],@"; errorMsg = ",error.localizedFailureReason];
//    [self resumeSound];
//    [self showNextAdv:_videoJson :_videoId :errorMsg];
//    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
}

#pragma mark - banner delegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError * _Nullable)error {
    
    NSLog(@"%s%@",__func__,error);
    
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    NSLog(@"%s%@",__func__,error);
    
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"%s",__func__);
    
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"%s",__func__);
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords {
    NSLog(@"%s",__func__);
    
}


#pragma mark - fullscreen delegate
- (void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_fullscreenJson :_fullscreenId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    if(self.expressFullscreenVideoAd.isAdValid){
        [self.expressFullscreenVideoAd showAdFromRootViewController:[ULTools getCurrentViewController]];
    }else {
        [self showNextAdv:_fullscreenJson :_fullscreenId :@"广告素材无效"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:@"广告素材无效"];
    }
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [self showNextAdv:_fullscreenJson :_fullscreenId :errorMsg];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
    
}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    
    NSLog(@"%s",__func__);
    [self pauseSound];
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    
    NSLog(@"%s",__func__);
    [self showAdv:_fullscreenJson :_fullscreenId];
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    [self showClicked:_fullscreenJson :_fullscreenId];
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    [self resumeSound];
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    [self resumeSound];
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"%s%@",__func__,error);
//    NSString *errorMsg = [[NSString alloc]initWithFormat:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%ld",(long)error.code],@"; errorMsg = ",error.localizedFailureReason];
//    [self resumeSound];
//    [self showNextAdv:_fullscreenJson :_fullscreenId :errorMsg];
//    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_TOUTIAO_ADV_CALLBACK withData:errorMsg];
}


/**
 This method is used to get the type of nativeExpressFullScreenVideo ad
 */
- (void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType) nativeExpressVideoAdType
{
    NSLog(@"%s",__func__);
}



- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
//BUErrorCodeTempError        = -6,       // native template is invalid
//BUErrorCodeTempAddationError= -5,       // native template addation is invalid
//BUErrorCodeOpenAPPStoreFail = -4,       // failed to open appstore
//BUErrorCodeNOAdError        = -3,       // parsed data has no ads
//BUErrorCodeNetError         = -2,       // network request failed
//BUErrorCodeParseError       = -1,       // parsing failed
//
//BUErrorCodeNERenderResultError= 101,    // native Express ad, render result parse fail
//BUErrorCodeNETempError        = 102,    // native Express ad, template is invalid
//BUErrorCodeNETempPluginError  = 103,    // native Express ad, template plugin is invalid
//BUErrorCodeNEDataError        = 104,    // native Express ad, data is invalid
//BUErrorCodeNEParseError       = 105,    // native Express ad, parse fail
//BUErrorCodeNERenderError      = 106,    // native Express ad, render fail
//BUErrorCodeNERenderTimoutError= 107,    // native Express ad, render timeout
//
//BUErrorCodeSDKStop          = 1000,     // SDK stop forcely
//
//BUErrorCodeParamError       = 10001,    // parameter error
//BUErrorCodeTimeout          = 10002,
//
//BUErrorCodeSuccess          = 20000,
//BUErrorCodeNOAD             = 20001,    // no ads
//
//BUErrorCodeContentType      = 40000,    // http conent_type error
//BUErrorCodeRequestPBError   = 40001,    // http request pb error
//BUErrorCodeAppEmpty         = 40002,    // request app can't be empty
//BUErrorCodeWapEMpty         = 40003,    // request wap can't be empty
//BUErrorCodeAdSlotEmpty      = 40004,    // missing ad slot description
//BUErrorCodeAdSlotSizeEmpty  = 40005,    // the ad slot size is invalid
//BUErrorCodeAdSlotIDError    = 40006,    // the ad slot ID is invalid
//BUErrorCodeAdCountError     = 40007,    // request the wrong number of ads
//BUUnionAdImageSizeError     = 40008,    // wrong image size
//BUUnionAdSiteIdError        = 40009,    // Media ID is illegal
//BUUnionAdSiteMeiaTypeError  = 40010,    // Media type is illegal
//BUUnionAdSiteAdTypeError    = 40011,    // Ad type is illegal
//BUUnionAdSiteAccessMethodError  = 40012,// Media access type is illegal and has been deprecated
//BUUnionSplashAdTypeError    = 40013,    // Code bit id is less than 900 million, but adType is not splash ad
//BUUnionRedirectError        = 40014,    // The redirect parameter is incorrect
//BUUnionRequestInvalidError  = 40015,    // Media rectification exceeds deadline, request illegal
//BUUnionAppSiteRelError      = 40016,    // The relationship between slot_id and app_id is invalid.
//BUUnionAccessMethodError    = 40017,    // Media access type is not legal API/SDK
//BUUnionPackageNameError     = 40018,    // Media package name is inconsistent with entry
//BUUnionConfigurationError   = 40019,    // Media configuration ad type is inconsistent with request
//BUUnionRequestLimitError    = 40020,    // The ad space registered by developers exceeds daily request limit
//BUUnionSignatureError       = 40021,    // Apk signature sha1 value is inconsistent with media platform entry
//BUUnionIncompleteError      = 40022,    // Whether the media request material is inconsistent with the media platform entry
//BUUnionOSError              = 40023,    // The OS field is incorrectly filled
//BUUnionLowVersion           = 40024,    // The SDK version is too low to return ads
//BUErrorCodeAdPackageIncomplete  = 40025,// the SDK package is incomplete. It is recommended to verify the integrity of SDK package or contact technical support.
//BUUnionMedialCheckError     = 40026,    // Non-international account request for overseas delivery system
//
//BUErrorCodeSysError         = 50001     // ad server error
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"-6"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native template is invalid"];
    }else if ([code isEqualToString:@"-5"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native template addation is invalid"];
    }else if ([code isEqualToString:@"-4"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"failed to open appstore"];
    }else if ([code isEqualToString:@"-3"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"parsed data has no ads"];
    }else if ([code isEqualToString:@"-2"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"network request failed"];
    }else if ([code isEqualToString:@"-1"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"parsing failed"];
    }else if ([code isEqualToString:@"101"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, render result parse fail"];
    }else if ([code isEqualToString:@"102"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, template is invalid"];
    }else if ([code isEqualToString:@"103"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, template plugin is invalid"];
    }else if ([code isEqualToString:@"104"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, data is invalid"];
    }else if ([code isEqualToString:@"105"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, parse fail"];
    }else if ([code isEqualToString:@"106"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, render fail"];
    }else if ([code isEqualToString:@"107"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"native Express ad, render timeout"];
    }else if ([code isEqualToString:@"1000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"SDK stop forcely"];
    }else if ([code isEqualToString:@"10001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"parameter error"];
    }else if ([code isEqualToString:@"10002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@""];
    }else if ([code isEqualToString:@"20000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@""];
    }else if ([code isEqualToString:@"20001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"no ads"];
    }else if ([code isEqualToString:@"40000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"http conent_type error"];
    }else if ([code isEqualToString:@"40001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"http request pb error"];
    }else if ([code isEqualToString:@"40002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"request app can't be empty"];
    }else if ([code isEqualToString:@"40003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"request wap can't be empty"];
    }else if ([code isEqualToString:@"40004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"missing ad slot description"];
    }else if ([code isEqualToString:@"40005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"the ad slot size is invalid"];
    }else if ([code isEqualToString:@"40006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"the ad slot ID is invalid"];
    }else if ([code isEqualToString:@"40007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"request the wrong number of ads"];
    }else if ([code isEqualToString:@"40008"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"wrong image size"];
    }else if ([code isEqualToString:@"40009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media ID is illegal"];
    }else if ([code isEqualToString:@"40010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media type is illegal"];
    }else if ([code isEqualToString:@"40011"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Ad type is illegal"];
    }else if ([code isEqualToString:@"40012"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media access type is illegal and has been deprecated"];
    }else if ([code isEqualToString:@"40013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Code bit id is less than 900 million, but adType is not splash ad"];
    }else if ([code isEqualToString:@"40014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"The redirect parameter is incorrect"];
    }else if ([code isEqualToString:@"40015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media rectification exceeds deadline, request illegal"];
    }else if ([code isEqualToString:@"40016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"The relationship between slot_id and app_id is invalid."];
    }else if ([code isEqualToString:@"40017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media access type is not legal API/SDK"];
    }else if ([code isEqualToString:@"40018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media package name is inconsistent with entry"];
    }else if ([code isEqualToString:@"40019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Media configuration ad type is inconsistent with request"];
    }else if ([code isEqualToString:@"40020"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"The ad space registered by developers exceeds daily request limit"];
    }else if ([code isEqualToString:@"40021"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Apk signature sha1 value is inconsistent with media platform entry"];
    }else if ([code isEqualToString:@"40022"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Whether the media request material is inconsistent with the media platform entry"];
    }else if ([code isEqualToString:@"40023"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"The OS field is incorrectly filled"];
    }else if ([code isEqualToString:@"40024"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"The SDK version is too low to return ads"];
    }else if ([code isEqualToString:@"40025"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"the SDK package is incomplete. It is recommended to verify the integrity of SDK package or contact technical support."];
    }else if ([code isEqualToString:@"40026"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"Non-international account request for overseas delivery system"];
    }else if ([code isEqualToString:@"50001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"ad server error"];
    }
    return errorMsg;
}



@end

