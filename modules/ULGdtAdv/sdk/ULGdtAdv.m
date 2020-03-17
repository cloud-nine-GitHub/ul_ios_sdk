//
//  ULGdtAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/4.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//


#import "ULGdtAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"
#import "GDTSDKConfig.h"
#import "GDTSplashAd.h"
#import "GDTUnifiedInterstitialAd.h"
#import "GDTRewardVideoAd.h"

@interface ULGdtAdv ()<GDTSplashAdDelegate,GDTUnifiedInterstitialAdDelegate,GDTRewardedVideoAdDelegate>

@property (nonatomic, strong)NSDictionary *splashJson,*videoJson,*interJson,*fullscreenJson;



//必须以属性的形式声明，否则无回调
@property (nonatomic, strong)GDTSplashAd *splashAd;
@property (nonatomic, strong)GDTUnifiedInterstitialAd *interstitialAd;
@property (nonatomic, strong)GDTRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong)GDTUnifiedInterstitialAd *fullscreenAd;

@property (nonatomic, strong)NSString *splashId,*interId,*fullscreenId,*videoId;
@property (nonatomic, assign)BOOL isVideoPlayComplete,isSplashClicked,isInterClicked,isFullscreenClicked,isVideoClicked;
@end


@implementation ULGdtAdv

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
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_GDT_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_GDT_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_GDT_FULLSCREEN_ADV withSelector:@selector(onShowFullscreenAdv:) withPriority:PRIORITY_NONE];
}



- (void)onShowVideoAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showVideoAdv:data];
}

- (void)onShowInterAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showInterstitialAdv:data];
}

- (void)onShowFullscreenAdv:(NSNotification *)notification
{
    NSDictionary *data = notification.userInfo[@"data"];
    ULNotification *n = notification.userInfo[@"notification"];
    [n stopDispatchNotification];
    [self showFullscreenAdv:data];
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

- (void)initModuleAdv
{
    NSLog(@"%s",__func__);

    [self addListener];
    
    NSLog(@"%s:当前sdk版本 = %@",__func__,GDTSDKConfig.sdkVersion);
    [GDTSDKConfig enableGPS:YES]; // 获取用户的GPS信息，默认值为NO
    [GDTSDKConfig setChannel:14];//设置渠道号,有助提升收益

    
}







- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_BANNER,UL_ADV_EMBEDDED]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _splashJson = json;
    _isSplashClicked = NO;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_splashid" withDefaultParam:@"" withSplitString:@"|"];
    _splashId = splashId;
    NSString *appid = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_gdt_appid" :@""];
    _splashAd = [[GDTSplashAd alloc] initWithAppId:appid placementId:splashId];
    _splashAd.delegate = self; //设置代理
    _splashAd.fetchDelay = 3; //开发者可以设置开屏拉取时间，超时则放弃展示
    //［可选］拉取并展示全屏开屏广告
    [_splashAd loadAdAndShowInWindow:[ULTools getAppCurrentWindow]];
    
}



- (void)showInterstitialAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _interJson = json;
    _isInterClicked = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_interid" withDefaultParam:@"" withSplitString:@"|"];
    _interId = interId;
    NSString *appid = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_gdt_appid" :@""];
    _interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithAppId:appid placementId:interId];
    _interstitialAd.delegate = self;
    _interstitialAd.videoMuted = NO; // 设置视频是否Mute
    _interstitialAd.videoAutoPlayOnWWAN = NO; // 设置视频是否在非 WiFi 网络自动播放
    //interstitialAd.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置
    
    [_interstitialAd loadAd];
    
    
}


- (void)showVideoAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    
    _videoJson = json;
    _isVideoPlayComplete = NO;
    _isVideoClicked = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_videoid" withDefaultParam:@"" withSplitString:@"|"];
    _videoId = videoId;
    NSString *appid = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_gdt_appid" :@""];
    _rewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:appid placementId:videoId];
    _rewardVideoAd.delegate = self;
    _rewardVideoAd.videoMuted = NO; // 设置激励视频是否静音
    [_rewardVideoAd loadAd];
}




- (void)showFullscreenAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _fullscreenJson = json;
    _isFullscreenClicked = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *fullscreenId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_gdt_fullscreenid" withDefaultParam:@"" withSplitString:@"|"];
    _fullscreenId = fullscreenId;
    NSString *appid = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_gdt_appid" :@""];
    _fullscreenAd = [[GDTUnifiedInterstitialAd alloc] initWithAppId:appid placementId:fullscreenId];
    _fullscreenAd.delegate = self;
    _fullscreenAd.videoMuted = NO; // 设置自动播放时是否静音
    [_fullscreenAd loadFullScreenAd]; // 加载插屏2.0全屏视频广告
}

- (void)showBannerAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showUrlAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showEmbeddedAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showGiftAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)showIconAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}
- (void)closeAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}



#pragma mark - GDTSplashAdDelegate
/**
 *  开屏广告成功展示
 */
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
    [self showAdv:_splashJson :_splashId];
}

