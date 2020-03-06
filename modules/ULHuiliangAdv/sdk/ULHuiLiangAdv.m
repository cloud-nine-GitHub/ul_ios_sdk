//
//  ULHuiLiangAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/4.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

/**
 
 注：汇量原本会在加载失败时自动帮我们进行下次加载，目前是要对方关闭了自动加载的功能，有我们自行进行加载逻辑处理
 
 */
#import "ULHuiLiangAdv.h"
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"
#import "MTGSDK/MTGSDK.h"
#import <MTGSDKInterstitial/MTGInterstitialAdManager.h>
#import <MTGSDKReward/MTGRewardAdManager.h>
#import <MTGSDKInterstitialVideo/MTGInterstitialVideoAdManager.h>

@interface ULHuiLiangAdv ()<MTGInterstitialAdLoadDelegate,MTGInterstitialAdShowDelegate,MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate,MTGInterstitialVideoDelegate>

@property (nonatomic, strong)NSDictionary *interJson,*videoJson,*fullscreenJson;
@property (nonatomic, strong)NSString *videoLoadFailMsg,*fullscreenLoadFailMsg;
@property (nonatomic, assign)BOOL isVideoPlayCompleted;
@property (nonatomic, strong)MTGInterstitialAdManager *interstitialAdManager;
//TODO
@property (nonatomic, strong)NSMutableDictionary *advLoadObjByParamDic;
@end


@implementation ULHuiLiangAdv

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
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_HUILIANG_INTER_ADV withSelector:@selector(onShowInterAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_HUILIANG_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_HUILIANG_FULLSCREEN_ADV withSelector:@selector(onShowFullscreenAdv:) withPriority:PRIORITY_NONE];
    
    
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
    _videoLoadFailMsg = @"";
    _fullscreenLoadFailMsg = @"";
    [self addListener];
    
    NSString *appId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_huiliang_appid" :@""];
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_huiliang_appkey" :@""];
    
    [[MTGSDK sharedInstance] setAppID:appId ApiKey:appKey];
    
    
    //对于预加载的情况还是尽量避免，因为是聚合原因，那么应用启动进行过多预加载还是会影响
    //初始化视频单例
    //[MTGRewardAdManager sharedInstance];
    
    _advLoadObjByParamDic = [NSMutableDictionary new];
    //获取本地配置的参数
    NSString *videoParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_huiliang_videoid" :@""];
    NSArray *localVideoParams = [videoParamsStr componentsSeparatedByString:@"|"];
    NSArray *videoParamsArray = [self getParamArrayWithModule:@"ULHuiLiangAdv" withType:@"video" withDefaultValue:localVideoParams];
    //这里需要参数去重，避免重复加载
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString * str in videoParamsArray) {
        if (![dict objectForKey:str]) {
            [dict setValue:str forKey:str];
        }
        
    }
    NSMutableArray * arr2 = [NSMutableArray new];
    for (NSString *value in [dict allValues]) {
        [arr2 addObject:value];
    }
    for (NSString *param in arr2) {
        //激励视频广告对象为单利，那么只需根据每个参数来进行加载
        //加载下一次视频(已让对方关闭自动加载)
        [[MTGRewardAdManager sharedInstance] loadVideo:param delegate:self];
        
    }
    
    NSString *fullscreenParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_huiliang_fullscreenid" :@""];
    NSArray *localFullscreenParams = [fullscreenParamsStr componentsSeparatedByString:@"|"];
    NSArray *fullscreenParamsArray = [self getParamArrayWithModule:@"ULHuiLiangAdv" withType:@"fullscreen" withDefaultValue:localFullscreenParams];
    for (NSString *param in fullscreenParamsArray) {
        //应该有个参数和广告对象存储的map
        if (![_advLoadObjByParamDic objectForKey:param]) {//该参数已创建对象则无需再次创建
            MTGInterstitialVideoAdManager *ivAdManager = [[MTGInterstitialVideoAdManager alloc] initWithUnitID:param delegate:self];
            [_advLoadObjByParamDic setValue:ivAdManager forKey:param];
            //预加载广告
            [ivAdManager loadAd];
        }
        
        
        //可以继续封装，不一只一个模块存在预加载的情况
    }
    
}







- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_SPLAH,UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_BANNER,UL_ADV_EMBEDDED]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
}



- (void)showInterstitialAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    _interJson = json;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *interId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_huiliang_interid" withDefaultParam:@"" withSplitString:@"|"];
    //必须用到全局变量，否则会导致回调异常
    _interstitialAdManager = [[MTGInterstitialAdManager alloc] initWithUnitID:interId adCategory:0];
    [_interstitialAdManager loadWithDelegate:self];
}


- (void)showVideoAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
    _videoJson = json;
    _isVideoPlayCompleted = NO;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_huiliang_videoid" withDefaultParam:@"" withSplitString:@"|"];
    
    if ([[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:videoId]) {
        
        [[MTGRewardAdManager sharedInstance] showVideo:videoId withRewardId:@"1" userId:[ULGetDeviceId getUniqueDeviceId] delegate:self viewController:[ULTools getCurrentViewController]];
        
    }
    else {
        //We will help you to load automatically when isReady is NO
        //调用广告对象的load函数为下次加载
        NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:_videoLoadFailMsg];
        [self showNextAdv:json :videoId :_videoLoadFailMsg];
        //加载下一次视频(已让对方关闭自动加载)
        [[MTGRewardAdManager sharedInstance] loadVideo:videoId delegate:self];
    }
    
    
    
    
    
}




- (void)showFullscreenAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    _fullscreenJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *fullscreenId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_huiliang_fullscreenid" withDefaultParam:@"" withSplitString:@"|"];
    
    //获取该参数对应已创建的广告对象
    id ivAdManager = [_advLoadObjByParamDic objectForKey:fullscreenId];
    if (ivAdManager) {
        BOOL isReady = [ivAdManager isVideoReadyToPlay:fullscreenId];
        if (isReady) {
            //调用广告对象的show函数
            [ivAdManager showFromViewController:[ULTools getCurrentViewController]];
            
        }else {
            //调用广告对象的load函数为下次加载
            NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
            [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:_fullscreenLoadFailMsg];
            [self showNextAdv:json :fullscreenId :_fullscreenLoadFailMsg];
            //加载
            [ivAdManager loadAd];
        }
    }else{
        //创建请求对象
        MTGInterstitialVideoAdManager *mIvAdManager = [[MTGInterstitialVideoAdManager alloc] initWithUnitID:fullscreenId delegate:self];
        [_advLoadObjByParamDic setValue:mIvAdManager forKey:fullscreenId];
        NSLog(@"%s,%@%@",__func__,fullscreenId,@"对应的广告请求对象不存在");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:@"adv obj not exist"];
        [self showNextAdv:json :fullscreenId :@"adv obj not exist"];
        //加载
        [mIvAdManager loadAd];
    }
    
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



#pragma mark - MTGInterstitialAdLoadDelegate

/**
 *  Sent when the ad is successfully load , and is ready to be displayed
 */

- (void) onInterstitialLoadSuccess:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [_interstitialAdManager showWithDelegate:self presentingViewController:[ULTools getCurrentViewController]];
}

/**
 *  Sent when there was an error loading the ad.
 *
 *  @param error An NSError object with information about the failure.
 */

- (void) onInterstitialLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_interJson :adManager.currentUnitId :errorMsg];
}


#pragma mark - MTGInterstitialAdShowDelegate
/**
 *  Sent when the Interstitial success to open
 */

- (void) onInterstitialShowSuccess:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [self showAdv:_interJson :adManager.currentUnitId];
}

/**
 *  Sent when the Interstitial failed to open for some reason
 *
 *  @param error An NSError object with information about the failure.
 */

- (void) onInterstitialShowFail:(nonnull NSError *)error adManager:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_interJson :adManager.currentUnitId :errorMsg];
}


/**
 *  Sent when the Interstitial has been clesed from being open, and control will return to your app
 */

- (void) onInterstitialClosed:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}


/**
 *  Sent after the Interstitial has been clicked by a user.
 */
- (void) onInterstitialAdClick:(MTGInterstitialAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [self showClicked:_interJson :adManager.currentUnitId];
}


