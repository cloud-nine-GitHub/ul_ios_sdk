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
@end

@implementation ULToutiaoAdv





- (void)onInitModule
{
    NSLog(@"%s",__func__);
    //获取banner的轮播时间间隔，单位s
    NSString *bannerRefreshTimeStr = [ULTools getCopOrConfigStringWithKey:@"s_sdk_adv_toutiao_banner_refresh_time" withDefaultString:@""];
    if (bannerRefreshTimeStr != nil && ![bannerRefreshTimeStr isEqualToString:@""]) {
        try {
            _bannerRefreshTime = [bannerRefreshTimeStr intValue];
        } catch (NSException *e) {//配置的非法字符
            _bannerRefreshTime = 30;
        }
        
    }else{//默认值
        _bannerRefreshTime = 30;
    }
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



- (void)initModuleAdv
{
    NSLog(@"%s",__func__);
    [self addListener];
    //初始化sdk
    NSString *appId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_toutiao_appid" :@""];
    [BUAdSDKManager setAppID:appId];
    [BUAdSDKManager setIsPaidApp:NO];
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelNone];
}

- (void)onConstructorAdv
{
    
    NSLog(@"%s",__func__);
    [self setDisableAdvPriority:UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_EMBEDDED];
}


- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _splashJson = json;
    [self showNormalSplashAdv:json];
}

//普通开屏
- (void)showNormalSplashAdv : (NSDictionary *)json
{
    NSDictionary *gameAdvData = [ULTools GetNSDictionaryFromDic:json :@"gameAdvData" :nil];
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilitys" :nil];
    _splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_splashid" withDefaultParam:@"" withSplitString:@"|"];
    
    
    CGRect frame = [UIScreen mainScreen].bounds;
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:splashId frame:frame];
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
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilitys" :nil];
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

    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilitys" :nil];
    _interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_interid" withDefaultParam:@"" withSplitString:@"|"];
    self.expressInterAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:_interId adSize:CGSizeMake(300, 300)];
    self.expressInterAd.delegate = self;
    [self.expressInterAd loadAdData];
    
}

- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    //视频
    BURewardedVideoModel *videoModel = [[BURewardedVideoModel alloc] init];
    
    videoModel.userId = @"123";
    NSDictionary *advConfigDic = [CommonTool::getInstance()->getConfigJson() objectForKey:@"advConfig"];
    NSString *videoId = CommonTool::getInstance()->getRandomParamBySplit(CommonTool::getInstance()->getCopOrConfigString(@"csjVideoId", [CommonAppDelegate getInstance]->copConfig, CommonTool::getInstance()->d2j(advConfigDic), @""), @"|");
    self.expressRewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:videoId rewardedVideoModel:videoModel];
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

    
    NSDictionary *advConfigDic = [CommonTool::getInstance()->getConfigJson() objectForKey:@"advConfig"];
    NSString *fullVideoId = CommonTool::getInstance()->getRandomParamBySplit(CommonTool::getInstance()->getCopOrConfigString(@"csjFullScreenVidedoId", [CommonAppDelegate getInstance]->copConfig, CommonTool::getInstance()->d2j(advConfigDic), @""), @"|");
    self.expressFullscreenVideoAd = [[BUNativeExpressFullscreenVideoAd alloc] initWithSlotID: fullVideoId];
    self.expressFullscreenVideoAd.delegate = self;
    [self.expressFullscreenVideoAd loadAdData];
    
}

- (void)showBannerAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    //banner素材的宽高
    BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_100];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat bannerHeight = screenSize.width * size.height / size.width;
    
    CGFloat bannerY = screenSize.height - bannerHeight;
    
    
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilitys" :nil];
    _bannerId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_toutiao_bannerid" withDefaultParam:@"" withSplitString:@"|"];
    
    self.expressBannerAd = [[BUNativeExpressBannerView alloc] initWithSlotID:_bannerId rootViewController:[ULTools getCurrentViewController] adSize:CGSizeMake(screenSize.width, bannerHeight) IsSupportDeepLink:YES interval:_bannerRefreshTime];
    
    
    self.expressBannerAd.frame = CGRectMake(0, bannerY, screenSize.width, bannerHeight);
    self.expressBannerAd.delegate = self;
    [[ULTools getCurrentViewController].view addSubview:self.expressBannerAd];
    
    [self.expressBannerAd loadAdData];
    
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
    NSString *errorMsg = [[NSString alloc]initWithString:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%d",error.code],@"; errorMsg = ",error.localizedFailureReason];
    [splashAd removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg]
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
    [self showClicked:_splashJson :_splashId];
}

/**
This method is called when splash ad is closed.
*/
- (void)splashAdDidClose:(BUSplashAdView *)splashAd
{
    NSLog(@"%s",__func__);
    [splashAd removeFromSuperview];
    [[ULSplashViewController getInstance]removeSplashView];
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







#pragma mark - express splash delegate
- (void)nativeExpressSplashViewDidLoad:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);

}

