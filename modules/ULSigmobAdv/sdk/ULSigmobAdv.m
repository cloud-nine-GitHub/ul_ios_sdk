//
//  ULSigmobAdv.m
//  ulsdkgamedemo
//
//  Created by 一号机雷兽 on 2020/3/2.
//  Copyright © 2020 一号机雷兽. All rights reserved.
//

#import "ULSigmobAdv.h"
#import <WindSDK/WindSDK.h>
#import "ULConfig.h"
#import "ULCop.h"
#import "ULTools.h"
#import "ULNotification.h"
#import "ULNotificationDispatcher.h"
#import "ULSplashViewController.h"
#import "ULGetDeviceId.h"

@interface ULSigmobAdv ()<WindSplashAdDelegate,WindRewardedVideoAdDelegate,WindFullscreenVideoAdDelegate>

@property (nonatomic, strong)NSDictionary *splashJson,*videoJson,*fullscreenJson;
@property (nonatomic,strong) WindSplashAd *splashAd;

//TODO
@property (nonatomic, strong)NSMutableDictionary *advLoadObjByParamDic;
@end


@implementation ULSigmobAdv

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
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_SIGMOB_VIDEO_ADV withSelector:@selector(onShowVideoAdv:) withPriority:PRIORITY_NONE];
    
    [[ULNotificationDispatcher getInstance] addNotificationWithObserver:self withName:UL_NOTIFICATION_MC_SHOW_SIGMOB_FULLSCREEN_ADV withSelector:@selector(onShowFullscreenAdv:) withPriority:PRIORITY_NONE];
    

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
    [self addListener];
    
    NSString *appId = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_sigmob_appid" :@""];
    NSString *appKey = [ULTools GetStringFromDic:[ULConfig getConfigInfo] :@"s_sdk_adv_sigmob_appkey" :@""];
    
    WindAdOptions *options = [WindAdOptions options];
    options.appId = appId;
    options.apiKey = appKey;
    [WindAds startWithOptions:options];
    
    NSLog(@"%s:当前sdk版本号=%@",__func__,WindAds.sdkVersion);
    
    //设置代理
    [[WindRewardedVideoAd sharedInstance] setDelegate:self];
    [WindFullscreenVideoAd sharedInstance].delegate = self;
    
    _advLoadObjByParamDic = [NSMutableDictionary new];
    //获取本地配置的参数
    NSString *videoParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_sigmob_videoid" :@""];
    NSArray *localVideoParams = [videoParamsStr componentsSeparatedByString:@"|"];
    NSArray *videoParamsArray = [self getParamArrayWithModule:@"ULSigmobAdv" withType:@"video" withDefaultValue:localVideoParams];
    for (NSString *param in videoParamsArray) {
        //应该有个参数和广告对象存储的map
        if (![_advLoadObjByParamDic objectForKey:param]) {//该参数已创建对象则无需再次创建
            WindAdRequest *adRequest = [WindAdRequest request];
            [_advLoadObjByParamDic setValue:adRequest forKey:param];
            //预加载广告
            [[WindRewardedVideoAd sharedInstance] loadRequest:adRequest withPlacementId:param];
        }
        
    }
    
    NSString *fullscreenParamsStr = [ULTools GetStringFromDic:[ULConfig getConfigInfo]:@"s_sdk_adv_sigmob_fullscreenid" :@""];
    NSArray *localFullscreenParams = [fullscreenParamsStr componentsSeparatedByString:@"|"];
    NSArray *fullscreenParamsArray = [self getParamArrayWithModule:@"ULSigmobAdv" withType:@"fullscreen" withDefaultValue:localFullscreenParams];
    for (NSString *param in fullscreenParamsArray) {
        //应该有个参数和广告对象存储的map
        if (![_advLoadObjByParamDic objectForKey:param]) {//该参数已创建对象则无需再次创建
            WindAdRequest *adRequest = [WindAdRequest request];
            [_advLoadObjByParamDic setValue:adRequest forKey:param];
            //预加载广告
            [[WindFullscreenVideoAd sharedInstance] loadRequest:adRequest withPlacementId:param];
        }
        
        
        //可以继续封装，不一只一个模块存在预加载的情况
    }
    
}