#pragma mark - MTGRewardAdLoadDelegate
/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load video
 completely
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onAdLoadSuccess:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 *
 *  @param unitId - the unitId string of the Ad that was loaded.
 */
- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when there was an error loading the ad.
 *
 *  @param unitId      - the unitId string of the Ad that failed to load.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    _videoLoadFailMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
}



#pragma mark - MTGRewardAdShowDelegate

/**
 *  Called when the ad display success
 *
 *  @param unitId - the unitId string of the Ad that display success.
 */
- (void)onVideoAdShowSuccess:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    [self showAdv:_videoJson :unitId];
}

/**
 *  Called when the ad failed to display for some reason
 *
 *  @param unitId      - the unitId string of the Ad that failed to be displayed.
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error
{
    NSLog(@"%s%@",__func__,error);
    [self resumeSound];
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_videoJson :unitId :errorMsg];
    //加载下一次视频(已让对方关闭自动加载)
    [[MTGRewardAdManager sharedInstance] loadVideo:unitId delegate:self];
}

/**
 *  Called only when the ad has a video content, and called when the video play completed.
 *  @param unitId - the unitId string of the Ad that video play completed.
 */
- (void) onVideoPlayCompleted:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
    _isVideoPlayCompleted = YES;
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show.
 *  @param unitId - the unitId string of the Ad that endcard show.
 */
- (void) onVideoEndCardShowSuccess:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad is clicked
 *
 *  @param unitId - the unitId string of the Ad clicked.
 */
- (void)onVideoAdClicked:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
    [self showClicked:_videoJson :unitId];
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *
 *  @param unitId      - the unitId string of the Ad that has been dismissed
 *  @param converted   - BOOL describing whether the ad has converted
 *  @param rewardInfo  - the rewardInfo object containing the info that should be given to your user.
 */
- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad  did closed;
 *
 *  @param unitId - the unitId string of the Ad that video play did closed.
 */
- (void)onVideoAdDidClosed:(nullable NSString *)unitId
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    
    if (_isVideoPlayCompleted) {
        [self showClose:_videoJson :unitId];
    }else{
        [self showFailed:_videoJson :unitId :@"adv not play complete"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:@"adv not play complete"];
    }
    //加载下一次视频(已让对方关闭自动加载)
    [[MTGRewardAdManager sharedInstance] loadVideo:unitId delegate:self];
}






#pragma mark - MTGInterstitialVideoDelegate




/**
 *  Called when the ad is loaded , but not ready to be displayed,need to wait load video
 completely
 */
- (void)onInterstitialAdLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad is successfully load , and is ready to be displayed
 */
- (void)onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when there was an error loading the ad.
 *  @param error       - error object that describes the exact error encountered when loading the ad.
 */
- (void)onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s%@",__func__,error);
    _fullscreenLoadFailMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
}


/**
 *  Called when the ad display success
 */
- (void)onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    [self showAdv:_fullscreenJson :adManager.currentUnitId];
}

/**
 *  Called when the ad failed to display for some reason
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void)onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s%@",__func__,error);
    [self resumeSound];
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_HUILIANG_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_fullscreenJson :adManager.currentUnitId :errorMsg];
    [[_advLoadObjByParamDic objectForKey:adManager.currentUnitId] loadAd];
}

/**
 *  Called only when the ad has a video content, and called when the video play completed
 */
- (void)onInterstitialVideoPlayCompleted:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}

/**
 *  Called only when the ad has a endcard content, and called when the endcard show
 */
- (void)onInterstitialVideoEndCardShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}


/**
 *  Called when the ad is clicked
 */
- (void)onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [self showClicked:_fullscreenJson :adManager.currentUnitId];
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}

/**
 *  Called when the ad  did closed;
 */
- (void)onInterstitialVideoAdDidClosed:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    //加载下一次插屏视频
    [[_advLoadObjByParamDic objectForKey:adManager.currentUnitId] loadAd];
}

/**
 *  If Interstitial Video  reward is set, you will receive this callback
 *  @param achieved  Whether the video played to required rate
 * @param alertWindowStatus  {@link MTGIVAlertWindowStatus} fro list of supported types
 NOTE:You can decide whether to give the reward based on that callback
 */