- (void)nativeExpressSplashView:(nonnull BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [[NSString alloc]initWithString:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%d",error.code],@"; errorMsg = ",error.localizedFailureReason];
    [splashAdView removeSplashView];
    [splashAdView removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg]
}


- (void)nativeExpressSplashViewRenderSuccess:(nonnull BUNativeExpressSplashView *)splashAdView {
    NSLog(@"%s",__func__);
    [self showAdv:_splashJson :_splashId];
}

- (void)nativeExpressSplashViewRenderFail:(nonnull BUNativeExpressSplashView *)splashAdView error:(NSError * _Nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [[NSString alloc]initWithString:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%d",error.code],@"; errorMsg = ",error.localizedFailureReason];
    [splashAdView removeSplashView];
    [splashAdView removeFromSuperview];
    [self showNextAdv:_splashJson :_splashId :errorMsg]
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


#pragma mark - inter delegate
- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {

    NSLog(@"%s",__func__);
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *__nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [[NSString alloc]initWithString:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%d",error.code],@"; errorMsg = ",error.localizedFailureReason];
    [self showNextAdv:_interJson :_interId :errorMsg];
    
}



- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"%s",__func__);
    if (self.expressInterAd.isAdValid) {
        [self.expressInterAd showAdFromRootViewController:[ULTools getCurrentViewController]];
    }else{
        NSLog(@"%s%@",__func__,@"express inter not ready");
        [self showNextAdv:_interJson :_interId :@"express inter not ready"];
    }
}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *__nullable)error {
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [[NSString alloc]initWithString:@"%@%@%@%@",@"errorCode = ",[NSString stringWithFormat:@"%d",error.code],@"; errorMsg = ",error.localizedFailureReason];
    [self showNextAdv:_interJson :_interId :@"express inter not ready"];

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
#if (CDSC_ENABLE_ADVSET_IN_HOST)
    [[CommonAdvSet getInstance]showRewardVideoNext];
#else
    [[CommonAdvMgr getInstance]advShowResult:@"0" msg:@"Show Video adv failed" advType:UL_VIDEO];
#endif

}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    
    if (self.expressRewardedVideoAd.isAdValid) {
        // The reward based video ad is available, present the ad.
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        // 物料有效 数据不为空且没有展示过为 YES, 重复展示不计费.
        [self.expressRewardedVideoAd showAdFromRootViewController:controller];
    } else {
#if (CDSC_ENABLE_ADVSET_IN_HOST)
        [[CommonAdvSet getInstance]showRewardVideoNext];
#else
        [[CommonAdvMgr getInstance]advShowResult:@"0" msg:@"Show Video adv failed" advType:UL_VIDEO];
#endif
    }
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    NSLog(@"%s%@",__func__,error);
#if (CDSC_ENABLE_ADVSET_IN_HOST)
    [[CommonAdvSet getInstance]showRewardVideoNext];
#else
    [[CommonAdvMgr getInstance]advShowResult:@"0" msg:@"Show Video adv failed" advType:UL_VIDEO];
#endif
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    resultDict[@"cmd"] = UL_PAUSE_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
    [[CommonAdvMgr getInstance]advShowResult:@"7" msg:@" adv ready show" advType:UL_VIDEO];
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    [[CommonAdvMgr getInstance]advShowResult:@"4" msg:@" adv start show" advType:UL_VIDEO];
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    resultDict[@"cmd"] = UL_RESUME_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
    [[CommonAdvMgr getInstance]advShowResult:@"1" msg:@" adv show success" advType:UL_VIDEO];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    [[CommonAdvMgr getInstance]advShowResult:@"5" msg:@" adv show click" advType:UL_VIDEO];
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    resultDict[@"cmd"] = UL_RESUME_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"%s%@",__func__,error);
    if (error) {
        NSLog(@"nativeExpressRewardedVideoAd play error");
    } else {
        NSLog(@"nativeExpressRewardedVideoAd play finish");
    }
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
#if (CDSC_ENABLE_ADVSET_IN_HOST)
    [[CommonAdvSet getInstance]showInterstitiaAdvNext];
#else
    [[CommonAdvMgr getInstance]advShowResult:@"0" msg:@"Show full video adv failed" advType:UL_INTERSTITIAL];
#endif

}

- (void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd{
    NSLog(@"%s",__func__);
    
    [self showNativeExpressFullScreenAdv];
}

- (void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{

    NSLog(@"%s%@",__func__,error);
#if (CDSC_ENABLE_ADVSET_IN_HOST)
    [[CommonAdvSet getInstance]showInterstitiaAdvNext];
#else
    [[CommonAdvMgr getInstance]advShowResult:@"0" msg:@"Show full video adv failed" advType:UL_INTERSTITIAL];
#endif

}

- (void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{

    NSLog(@"%s",__func__);

    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    resultDict[@"cmd"] = UL_PAUSE_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
    [[CommonAdvMgr getInstance]advShowResult:@"1" msg:@" adv show success" advType:UL_INTERSTITIAL];
}

- (void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{

    NSLog(@"%s",__func__);

    [[CommonAdvMgr getInstance]advShowResult:@"4" msg:@" adv start show" advType:UL_INTERSTITIAL];
}

- (void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{

    NSLog(@"%s",__func__);

    [[CommonAdvMgr getInstance]advShowResult:@"5" msg:@"show banner adv clicked" advType:UL_INTERSTITIAL];
}

- (void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    resultDict[@"cmd"] = UL_RESUME_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
}

- (void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    NSLog(@"%s",__func__);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    resultDict[@"cmd"] = UL_RESUME_SOUND;
    resultDict[@"data"] = {};
    NSString *resultStr = CommonTool::getInstance()->d2j(resultDict);
    [[MessageMgr getInstance] sendMsgToGame:resultStr];
    
    [[CommonAdvMgr getInstance]advShowResult:@"6" msg:@"Show Interstitial Adv close" advType:UL_INTERSTITIAL];
}

- (void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *_Nullable)error{
    NSLog(@"%s%@",__func__,error);
    if (error) {
        NSLog(@"nativeExpressFullscreenVideoAdDidPlayFinish play error");
    } else {
        NSLog(@"nativeExpressFullscreenVideoAdDidPlayFinish play finish");
    }
}


@end