- (void)onConstructorAdv
{
    NSLog(@"%s",__func__);
    [self setDisableAdvPriorityByArray:@[UL_ADV_INTERSTITIAL,UL_ADV_URL,UL_ADV_GIFT,UL_ADV_ICON,UL_ADV_BANNER,UL_ADV_EMBEDDED]];
}

- (void)showSplashAdv:(NSDictionary *)json
{
    NSLog(@"%s",__func__);
    _splashJson = json;
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *splashId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_sigmob_splashid" withDefaultParam:@"" withSplitString:@"|"];
    _splashAd = [[WindSplashAd alloc] initWithPlacementId:splashId];
    _splashAd.delegate = self;
    _splashAd.userId = [ULGetDeviceId getUniqueDeviceId];
    _splashAd.fetchDelay = 3;//3s内如果广告没有拉取成功，则放弃当次的展示。
    [_splashAd loadAdAndShow];//如果需要底部展示应用logo，可以调用接口loadAdAndShowWithBottomView，传入自定义底部布局
}



- (void)showInterstitialAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
}


- (void)showVideoAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    
    _videoJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *videoId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_sigmob_videoid" withDefaultParam:@"" withSplitString:@"|"];
    
    //获取该参数对应已创建的广告对象
    id windAdRequest = [_advLoadObjByParamDic objectForKey:videoId];
    if (windAdRequest) {
        BOOL isReady = [[WindRewardedVideoAd sharedInstance] isReady:videoId];
        if (isReady) {
            //调用广告对象的show函数
            [[WindRewardedVideoAd sharedInstance] playAd:[ULTools getCurrentViewController] withPlacementId:videoId options:nil error:nil];
                
            }else {
                //调用广告对象的load函数为下次加载
                NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
                [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:@"adv not ready"];
                [self showNextAdv:json :videoId :@"adv not ready"];
                [[WindRewardedVideoAd sharedInstance] loadRequest:windAdRequest withPlacementId:videoId];
            }
    }else{
        //创建请求对象
        WindAdRequest *adRequest = [WindAdRequest request];
        [_advLoadObjByParamDic setValue:adRequest forKey:videoId];
        NSLog(@"%s,%@%@",__func__,videoId,@"对应的广告请求对象不存在");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:@"adv obj not exist"];
        [self showNextAdv:json :videoId :@"adv obj not exist"];
        //加载
        [[WindRewardedVideoAd sharedInstance] loadRequest:adRequest withPlacementId:videoId];
    }
    
    
    
    
}