- (void)onInterstitialVideoAdPlayVideo:(BOOL)achieved alertWindowStatus:(MTGIVAlertWindowStatus)alertWindowStatus adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager
{
    NSLog(@"%s",__func__);
}



- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
    //    -1    EXCEPTION_RETURN_EMPTY    没有广告填充，可能导致的原因：1.您在测试期间所获取的广告均为Mintegral的正式广告，因此会受到算法智能优化的影响，若一段时间内大量加载和展示广告，可能导致一段时间后没有广告填充的现象。
    //    -10    EXCEPTION_SIGN_ERROR    appID和appKey不匹配，解决方案：检查APPkey和APPID是否填写正确，APPkey可以在应用设置（APP Setting）模块顶部获取
    //    -9    EXCEPTION_TIMEOUT    请求超时
    //    -1001    The request timed out.    下载视频(zip)等资源/渲染web 超时
    //    -1003    A server with the specified hostname could not be found.    系统回调：无法解析指定host
    //    -1201    EXCEPTION_UNIT_NOT_FOUND    该unitID不存在/填写错误
    //    -1202    EXCEPTION_UNIT_ID_EMPTY    unitID没传
    //    -1203    EXCEPTION_UNIT_NOT_FOUND_IN_APP    在该appID和unitID不匹配
    //    -1205    EXCEPTION_UNIT_ADTYPE_ERROR    传入的unitID广告类型不符
    //    -1301    EXCEPTION_APP_ID_EMPTY    appID没有传入
    //    -1302    EXCEPTION_APP_NOT_FOUND    该appID不存在/填写错误
    //    -1904    EXCEPTION_IV_RECALLNET_INVALIDATE    请求时的网络状态不对，一般是SDK初始化还未完成就去请求导致的
    //    -2102    EXCEPTION_SERVICE_REQUEST_OS_VERSION_REQUIRED    无法取得osVersion，一般是GDPR开关导致的
    //    -2103    EXCEPTION_SERVICE_REQUEST_COUNTRY_CODE_REQUIRED    无法取得countryCode
    //    12930010    Request Time Out    请求广告超时
    //    12930006    Check download file failed via MD5    服务端返回的URL中的md5值与实际文件的md5值不一致
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"-1"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"没有广告填充，可能导致的原因：1.您在测试期间所获取的广告均为Mintegral的正式广告，因此会受到算法智能优化的影响，若一段时间内大量加载和展示广告，可能导致一段时间后没有广告填充的现象。"];
    }else if ([code isEqualToString:@"-10"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"appID和appKey不匹配，解决方案：检查APPkey和APPID是否填写正确，APPkey可以在应用设置（APP Setting）模块顶部获取"];
    }else if ([code isEqualToString:@"-9"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求超时"];
    }else if ([code isEqualToString:@"-1001"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"下载视频(zip)等资源/渲染web 超时"];
    }else if ([code isEqualToString:@"-1003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"系统回调：无法解析指定host"];
    }else if ([code isEqualToString:@"-1201"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"该unitID不存在/填写错误"];
    }else if ([code isEqualToString:@"-1202"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"unitID没传"];
    }else if ([code isEqualToString:@"-1203"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"在该appID和unitID不匹配"];
    }else if ([code isEqualToString:@"-1205"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"传入的unitID广告类型不符"];
    }else if ([code isEqualToString:@"-1301"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"appID没有传入"];
    }else if ([code isEqualToString:@"-1302"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"该appID不存在/填写错误"];
    }else if ([code isEqualToString:@"-1904"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求时的网络状态不对，一般是SDK初始化还未完成就去请求导致的"];
    }else if ([code isEqualToString:@"-2102"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"无法取得osVersion，一般是GDPR开关导致的"];
    }else if ([code isEqualToString:@"-2103"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"无法取得countryCode"];
    }else if ([code isEqualToString:@"12930010"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求广告超时"];
    }else if ([code isEqualToString:@"12930006"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"服务端返回的URL中的md5值与实际文件的md5值不一致"];
    }
    return errorMsg;
}


@end