/**
 *  开屏广告素材加载成功
 */
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    _splashAd.delegate = nil;
    _splashAd = nil;
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
    [self showNextAdv:_splashJson :_splashId :errorMsg];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  开屏广告曝光回调
 */
- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
    if (!_isSplashClicked) {
        _isSplashClicked = YES;
        [self showClicked:_splashJson :_splashId];
    }
    
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
    _splashAd.delegate = nil;
    _splashAd = nil;
    [[ULSplashViewController getInstance] removeSplashView];
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__func__);
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time
{
    //NSLog(@"%s",__func__,time);
}


#pragma mark - GDTUnifiedInterstitialAdDelegate
/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功且预加载后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
    NSString *placementId = unifiedInterstitial.placementId;
    if ([placementId isEqualToString:_interId]) {//插屏回调
        [unifiedInterstitial presentAdFromRootViewController:[ULTools getCurrentViewController]];
    }else if([placementId isEqualToString:_fullscreenId]){//全屏视频回调
        [unifiedInterstitial presentFullScreenAdFromRootViewController:[ULTools getCurrentViewController]]; // 展示插屏2.0全屏视频广告
    }
    
    
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_GDT_ADV_CALLBACK withData:errorMsg];
    NSString *placementId = unifiedInterstitial.placementId;
    if ([placementId isEqualToString:_interId]) {//插屏回调
        [self showNextAdv:_interJson :placementId :errorMsg];
    }else if([placementId isEqualToString:_fullscreenId]){//全屏视频回调
        [self showNextAdv:_fullscreenJson :placementId :errorMsg];
    }
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
    NSString *placementId = unifiedInterstitial.placementId;
    [self pauseSound];
    if ([placementId isEqualToString:_interId]) {//插屏回调
        [self showAdv:_interJson :placementId];
    }else if([placementId isEqualToString:_fullscreenId]){//全屏视频回调
        [self showAdv:_fullscreenJson :placementId];
    }
}

/**
 *  插屏2.0广告视图展示失败回调
 *  插屏2.0广告展示失败回调该函数
 */
- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    [self resumeSound];
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_GDT_ADV_CALLBACK withData:errorMsg];
    NSString *placementId = unifiedInterstitial.placementId;
    if ([placementId isEqualToString:_interId]) {//插屏回调
        [self showNextAdv:_interJson :placementId :errorMsg];
    }else if([placementId isEqualToString:_fullscreenId]){//全屏视频回调
        [self showNextAdv:_fullscreenJson :placementId :errorMsg];
    }
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
    [self resumeSound];
}

/**
 *  当点击下载应用时会调用系统程序打开其它App或者Appstore时回调
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
    NSString *placementId = unifiedInterstitial.placementId;
    if ([placementId isEqualToString:_interId]) {//插屏回调
        if (!_isInterClicked) {
            _isInterClicked = YES;
            [self showClicked:_interJson :placementId];
        }
        
    }else if([placementId isEqualToString:_fullscreenId]){//全屏视频回调
        if (!_isFullscreenClicked) {
            _isFullscreenClicked = YES;
            [self showClicked:_fullscreenJson :placementId];
        }
        
    }
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"%s",__func__);
}

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__func__);
}


#pragma mark - GDTRewardedVideoAdDelegate
/**
 广告数据加载成功回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
}

/**
 视频数据下载成功回调，已经下载过的视频会直接回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    if (rewardedVideoAd.isAdValid) {
        [rewardedVideoAd showAdFromRootViewController:[ULTools getCurrentViewController]];
    }
    
}

/**
 视频播放页即将展示回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    
}

/**
 视频广告曝光回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self showAdv:_videoJson :_videoId];
}

/**
 视频播放页关闭回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    if (_isVideoPlayComplete) {
        [self showClose:_videoJson :_videoId];
    }else{
        [self showFailed:_videoJson :_videoId :@"adv don't play complete"];
        [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_MC_SHOW_GDT_ADV_CALLBACK withData:@"adv don't play complete"];
    }
}

/**
 视频广告信息点击回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    if (!_isVideoClicked) {
        _isVideoClicked = YES;
        [self showClicked:_videoJson :_videoId];
    }
    
}

/**
 视频广告各种错误信息回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 @param error 具体错误信息
 */
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    [self resumeSound];
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
    [[ULNotificationDispatcher getInstance]postNotificationWithName:UL_NOTIFICATION_MC_SHOW_GDT_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_videoJson :_videoId :errorMsg];
}

/**
 视频广告播放达到激励条件回调
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
}

/**
 视频广告视频播放完成
 
 @param rewardedVideoAd GDTRewardVideoAd 实例
 */
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__func__);
    _isVideoPlayComplete = YES;
}



- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
    //3001    网络错误
    //3003    手机无网络
    //4001    初始化错误, 包括广告位为空、AppKey为空、ViewController
    //为空
    //4003    广告位错误
    //4006    广告未曝光
    //4007    设备不支持
    //4008    设备方向不支持
    //4009    开屏跳过按钮定义非法
    //4010    开屏bottomView设置非法
    //4011    请求广告超时
    //4013    系统不支持，原生视频模板广告只支持 iOS 9 及以上系统
    //4014    广告数据返回前尝试展示广告, 例如激励视频拉到广告后才可以调用展示接口
    //4015    广告已经曝光过，不允许二次展示，请重新拉取
    //4016    应用横竖方向与广告位支持方向不匹配
    //4017    外部传入的VC无效
    //4018    缓存文件在流程中被意外删除
    //4019    开屏广告 rootViewController presentVC 被占用
    //5001    后台数据错误
    //5002    视频素材下载错误
    //5003    视频素材播放错误
    //5004    没匹配的广告，禁止重试，否则影响流量变现效果
    //5005    广告请求量或者消耗等超过日限额，请第二天再请求广告
    //5006    包名校验非法
    //5009    广告请求量或者消耗等超过小时限额，请一小时后再请求广告
    //5010    广告样式校验失败，请检查广告位与接口使用是否一致
    //5012    广告过期，请重新拉取
    //5013    广告拉取过于频繁，请稍后再试
    //5014    视频广告视频和图片素材都下载错误
    //5015    当前版本不出广告
    //5016    JSON数据解析失败
    //5017    adCount参数非法
    //5018    广告位下线
    //5019    视频时长超过设定时长
    //5020    视频URL为空
    //5021    广告已下线
    //5022    VAST接入错误
    //5024    接口组合错误
    //6000    未知错误，联系腾讯广告商务同事协助排查
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"3001"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"网络错误"];
    }else if ([code isEqualToString:@"3003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"手机无网络"];
    }else if ([code isEqualToString:@"4001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"初始化错误, 包括广告位为空、AppKey为空、ViewController为空"];
    }else if ([code isEqualToString:@"4003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位错误"];
    }else if ([code isEqualToString:@"4006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告未曝光"];
    }else if ([code isEqualToString:@"4007"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"设备不支持"];
    }else if ([code isEqualToString:@"4008"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"设备方向不支持"];
    }else if ([code isEqualToString:@"4009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏跳过按钮定义非法"];
    }else if ([code isEqualToString:@"4010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏bottomView设置非法"];
    }else if ([code isEqualToString:@"4011"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求广告超时"];
    }else if ([code isEqualToString:@"4013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"系统不支持，原生视频模板广告只支持 iOS 9 及以上系统"];
    }else if ([code isEqualToString:@"4014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告数据返回前尝试展示广告, 例如激励视频拉到广告后才可以调用展示接口"];
    }else if ([code isEqualToString:@"4015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告已经曝光过，不允许二次展示，请重新拉取"];
    }else if ([code isEqualToString:@"4016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"应用横竖方向与广告位支持方向不匹配"];
    }else if ([code isEqualToString:@"4017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"外部传入的VC无效"];
    }else if ([code isEqualToString:@"4018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缓存文件在流程中被意外删除"];
    }else if ([code isEqualToString:@"4019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏广告 rootViewController presentVC 被占用"];
    }else if ([code isEqualToString:@"5001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"后台数据错误"];
    }else if ([code isEqualToString:@"5002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频素材下载错误"];
    }else if ([code isEqualToString:@"5003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频素材播放错误"];
    }else if ([code isEqualToString:@"5004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没匹配的广告，禁止重试，否则影响流量变现效果"];
    }else if ([code isEqualToString:@"5005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告请求量或者消耗等超过日限额，请第二天再请求广告"];
    }else if ([code isEqualToString:@"5006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"包名校验非法"];
    }else if ([code isEqualToString:@"5009"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告请求量或者消耗等超过小时限额，请一小时后再请求广告"];
    }else if ([code isEqualToString:@"5010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告样式校验失败，请检查广告位与接口使用是否一致"];
    }else if ([code isEqualToString:@"5012"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告过期，请重新拉取"];
    }else if ([code isEqualToString:@"5013"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告拉取过于频繁，请稍后再试"];
    }else if ([code isEqualToString:@"5014"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频广告视频和图片素材都下载错误"];
    }else if ([code isEqualToString:@"5015"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"当前版本不出广告"];
    }else if ([code isEqualToString:@"5016"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"JSON数据解析失败"];
    }else if ([code isEqualToString:@"5017"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"adCount参数非法"];
    }else if ([code isEqualToString:@"5018"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位下线"];
    }else if ([code isEqualToString:@"5019"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频时长超过设定时长"];
    }else if ([code isEqualToString:@"5020"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"视频URL为空"];
    }else if ([code isEqualToString:@"5021"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告已下线"];
    }else if ([code isEqualToString:@"5022"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"VAST接入错误"];
    }else if ([code isEqualToString:@"5024"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"接口组合错误"];
    }else if ([code isEqualToString:@"6000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"未知错误，联系腾讯广告商务同事协助排查"];
    }
    
    return errorMsg;
}


@end