- (void)showFullscreenAdv:(NSDictionary *)json{
    NSLog(@"%s",__func__);
    _fullscreenJson = json;
    //解析json获取参数类表,获取当前需要请求的广告参数
    NSDictionary *sdkAdvData = [ULTools GetNSDictionaryFromDic:json :@"sdkAdvData" :nil];
    NSArray *paramsArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParams" :nil];
    NSArray *paramProbabilitysArray = [ULTools GetArrayFromDic:sdkAdvData :@"advParamProbabilities" :nil];
    NSString *fullscreenId = [ULTools getRandomParamByCopOrConfigWithParamArray:paramsArray withProbabilityArray:paramProbabilitysArray withParamKey:@"s_sdk_adv_sigmob_fullscreenid" withDefaultParam:@"" withSplitString:@"|"];
    
    //获取该参数对应已创建的广告对象
    id windAdRequest = [_advLoadObjByParamDic objectForKey:fullscreenId];
    if (windAdRequest) {
        BOOL isReady = [[WindFullscreenVideoAd sharedInstance] isReady:fullscreenId];
        if (isReady) {
            //调用广告对象的show函数
            [[WindFullscreenVideoAd sharedInstance] playAd:[ULTools getCurrentViewController] withPlacementId:fullscreenId options:nil error:nil];
                
            }else {
                //调用广告对象的load函数为下次加载
                NSLog(@"%s,%@",__func__,@"广告未准备好或者已过期");
                [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:@"adv not ready"];
                [self showNextAdv:json :fullscreenId :@"adv not ready"];
                [[WindFullscreenVideoAd sharedInstance] loadRequest:windAdRequest withPlacementId:fullscreenId];
            }
    }else{
        //创建请求对象
        WindAdRequest *adRequest = [WindAdRequest request];
        [_advLoadObjByParamDic setValue:adRequest forKey:fullscreenId];
        NSLog(@"%s,%@%@",__func__,fullscreenId,@"对应的广告请求对象不存在");
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:@"adv obj not exist"];
        [self showNextAdv:json :fullscreenId :@"adv obj not exist"];
        //加载
        [[WindFullscreenVideoAd sharedInstance] loadRequest:adRequest withPlacementId:fullscreenId];
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






#pragma mark - WindSplashAdDelegate
/**
 *  开屏广告成功展示
 */
-(void)onSplashAdSuccessPresentScreen:(WindSplashAd *)splashAd
{
    NSLog(@"%s", __func__);
    [self showAdv:_splashJson :splashAd.placementId];
}

/**
 *  开屏广告展示失败
 */
-(void)onSplashAdFailToPresent:(WindSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@", __func__,error);
    //释放广告对象
    splashAd.delegate = nil;
    splashAd = nil;
    
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    //[[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_splashJson :splashAd.placementId :errorMsg];
}


/**
 *  开屏广告点击回调
 */
- (void)onSplashAdClicked:(WindSplashAd *)splashAd
{
    NSLog(@"%s", __func__);
    [self showClicked:_splashJson :splashAd.placementId];
    //sigmob开屏点击后也会回调关闭函数，但并未影响跳转。
}

/**
 *  开屏广告将要关闭回调
 */
- (void)onSplashAdWillClosed:(WindSplashAd *)splashAd
{
    NSLog(@"%s", __func__);
    //释放广告对象
    splashAd.delegate = nil;
    splashAd = nil;
    [[ULSplashViewController getInstance]removeSplashView];
}

/**
 *  开屏广告关闭回调
 */
- (void)onSplashAdClosed:(WindSplashAd *)splashAd
{
    NSLog(@"%s", __func__);//测试未回调
    //释放广告对象
//    splashAd.delegate = nil;
//    splashAd = nil;
//    [[ULSplashViewController getInstance]removeSplashView];
}



#pragma mark - WindRewardedVideoAdDelegate   激励视频和全屏视频使用同一回调

//激励视频广告AdServer返回广告
- (void)onVideoAdServerDidSuccess:(NSString *)placementId
{
    NSLog(@"%s", __func__);
}

//激励视频广告AdServer无广告返回  表示无广告填充
- (void)onVideoAdServerDidFail:(NSString *)placementId
{
    NSLog(@"%s:no ad return",__func__);
}

//物料加载成功  此时isReady=YES
-(void)onVideoAdLoadSuccess:(NSString * _Nullable)placementId
{
    NSLog(@"%s", __func__);
    
}

//开始播放
-(void)onVideoAdPlayStart:(NSString * _Nullable)placementId
{
    NSLog(@"%s", __func__);
    [self pauseSound];
    
    [self showAdv:_videoJson :placementId];
    
    
}

//激励视频广告播放完毕
- (void)onVideoAdPlayEnd:(NSString *)placementId
{
    NSLog(@"%s", __func__);
}


//点击
-(void)onVideoAdClicked:(NSString * _Nullable)placementId
{
    NSLog(@"%s", __func__);
    [self showClicked:_videoJson :placementId];
}

//完成（奖励）  windRewardInfo包含是否完整观看等参数
- (void)onVideoAdClosedWithInfo:(WindRewardInfo * _Nullable)info placementId:(NSString *_Nullable)placementId
{
    NSLog(@"%s", __func__);
    [self resumeSound];
    if (info.isCompeltedView) {
        [self showClose:_videoJson :placementId];
    }else{
        NSLog(@"%s,%@",__func__,@"adv not play complete");
        [self showFailed:_videoJson :placementId :@"adv not play complete"];
        [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:@"adv not play complete"];
    }
    //加载
    [[WindRewardedVideoAd sharedInstance] loadRequest:[_advLoadObjByParamDic objectForKey:placementId] withPlacementId:placementId];
}

//错误
-(void)onVideoError:(NSError *)error placementId:(NSString * _Nullable)placementId
{
    
    
    NSLog(@"%s%@", __func__,error);
    
    
    
}


//视频调用播放时发生错误
- (void)onVideoAdPlayError:(NSError *)error placementId:(NSString * _Nullable)placementId
{
    //这里处理播放出错的逻辑
    NSLog(@"%s%@", __func__,error);
    [self resumeSound];
    
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_videoJson :placementId :errorMsg];
    
    //加载
    [[WindRewardedVideoAd sharedInstance] loadRequest:[_advLoadObjByParamDic objectForKey:placementId] withPlacementId:placementId];
    
}



#pragma mark - WindFullscreenVideoAdDelegate

/**
 激励视频广告物料加载成功（此时isReady=YES）
 广告是否ready请以当前回调为准
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdLoadSuccess:(NSString *)placementId
{
    NSLog(@"%s",__func__);
}


/**
 激励视频广告加载时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdError:(NSError *)error placementId:(NSString *)placementId
{
    NSLog(@"%s%@",__func__,error);
}


/**
 激励视频广告关闭
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdClosed:(NSString *)placementId
{
    NSLog(@"%s",__func__);
    [self resumeSound];
    [[WindFullscreenVideoAd sharedInstance] loadRequest:[_advLoadObjByParamDic objectForKey:placementId] withPlacementId:placementId];
}



/**
 激励视频广告开始播放
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdPlayStart:(NSString *)placementId
{
    NSLog(@"%s",__func__);
    [self pauseSound];
    [self showAdv:_fullscreenJson :placementId];
    
}



/**
 激励视频广告发生点击
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdClicked:(NSString *)placementId
{
    NSLog(@"%s",__func__);
    [self showClicked:_fullscreenJson :placementId];
    
}



/**
 激励视频广告调用播放时发生错误
 
 @param error 发生错误时会有相应的code和message
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdPlayError:(NSError *)error placementId:(NSString *)placementId
{
    NSLog(@"%s%@",__func__,error);
    NSString *errorMsg = [self getAdFailMsgWithCode:[NSString stringWithFormat:@"%ld",error.code]];
    [[ULNotificationDispatcher getInstance] postNotificationWithName:UL_NOTIFICATION_MC_SHOW_SIGMOB_ADV_CALLBACK withData:errorMsg];
    [self showNextAdv:_fullscreenJson :placementId :errorMsg];
    [[WindFullscreenVideoAd sharedInstance] loadRequest:[_advLoadObjByParamDic objectForKey:placementId] withPlacementId:placementId];
}

/**
 激励视频广告视频播关闭
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdPlayEnd:(NSString *)placementId
{
    NSLog(@"%s",__func__);
}


/**
 激励视频广告AdServer返回广告(表示渠道有广告填充)
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdServerDidSuccess:(NSString *)placementId
{
    NSLog(@"%s",__func__);
}


/**
 激励视频广告AdServer无广告返回(表示渠道无广告填充)
 
 @param placementId 广告位Id
 */
- (void)onFullscreenVideoAdServerDidFail:(NSString *)placementId
{
    NSLog(@"%s",__func__);
}


- (NSString *)getAdFailMsgWithCode:(NSString *)code
{
//    | Error Code | Error Message |
//    | --- | --- |
//    | 500420  | 请求的app已经关闭广告服务 |
//    | 500422 | 请求参数缺少设备信息 |
//    | 500424 | 缺少设备id相关信息 |
//    | 500428 | 缺少广告为信息 |
//    | 500430 | 错误的广告位信息 |
//    | 500432 | 广告位不存在，或者appid与广告位不匹配 |
//    | 500433 | 广告位不存在或是已关闭 |
//    | 500435 | 设备的操作系统类型，与请求的app的系统类型不匹配 |
//    | 500436 | 广告单元id与请求的广告类型不匹配 |
//    | 500437 | 缺少idfa。仅（iOS） |
//    | 500473 | 请求的app不存在 |
//    | 500700 | app未设置聚合策略 |
//    | 500701 | app未开通任何广告渠道 |
//    | 200000 | 无广告填充 |
//    | 600100 | 网络出错 |
//    | 600101 | 请求出错 |
//    | 600102 | 未找到该渠道的适配器 |
//    | 600103 | 配置的策略为空 |
//    | 600104 | 文件下载错误 |
//    | 600105 | 下载广告超时 |
//    | 600106 | 聚合通知给开发者的统一错误码，由于多渠道无法区分具体原因。配置单一渠道时使用该渠道错误码。 |
//    | 600107 | 不能在后台调用load |
//    | 600108 | protoBuf协议解析出错 |
//    | 610002 | 激励视频播放出错 |
//    | 610003 | 激励视频广告未准备好 |
//    | 610004 | server下发的广告信息缺失关键信息 |
//    | 610005 | 下载的文件校验md5出错 |
//    | 620002 | 开屏广告不支持当前方向 |
//    | 620003 | 开屏广告不支持的资源类型 |
    NSString *errorMsg = @"";
    if ([code isEqualToString:@"500420"]) {
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求的app已经关闭广告服务"];
    }else if ([code isEqualToString:@"500422"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求参数缺少设备信息"];
    }else if ([code isEqualToString:@"500424"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缺少设备id相关信息"];
    }else if ([code isEqualToString:@"500428"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缺少广告为信息"];
    }else if ([code isEqualToString:@"500430"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@" 错误的广告位信息"];
    }else if ([code isEqualToString:@"500432"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位不存在，或者appid与广告位不匹配"];
    }else if ([code isEqualToString:@"500433"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告位不存在或是已关闭"];
    }else if ([code isEqualToString:@"500435"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"设备的操作系统类型，与请求的app的系统类型不匹配"];
    }else if ([code isEqualToString:@"500436"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"广告单元id与请求的广告类型不匹配"];
    }else if ([code isEqualToString:@"500437"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"缺少idfa。"];
    }else if ([code isEqualToString:@"500473"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求的app不存在"];
    }else if ([code isEqualToString:@"500700"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"app未设置聚合策略"];
    }else if ([code isEqualToString:@"500701"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"app未开通任何广告渠道 "];
    }else if ([code isEqualToString:@"200000"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"无广告填充"];
    }else if ([code isEqualToString:@"600100"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"网络出错"];
    }else if ([code isEqualToString:@"600101"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"请求出错"];
    }else if ([code isEqualToString:@"600102"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"未找到该渠道的适配器"];
    }else if ([code isEqualToString:@"600103"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"配置的策略为空"];
    }else if ([code isEqualToString:@"600104"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"文件下载错误"];
    }else if ([code isEqualToString:@"600105"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"下载广告超时"];
    }else if ([code isEqualToString:@"600106"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"聚合通知给开发者的统一错误码，由于多渠道无法区分具体原因。配置单一渠道时使用该渠道错误码"];
    }else if ([code isEqualToString:@"600107"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"不能在后台调用load"];
    }else if ([code isEqualToString:@"600108"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"protoBuf协议解析出错"];
    }else if ([code isEqualToString:@"610002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"激励视频播放出错"];
    }else if ([code isEqualToString:@"610003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"激励视频广告未准备好"];
    }else if ([code isEqualToString:@"610004"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"server下发的广告信息缺失关键信息"];
    }else if ([code isEqualToString:@"610005"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"下载的文件校验md5出错"];
    }else if ([code isEqualToString:@"620002"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@" 开屏广告不支持当前方向"];
    }else if ([code isEqualToString:@"620003"]){
        errorMsg = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"errorCode = ",code,@";errorMsg = ",@"开屏广告不支持的资源类型"];
    }
    return errorMsg;
}


@end
